//
//  ContentView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI
import WrappingHStack

struct ContentView: View {
    @State var textField: String = ""
    var userViewModel = UserViewModel(name: "Anders")
    var computerViewModel = UserViewModel(name: "A.Iverson", profilePicture: {
        Image(systemName: "face.dashed.fill")
    }())
    @ObservedObject var chatViewModel = ChatView.ViewModel(messageGroups: [.init(user: .init(name: "A.Iverson"), messages: ["Hi, I'm A.Iverson, your personal betting assistant. You can ask me questions about betting or how to use theScore Bet app. You can even ask me to place a bet for you. What can I help you with today?"])])
    @State var userSend = true
    @State var betslip = false
    @State var betMode = false
    
    @ObservedObject var betslipViewModel = BetslipView.ViewModel(bets: [])
    @State var questions: [String] = ["What is a straight bet trying to make this extra a a asdasd adsasdasd?", "What is moneyline?", "How do I place a bet?"]
    @State var questionsHeight: CGFloat = .zero

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        withAnimation {
                            betMode.toggle()
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
                            betslip.toggle()
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
                        
                        betslipViewModel.addBet()
                        
                    }, label: {
                        Text("BET")
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .foregroundColor(.white)
                            .background(.red)
                            .cornerRadius(10)
                    })
                    
                    Button(action: {
                        userSend.toggle()
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

                if betMode {
                    BetModeInfoView()
                        .transition(.move(edge: .top))
                        .zIndex(2)
                }

                Group {
                    ZStack {
                        ChatView(viewModel: chatViewModel, questionsHeight: questionsHeight)

                        questionsView
                    }
                    InputFieldView(userSend: $userSend, textField: $textField, chatViewModel: chatViewModel, users: (user: userViewModel, computer: computerViewModel))
                }
                .padding(.horizontal, 16)
            }
            .background(Color.Theme.background)
            .frame(maxHeight: .infinity)
            
            if betslip {
                BetslipView(viewModel: betslipViewModel)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(1)
                    .transition(.move(edge: .bottom))
                    .edgesIgnoringSafeArea(.bottom)
            }
        }
        
    }
}

extension ContentView {
    var questionsView: some View {
        VStack {
            Spacer()

            WrappingHStack(alignment: .leading, horizontalSpacing: 8, verticalSpacing: 4) {
                ForEach(questions,id: \.self) { question in
                    Button(action: {
                        print(questionsHeight)
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
                        .onChange(of: questions) { value in
                            withAnimation {
                                questionsHeight = proxy.size.height
                            }
                        }
                        .onAppear {
                            questionsHeight = proxy.size.height
                        }
                }
            )
        }
        .padding(.bottom, 4)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
