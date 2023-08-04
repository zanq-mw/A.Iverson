//
//  Colours.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-03.
//

import Foundation
import SwiftUI

extension Color {
    struct Theme {
        static let background = Color("AppBackground")
    }

    struct Input {
        static let border = Color("TextBoxEnabled")
        static let placeholder = Color("TextBoxEnabled")
        static let text = Color(.white)
        static let sendButton = Color("SendButton")
    }

    struct Chat {
        static let user = Color("UserChatBubble")
        static let computer = Color("ComputerChatBubble")
    }

}
