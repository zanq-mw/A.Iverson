//
//  BetslipMoneyAmounts.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct BetslipMoneyAmounts: View {
    let moneyAmounts = [20, 50, 100, 200]
    @ObservedObject var betViewModel: BetslipInputFieldView.ViewModel

    var body: some View {
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
    }
}

//struct BetslipMoneyAmounts_Previews: PreviewProvider {
//    static var previews: some View {
//        BetslipMoneyAmounts()
//    }
//}
