//
//  BetslipView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct BetslipView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var sheetHeight: CGFloat = .zero
    @State private var scrollViewHeight: CGFloat = .zero
    let moneyAmounts = [20, 50, 100, 200]

    var body: some View {
        VStack(spacing: 0) {

            // header
            HStack {
                Text("Betslip")
                    .font(
                        Font.custom("SF Pro Text", size: 18)
                            .weight(.bold)
                    )
                    .foregroundColor(.black)

                Text(String(viewModel.bets.count))
                    .font(Font.custom("SF Pro Text", size: 15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 13)
                    .padding(.vertical, 3)
                    .background(Color(red: 0, green: 0.39, blue: 0.98))
                    .cornerRadius(13)

                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 18)

            ScrollView {

                    VStack {
                        ForEach(viewModel.bets, id: \.date) { bet in

                            //MARK: Title
                            HStack(spacing: 0) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(bet.date)
                                        .font(
                                            Font.custom("SF Pro Text", size: 12)
                                                .weight(.medium)
                                        )
                                        .foregroundColor(.black.opacity(0.65))
                                    Text(bet.title)
                                        .font(
                                            Font.custom("SF Pro Text", size: 14)
                                                .weight(.bold)
                                        )
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .foregroundColor(Color(red: 0, green: 0.39, blue: 0.98))

                            }
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                .inset(by: 0.5)
                                .stroke(.black.opacity(0.08), lineWidth: 1)
                                )
                            .padding(16)

                            //MARK: Bet
                            HStack(alignment: .top) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 14)
                                    .padding(.vertical, 4)

                                VStack(alignment: .leading, spacing: 2) {
                                    Text(bet.betTitle)
                                        .font(
                                        Font.custom("SF Pro Text", size: 16)
                                        .weight(.medium)
                                        )
                                        .foregroundColor(.black)

                                    Text(bet.betDescription)
                                        .font(
                                        Font.custom("SF Pro Text", size: 12)
                                        .weight(.medium)
                                        )
                                        .foregroundColor(.black.opacity(0.65))
                                }

                                Spacer()

                                Text(bet.odds)
                                    .font(
                                    Font.custom("SF Pro Text", size: 16)
                                    .weight(.bold)
                                    )
                                    .multilineTextAlignment(.trailing)
                                    .foregroundColor(.black)
                            }
                            .padding(.horizontal, 16)

                            //MARK: money amounts
                            HStack(spacing: 8) {
                                ForEach(moneyAmounts, id: \.self) { money in
                                    Button(action: {

                                    }, label: {
                                        Text("+$\(money)")
                                            .font(
                                            Font.custom("SF Pro Text", size: 16)
                                            .weight(.bold)
                                            )
                                            .frame(maxWidth: .infinity, alignment: .center)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(Color(red: 0, green: 0.39, blue: 0.98))
                                            .padding(.vertical, 12)
                                            .background(.black.opacity(0.04))
                                            .cornerRadius(4)
                                    })
                                }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)

                            //MARK: bet / towin
                            BetslipInputFieldView(viewModel: bet.inputsViewModel)
                        }
                    }
                }
            //.frame(maxWidth: .infinity, maxHeight: scrollViewHeight.height)
            .background(Color.blue)

            // payout

            HStack {
                Text("PAYOUT")
                    .font(
                    Font.custom("SF Pro Text", size: 12)
                    .weight(.bold)
                    )
                    .foregroundColor(.black)

                Spacer()

                Text("$0.00")
                    .font(Font.custom("SF Pro Text", size: 18).weight(.bold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)



            // placebet
        }
        .presentationDragIndicator(.visible)
        .overlay {
            GeometryReader { geometry in
                Color.clear.preference(key: InnerHeightPreferenceKey.self, value: geometry.size.height)
            }
        }
        .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
            sheetHeight = newHeight
        }
        .presentationDetents([.height(sheetHeight)])
        .background(.white)
    }
}


struct BetslipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BetslipView(viewModel: .init(bets: [.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", multiplier: 1.66, odds: "-100", betAmount: "", toWinAmount: "", date: "Feb 11 · 12:00 PM")]))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Theme.background)
    }
}

extension BetslipView {
    class ViewModel: ObservableObject {
        @Published var bets: [Bet]

        init(bets: [Bet]) {
            self.bets = bets
        }

        func addBet() {
            bets.append(.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", multiplier: 1.66, odds: "-100", betAmount: "", toWinAmount: "", date: "Feb 11 · 12:00 PM"))
            }
    }
}

class Bet: ObservableObject{
    let title: String
    let betTitle: String
    let betDescription: String
    let multiplier: Double
    let odds: String
    let date: String

    @ObservedObject var inputsViewModel: BetslipInputFieldView.ViewModel

    init(title: String, betTitle: String, betDescription: String, multiplier: Double, odds: String, betAmount: String, toWinAmount: String, date: String = Date().description) {
        self.title = title
        self.betTitle = betTitle
        self.betDescription = betDescription
        self.multiplier = multiplier
        self.odds = odds
        self.inputsViewModel = .init(toBet: betAmount, toWin: toWinAmount, multiplier: multiplier)
        self.date = date
    }
}

struct InnerHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
