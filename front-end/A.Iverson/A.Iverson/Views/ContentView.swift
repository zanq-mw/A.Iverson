//
//  ContentView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI
import WrappingHStack

struct ContentView: View {
    @StateObject var viewModel: ViewModel = ViewModel()

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            viewModel.betMode.toggle()
                        }
                    }, label: {
                        Text("MODE")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
                    })

                    Button(action: {
                        withAnimation {
                            viewModel.betslip.toggle()
                        }
                    }, label: {
                        Text("BETSLIP")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(.blue)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        
                        viewModel.betslipViewModel.addBet()
                        
                    }, label: {
                        Text("BET")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        viewModel.userSend.toggle()
                        //questions.append("Test question 123 ?")
                    }, label: {
                        Text("MESSAGES")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(10)
                    })
                }
                .frame(maxWidth: .infinity)
                .background(Color.Theme.background)
                .zIndex(3)

                if viewModel.betMode {
                    BetModeInfoView()
                        .transition(.move(edge: .top))
                        .zIndex(2)
                }

                Group {
                    ZStack {
                        ChatView(viewModel: viewModel.chatViewModel, questionsHeight: viewModel.questionsHeight)

                        extraChatViews
                    }
                    InputFieldView(textField: $viewModel.textField) {
                        viewModel.sendMessage(user: viewModel.userViewModel)
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color.Theme.background)
            .frame(maxHeight: .infinity)
            
            if viewModel.betslip {
                BetslipView(viewModel: viewModel.betslipViewModel)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        
    }
}

extension ContentView {
    var extraChatViews: some View {
        VStack {
            Spacer()

            WrappingHStack(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 4) {
                ForEach(viewModel.questions, id: \.self) { question in
                    Button(action: {
                        viewModel.askQuestion(question)
                    }, label: {
                        Text(question)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(.white)
                            .font(
                                Font.custom("SF Pro Text", size: 14)
                                    .weight(.medium)
                            )
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(.gray)
                            .cornerRadius(8)
                    })
                }
            }
            .padding(.top, 8)
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onChange(of: viewModel.questions) { value in
                            withAnimation {
                                viewModel.questionsHeight = proxy.size.height
                            }
                        }
                        .onAppear {
                            viewModel.questionsHeight = proxy.size.height
                        }
                }
            )

            
        }
        .padding(.bottom, 4)
    }
}

extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        var userViewModel = UserViewModel(name: "Anders")
        var computerViewModel = UserViewModel(name: "A.Iverson", profilePicture: {
            Image(systemName: "face.dashed.fill")
        }())
        @Published var userSend = true

        @Published var textField: String = ""
        @Published var chatViewModel = ChatView.ViewModel(messageGroups: [.init(user: .init(name: "A.Iverson"), messages: ["Hi, I'm A.Iverson, your personal betting assistant. You can ask me questions about betting or how to use theScore Bet app. You can even ask me to place a bet for you. What can I help you with today?"])])

        @Published var betslip = false
        @Published var betMode = false
        @Published var betslipViewModel = BetslipView.ViewModel(bets: [])

        @Published var questions: [String] = ["I want to bet on Raptors scoring 16 points", "What is moneyline?", "How do I place a bet?"]
        @Published var questionsHeight: CGFloat = .zero
        @Published var hideQuestions: Bool = false

        @Published var server = API()
        @Published var botTyping = false

        func currentUser() -> UserViewModel {
            userSend ? userViewModel : computerViewModel
        }

        init() {
            bindServer()
        }

        func bindServer() {
            server.viewModel = self
        }

        func sendMessage(user: UserViewModel) {
            chatViewModel.send(textField, user: user)
            botTyping = true
            Task {
                let response = await server.message(textField)
                if let response {
                    if let botQuestions = response.suggested_prompts {
                        questions = botQuestions
                        hideQuestions = false
                    }

                    if let betData = response.bet {
                        betslipViewModel.addBet(betData)
                        betslip = true
                    }

                    betMode = false
                    if .bet == response.mode {
                        betMode = true
                    }

                    questions = response.suggested_prompts ?? []

                    chatViewModel.send(response.bot_message, user: computerViewModel)
                    textField = ""
                    botTyping = false
                }
            }
        }

        func askQuestion(_ question: String) {
            textField = question
            withAnimation {
                hideQuestions = true
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
