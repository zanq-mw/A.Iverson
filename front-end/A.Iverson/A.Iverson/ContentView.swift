//
//  ContentView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI

struct ContentView: View {
    @State var textField: String = ""
    @State var messages: [MessageView.ViewModel] = []

    enum Constants {
        static let textBoxHeight: CGFloat = 33.0
        static let textBoxSmall: CGFloat = 6
        static let textBoxLarge: CGFloat = 14
    }

    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    Spacer()

                    ForEach(messages, id: \.id) { message in
                        MessageView(viewModel: message)
                    }
                }
            }

            // MARK: INPUT FIELD
            HStack(alignment: .bottom, spacing: 8) {
                ZStack(alignment: .leading) {
                    if textField.isEmpty {
                        Text("Type a message...")
                            .foregroundColor(InputField.placeholder)
                    }

                    TextField("", text: $textField, axis: .vertical)
                        .frame(minHeight: Constants.textBoxHeight)
                        .foregroundColor(InputField.text)
                        .disableAutocorrection(true)
                }

                if !textField.isEmpty {
                    Button(action: {
                        messages.append(.init(user: .user, text: textField))
                        textField = ""
                    }, label: {
                        ZStack (alignment: .center) {
                            Circle()
                                .foregroundColor(InputField.sendButton)

                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 20)
                                .foregroundColor(.white)
                                .offset(x: -2)
                        }
                        .frame(height: Constants.textBoxHeight)
                    })
                }
            }
            .padding(.vertical, Constants.textBoxSmall)
            .padding(.trailing, Constants.textBoxSmall)
            .padding(.leading, Constants.textBoxLarge)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(InputField.border, lineWidth: 1)
                    .frame(minHeight: Constants.textBoxHeight)
            )
        }
        .padding()
        .background(Default.background)
        .frame(maxHeight: .infinity)

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
