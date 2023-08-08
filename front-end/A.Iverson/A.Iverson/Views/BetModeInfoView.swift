//
//  BetModeInfoView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-05.
//

import SwiftUI

struct BetModeInfoView: View {
    @State var info: Bool = false

    var body: some View {
        HStack {
            Group {
                if info {
                    Text("A. Inverson will help you create and fill out a betslip. Please finish the bet before asking new questions. To abandon this bet and exit bet mode, say 'EXIT'.")
                        .font(
                            Font.custom("SF Pro Text", size: 12)
                                .weight(.medium)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("You are currently in Bet Mode.")
                        .font(
                            Font.custom("SF Pro Text", size: 12)
                                .weight(.medium)
                        )
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

            Button(action: {
                withAnimation {
                    info.toggle()
                }
            }, label: {
                if info {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                } else {
                    Image(systemName: "info.circle")
                        .foregroundColor(.black)
                }
            })
        }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(red: 1, green: 0.8, blue: 0))
    }
}

struct BetModeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        BetModeInfoView()
    }
}
