//
//  BetModel.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-05.
//

import Foundation

class Bet: ObservableObject, Equatable {
    let id = UUID()
    let title: String
    let betTitle: String
    let betDescription: String
    let multiplier: Double
    let odds: String
    let date: String

    @Published var betViewModel: BetslipInputFieldView.ViewModel
    @Published var winViewModel: BetslipInputFieldView.ViewModel

    init(title: String, betTitle: String, betDescription: String, multiplier: Double, odds: String, betAmount: Double, toWinAmount: Double, date: String = Date().description) {
        self.title = title
        self.betTitle = betTitle
        self.betDescription = betDescription
        self.multiplier = multiplier
        self.odds = odds
        self.date = date

        betViewModel = .init(title: "Bet", field: .bet, text: String(format: "$%.2f", betAmount)) {}
        winViewModel = .init(title: "To Win", field: .win, text: String(format: "$%.2f", toWinAmount)) {}
    }

    func getPayoutValue() -> Double {
        return betViewModel.text.toDollars + winViewModel.text.toDollars
    }

    func getCost() -> Double {
        return betViewModel.text.toDollars
    }

//    func updateWin() {
//        let newText = betViewModel.text.toDollars * multiplier
//        if winViewModel.text.toDollars != newText {
//            winViewModel.text = String(newText)
//        }
//    }
//
//    func updateBet() {
//        let newText = winViewModel.text.toDollars * (1.0/multiplier)
//        if betViewModel.text.toDollars != newText {
//            betViewModel.text = String(newText)
//        }
//    }

    static func == (lhs: Bet, rhs: Bet) -> Bool {
        return lhs.id == rhs.id
    }
}
