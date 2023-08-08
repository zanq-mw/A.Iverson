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
                HStack(spacing: 20) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 15)
                        .foregroundColor(.white)
                        .padding(.leading, 20)


                    Text("A.Iverson")
                        .foregroundColor(.white)
                        .font(.custom("SF_Pro_Text", size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

//                    Image(systemName: "info.circle")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(height: 20)
//                        .foregroundColor(.white)
//                        .padding(.trailing, 20)

                }
                .padding(.top, 8)
//                HStack {
//                    Button(action: {
//                        withAnimation {
//                            viewModel.betMode.toggle()
//                        }
//                    }, label: {
//                        Text("MODE")
//                            .padding(.vertical, 5)
//                            .padding(.horizontal, 10)
//                            .foregroundColor(.white)
//                            .background(.blue)
//                            .cornerRadius(10)
//                    })
//
//                    Button(action: {
//                        withAnimation {
//                            viewModel.betslip.toggle()
//                        }
//                    }, label: {
//                        Text("BETSLIP")
//                            .padding(.vertical, 5)
//                            .padding(.horizontal, 10)
//                            .foregroundColor(.white)
//                            .background(.blue)
//                            .cornerRadius(10)
//                    })
//
//                    Button(action: {
//
//                        viewModel.betslipViewModel.addBet()
//
//                    }, label: {
//                        Text("BET")
//                            .padding(.vertical, 5)
//                            .padding(.horizontal, 10)
//                            .foregroundColor(.white)
//                            .background(.red)
//                            .cornerRadius(10)
//                    })
//
//                    Button(action: {
//                        //viewModel.userSend.toggle()
//                        print(viewModel.botTyping)
//                    }, label: {
//                        Text("MESSAGES")
//                            .padding(.vertical, 5)
//                            .padding(.horizontal, 10)
//                            .foregroundColor(.black)
//                            .background(.white)
//                            .cornerRadius(10)
//                    })
//                }
//                .frame(maxWidth: .infinity)
//                .background(Color.Theme.background)
//                .zIndex(3)

                if viewModel.betMode {
                    BetModeInfoView()
                        .transition(.move(edge: .leading))
                        .zIndex(2)
                }

                Group {
                    ZStack {
                        ChatView(viewModel: viewModel.chatViewModel, questionsHeight: viewModel.questionsHeight)

                        VStack(spacing: 0) {
                            Spacer()

                            if viewModel.botTyping {
                                Text("A.Iverson is typing...")
                                    .font(
                                        Font.custom("SF_Pro_Text", size: 12)
                                            .weight(.medium)
                                    )
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(Color.Input.border)
                                    .transition(.move(edge: .bottom))
                            }

                            if !viewModel.hideQuestions {
                                suggestedQuestions
                                    .transition(.move(edge: .leading))
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.questions, id: \.self) { question in
                    Button(action: {
                        viewModel.askQuestion(question)
                        withAnimation {
                            viewModel.hideQuestions = true
                        }
                        viewModel.sendMessage(user: viewModel.userViewModel)
                    }, label: {
                        Text(question)
                            .multilineTextAlignment(.leading)
                            .fixedSize(horizontal: false, vertical: true)
                            .foregroundColor(Color.Chat.user)
                            .font(
                                Font.custom("SF_Pro_Text_Bold", size: 16)

                            )
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            //.background(.gray)
                            //.cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .inset(by: 0.5)
                                    .stroke(Color.Chat.user, lineWidth: 1)

                            )
                    })
                }
            }
        }
        .padding(.top, 8)
        .background(
            GeometryReader { proxy in
                Color.clear
                    .onChange(of: viewModel.questions) { value in
                        withAnimation {
                            viewModel.questionsHeight = proxy.size.height + 8
                        }
                    }
                    .onAppear {
                        viewModel.questionsHeight = proxy.size.height + 8
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
            Image("Icon")
        }())
        @Published var userSend = true

        @Published var textField: String = ""
        @Published var chatViewModel = ChatView.ViewModel(messageGroups: [])

        @Published var betslip = false
        @Published var betMode = false
        @Published var betslipViewModel = BetslipView.ViewModel(bets: [])

        @Published var questions: [String] = ["How do I place a bet?", "Place a bet!", "What is moneyline?", "How do I place a bet?"]
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
            withAnimation {
                chatViewModel.send(textField, user: user)
                botTyping = true
            }
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
                        try? await Task.sleep(nanoseconds: 3_000_000_000)

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
