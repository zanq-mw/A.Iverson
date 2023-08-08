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
                        //viewModel.userSend.toggle()
                        print(viewModel.botTyping)
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

                        VStack {
                            Spacer()

                            suggestedQuestions

                            if viewModel.botTyping {
                                Text("A.Iverson is typing...")
                                    .font(
                                        Font.custom("SF Pro Text", size: 12)
                                            .weight(.medium)
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.Input.border)
                            }
                        }
                        .padding(.bottom, 4)
                    }
                    HStack {
                        if viewModel.betslipViewModel.bets.isNotEmpty {
                            Button(action: {
                                withAnimation {
                                    if viewModel.betslipViewModel.bets.isNotEmpty {
                                        viewModel.betslip = true
                                    }
                                }
                            }, label: {
                                ZStack (alignment: .center) {
                                    Circle()
                                        .foregroundColor(.Input.sendButton)

                                    Image(systemName: "newspaper.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 18)
                                        .foregroundColor(.white)
                                        .offset(x: -1)
                                }
                                .frame(height: 33)
                            })
                        }

                        InputFieldView(textField: $viewModel.textField) {
                            withAnimation {
                                viewModel.sendMessage(user: viewModel.userViewModel)
                            }
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .background(Color.Theme.background)
            .frame(maxHeight: .infinity)
            
            if viewModel.betslip {
                BetslipView(viewModel: viewModel.betslipViewModel, showBetslip: $viewModel.betslip)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        .task {
            await startMessage()
        }
        
    }

    private func startMessage() async {
        withAnimation {
            viewModel.botTyping = true
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        withAnimation {
            viewModel.chatViewModel.send("Hi, I'm A.Iverson, your personal betting assistant. You can ask me questions about betting or how to use theScore Bet app. You can even ask me to place a bet for you. What can I help you with today?", user: viewModel.computerViewModel)
            viewModel.botTyping = false
        }
    }

}


//extension ContentView {
//    var typingIndicator: some View {
//        Group {
//
//            } else {
//                EmptyView()
//            }
//        }
//    }
//}

extension ContentView {
    var suggestedQuestions: some View {
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
}

// MARK: - VIEWMODEL
extension ContentView {
    @MainActor
    class ViewModel: ObservableObject {
        var userViewModel = UserViewModel(name: "Anders")
        var computerViewModel = UserViewModel(name: "A.Iverson", profilePicture: {
            Image(systemName: "face.dashed.fill")
        }())
        @Published var userSend = true

        @Published var textField: String = ""
        @Published var chatViewModel = ChatView.ViewModel(messageGroups: [])

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
            let tempText = textField
            textField = ""

            Task {
                let response = await server.message(tempText)
                try? await Task.sleep(nanoseconds: 1_000_000_000)

                if let response {
                    let mode = .bet == response.mode
                    if mode != betMode {
                        withAnimation {
                            betMode = mode
                        }
                    }

                    withAnimation {
                        hideQuestions = false
                        questions = response.suggested_prompts ?? []
                    }

                    withAnimation {
                        chatViewModel.send(response.bot_message, user:computerViewModel)
                    }

                    withAnimation {
                        botTyping = false

                    }

                    if let betData = response.bet {
                        try? await Task.sleep(nanoseconds: 5_000_000_000)

                        withAnimation {
                            betslipViewModel.addBet(betData)
                            betslip = true
                        }
                    }
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
