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
                ScrollView(showsIndicators: false) {
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
                .frame(height: min(betsHeight, UIScreen.screenHeight * 0.7))

                Divider()

                //MARK: Payout
                payout

                //MARK: - Place Bet
                placeBetButton
            }
            .padding(.bottom, safeAreaInsets.bottom)
            .background(.white, ignoresSafeAreaEdges: .bottom)
            .cornerRadius(12, corners: [.topLeft, .topRight])
        }
    }
}

//MARK: - HEADER
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

// MARK: - PAYOUT
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

            Text(String(format: "$%.2f", viewModel.payoutValue))
                .font(Font.custom("SF Pro Text", size: 18).weight(.bold))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}

extension BetslipView {
    @ViewBuilder
    var placeBetButton: some View {
        Button(action: {
            withAnimation {
                viewModel.bets = []
            }
        }, label: {
            HStack {
                Text(String(format: "Place Bet $%.2f", viewModel.payoutValue))
                    .font(
                    Font.custom("SF Pro Text", size: 16)
                    .weight(.bold)
                    )
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .background(Color(red: 0, green: 0.39, blue: 0.98))
            .cornerRadius(4)
        })
        .padding(.horizontal, 8)
    }
}

// MARK: - VIEWMODEL
extension BetslipView {
    class ViewModel: ObservableObject {
        @Published var bets: [Bet] {
            didSet {
                payoutValue = 0
                bets.forEach { bet in
                    payoutValue += bet.getPayoutValue()
                    cost += bet.getCost()
                }
            }
        }
        @Published var payoutValue: Double = 0
        @Published var cost: Double = 0

        init(bets: [Bet]) {
            self.bets = bets
        }

        func addBet() {
            withAnimation {
                bets.append(.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", multiplier: 1.66, odds: "-100", betAmount: 50.00, toWinAmount: 26.21, date: "Feb 11 · 12:00 PM"))
            }
        }

        func addBet(_ betData: FinalBetData) {

            withAnimation {
                bets.append(.init(title: betData.game_title, betTitle: betData.bet_title, betDescription: betData.bet_description, multiplier: 1, odds: String(betData.odds), betAmount: betData.bet_amount, toWinAmount: betData.to_win))
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

struct BetslipView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            BetslipView(viewModel: .init(bets: [.init(title: "TB Buccaneers @ MIA Dolphins", betTitle: "TB Buccaneers", betDescription: "Moneyline", multiplier: 1.66, odds: "-100", betAmount: 0, toWinAmount: 0, date: "Feb 11 · 12:00 PM")]))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.Theme.background)
    }
}
