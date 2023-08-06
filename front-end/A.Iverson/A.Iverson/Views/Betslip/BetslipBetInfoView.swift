//
//  BetslipBetInfoView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-05.
//

import SwiftUI

struct BetslipBetInfoView: View {
    let bet: Bet
    let closeAction: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Button(action: {
                closeAction()
            }, label: {
                Image(systemName: "xmark")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .padding(.vertical, 4)
            })

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
    }
}

//struct BetslipBetInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetslipBetInfoView()
//    }
//}
