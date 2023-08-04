//
//  UserViewModel.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import Foundation
import SwiftUI

class UserViewModel: Equatable {
    let id: UUID = UUID()
    let name: String
    var profilePicture: Image?

    init(name: String, profilePicture: Image? = nil) {
        self.name = name
        self.profilePicture = profilePicture
    }

    var background: Color {
        name != "A.Iverson" ? Color.Chat.user : Color.Chat.computer
    }

    static func ==(lhs: UserViewModel, rhs: UserViewModel) -> Bool {
        return lhs.name == rhs.name
    }

}
