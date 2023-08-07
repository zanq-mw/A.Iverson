//
//  String.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-05.
//

import Foundation
extension String {
    var toDollars: Double {
        let allowedCharset = CharacterSet(charactersIn: "0123456789.")

        let filteredText = "\(self.unicodeScalars.filter(allowedCharset.contains))"

        return Double(filteredText) ?? 0
    }
}
