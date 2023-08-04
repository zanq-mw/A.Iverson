//
//  ChatView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(viewModel.messageGroups, id: \.id) { groupViewModel in
                    MessageGroupView(viewModel: groupViewModel)
                }
            }
        }
    }
}

extension ChatView {
    class ViewModel: ObservableObject {
        @Published var messageGroups: [MessageGroupView.ViewModel]

        init(messageGroups: [MessageGroupView.ViewModel]) {
            self.messageGroups = messageGroups
        }

        func send(_ message: String, user: UserViewModel) {
            if let lastMessage = messageGroups.last, lastMessage.user == user {
                lastMessage.messages.append(message)
            } else {
                messageGroups.append(MessageGroupView.ViewModel(user: user, messages: [message]))
            }
        }
    }
}

extension UIRectCorner {
    static let notBottomLeft: UIRectCorner = [.bottomRight, .topLeft, .topRight]
    static let notBottomRight: UIRectCorner = [.bottomLeft, .topLeft, .topRight]
}

//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView()
//    }
//}
