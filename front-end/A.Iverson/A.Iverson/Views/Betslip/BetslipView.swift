//
//  BetslipView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct BetslipView: View {
    @ObservedObject var viewModel: ViewModel
    @State private var betslipHeight: CGFloat = .zero
    @State private var betsHeight: CGFloat = .zero
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
        if viewModel.bets.isEmpty {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                header

                // MARK: Individual Bets
                ScrollView {
                    VStack {
                        ForEach(viewModel.bets, id: \.id) { bet in
                            //MARK: Bet Title
                            BetslipBetTitleView(bet: bet)

                            //MARK: Bet Info
                            BetslipBetInfoView(bet: bet, closeAction: {
                                withAnimation {
                                    viewModel.bets = viewModel.bets.filter { b in
                                        return b.id != bet.id
                                    }
                                }
                            })

                            //MARK: Money Amounts
                            BetslipMoneyAmounts(betViewModel: bet.betViewModel)

                            //MARK: Bet / To Win
                            HStack {
                                BetslipInputFieldView(viewModel: bet.betViewModel)
                                BetslipInputFieldView(viewModel: bet.winViewModel)
                            }
                            .padding(.bottom, 16)
                        }
                    }
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .onChange(of: viewModel.bets) { value in
                                    withAnimation {
                                        betsHeight = proxy.size.height
                                    }
                                }
                                .onAppear {
                                    betsHeight = proxy.size.height
                                }
                        }
                    )
                }
                .frame(height: min(betsHeight, UIScreen.screenHeight * 0.75 ))

                //MARK: Payout
                Divider()

                payout

                // placebet
                Button(action: {

                }, label: {

                })
            }
            .padding(.bottom, safeAreaInsets.bottom)
            .background(.white, ignoresSafeAreaEdges: .bottom)
            .cornerRadius(12, corners: [.topLeft, .topRight])
        }
    }
}

extension BetslipView {
    @ViewBuilder
    var header: some View {
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
        .padding(18)
    }
}

extension BetslipView {
    @ViewBuilder
    var payout: some View {
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
    }
}

struct BetslipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BetslipView(viewModel: .init(bets: [.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", odds: "-100", betAmount: "", toWinAmount: "", date: "Feb 11 · 12:00 PM")]))
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
            withAnimation {
                bets.append(.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", odds: "-100", betAmount: "", toWinAmount: "", date: "Feb 11 · 12:00 PM"))
            }
        }

        func removeBet(id: UUID) {
            withAnimation {
                bets = bets.filter { b in
                    return b.id != id
                }
            }
        }
    }
}

class Bet: ObservableObject, Equatable {
    let id = UUID()
    let title: String
    let betTitle: String
    let betDescription: String
    let odds: String
    let date: String
    
    @ObservedObject var betViewModel: BetslipInputFieldView.ViewModel
    @ObservedObject var winViewModel: BetslipInputFieldView.ViewModel

    init(title: String, betTitle: String, betDescription: String, odds: String, betAmount: String, toWinAmount: String, date: String = Date().description) {
        self.title = title
        self.betTitle = betTitle
        self.betDescription = betDescription
        self.odds = odds
        self.date = date

        self.betViewModel = .init(title: "Bet", field: .bet, text: "50")
        self.winViewModel = .init(title: "To Win", field: .win, text: "0")
    }

    static func == (lhs: Bet, rhs: Bet) -> Bool {
        return lhs.id == rhs.id
    }
}
