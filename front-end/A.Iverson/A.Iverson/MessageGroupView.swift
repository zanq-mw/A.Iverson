//
//  MessageGroupView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI

struct MessageGroupView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(alignment: viewModel.isUser ? .trailing : .leading, spacing: Dimensions.Chat.groupSpacing) {
            Text(viewModel.user.name)
                .font(Font.custom("SF Pro Text", size: 12))
                .foregroundColor(.white.opacity(0.5))
                .padding(.bottom, 2)
            
            ForEach(viewModel.messages, id: \.self) { message in
                Text(message)
                    .foregroundColor(.white)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 8)
                    .background(viewModel.background)
                    .cornerRadius(12, corners: viewModel.roundCorners)
                    .cornerRadius(2, corners: viewModel.sharpCorners)
                    .frame(width: 250, alignment: viewModel.isUser ? .trailing : .leading)
            }
        }
        .frame(maxWidth: .infinity, alignment: viewModel.isUser ? .trailing : .leading)
    }
}

struct MessageGroupView_Previews: PreviewProvider {
    static var previews: some View {
        VStack (alignment: .center, spacing: Dimensions.Chat.spacing) {
            MessageGroupView(viewModel: .init(user: .init(name: "Anders"), messages: ["test Message is cool and really really long long long long long long long long long lon g", "This is a second message"]))
            MessageGroupView(viewModel:.init(user: .init(name: "A.Iverson"), messages: ["test Message is cool"]))
        }
        .padding()
        .background(Color.basic.background)
    }
}

extension MessageGroupView {
    class ViewModel: ObservableObject {
        let id = UUID()
        let date = Date()
        let user: UserViewModel
        @Published var messages: [String]

        init(user: UserViewModel, messages: [String]) {
            self.user = user
            self.messages = messages
        }

        var isUser: Bool {
            self.user.name != "A.Iverson"
        }

        var roundCorners: UIRectCorner {
            isUser ? .notBottomRight : .notBottomLeft
        }

        var sharpCorners: UIRectCorner {
            isUser ? .bottomRight : .bottomLeft
        }

        var background: Color {
            user.background
        }
    }
}

