//
//  InputFieldView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct InputFieldView: View {
    @Binding var textField: String
    let sendAction: () -> Void

    enum Constants {
        static let textBoxHeight: CGFloat = 33.0
        static let textBoxSmall: CGFloat = 6
        static let textBoxLarge: CGFloat = 14
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ZStack(alignment: .leading) {
                if textField.isEmpty {
                    Text("Type a message...")
                        .foregroundColor(.Input.placeholder)
                }

                TextField("", text: $textField, axis: .vertical)
                    .frame(minHeight: Constants.textBoxHeight)
                    .foregroundColor(.Input.text)
                    .disableAutocorrection(true)
            }

            if !textField.isEmpty {
                Button(action: {
                    sendAction()
                }, label: {
                    ZStack (alignment: .center) {
                        Circle()
                            .foregroundColor(.Input.sendButton)

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
                .stroke(Color.Input.border, lineWidth: 1)
                .frame(minHeight: Constants.textBoxHeight)
        )
    }
}

//struct InputField_Previews: PreviewProvider {
//    static var previews: some View {
//        InputField()
//    }
//}
