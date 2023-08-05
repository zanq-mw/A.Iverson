//
//  BetslipBetTitleView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-05.
//

import SwiftUI

struct BetslipBetTitleView: View {
    let bet: Bet

    var body: some View {
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
        .padding([.horizontal, .bottom], 16)
    }
}

//struct BetslipBetTitleView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetslipBetTitleView()
//    }
//}
