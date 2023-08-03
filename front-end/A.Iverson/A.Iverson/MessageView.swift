//
//  MessageView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import SwiftUI

struct MessageView: View {
    let viewModel: ViewModel

    var body: some View {
        Text(viewModel.text)
            .foregroundColor(.white)
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(.blue)
            .cornerRadius(17, corners: viewModel.user == .computer ? [.topLeft, .topRight, .bottomRight] : [.topLeft, .topRight, .bottomLeft])
            .cornerRadius(2, corners: viewModel.user == .computer ? [.bottomLeft] : [.bottomRight])
    }
}

struct MessageView_Previews: PreviewProvider {
    static var previews: some View {
        MessageView(viewModel: .init(user: .computer, text: "testtest"))
    }
}

extension MessageView {
    struct ViewModel {
        let id = UUID()
        var user: User
        var text: String
    }
}


enum User {
    case user
    case computer
}
