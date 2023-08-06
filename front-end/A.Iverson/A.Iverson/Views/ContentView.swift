//
//  ContentView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI

struct ContentView: View {
    @State var textField: String = ""
    var userViewModel = UserViewModel(name: "Anders")
    var computerViewModel = UserViewModel(name: "A.Iverson", profilePicture: {
        Image(systemName: "face.dashed.fill")
    }())
    @ObservedObject var chatViewModel = ChatView.ViewModel(messageGroups: [])
    @State var userSend = true
    @State var betslip = false
    @State var betMode = false
    
    @ObservedObject var betslipViewModel = BetslipView.ViewModel(bets: [])
    
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
                    ChatView(viewModel: chatViewModel)

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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
