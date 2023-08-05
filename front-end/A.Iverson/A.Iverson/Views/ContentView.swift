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

    @ObservedObject var betslipViewModel = BetslipView.ViewModel(bets: [])

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    betslip.toggle()
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
            
            ChatView(viewModel: chatViewModel)

            InputFieldView(userSend: $userSend, textField: $textField, chatViewModel: chatViewModel, users: (user: userViewModel, computer: computerViewModel))
        }
        .padding()
        .background(Color.Theme.background)
        .frame(maxHeight: .infinity)
        .sheet(isPresented: $betslip) {
            BetslipView(viewModel: betslipViewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}