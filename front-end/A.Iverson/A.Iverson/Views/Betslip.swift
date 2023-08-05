//
//  Betslip.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct BetslipView: View {
    @ObservedObject var viewModel: ViewModel
    var body: some View {
        VStack(spacing: 0) {
            // grey pill


            // header


            // title

            // bet

            // money amounts

            // bet / towin

            // payout

            // placebet
        }
    }
}

struct BetslipView_Previews: PreviewProvider {
    static var previews: some View {
        BetslipView(viewModel: .init())
    }
}

extension BetslipView {
    class ViewModel: ObservableObject {

    }
}
