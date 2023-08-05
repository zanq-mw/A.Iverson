//
//  BetslipInputFieldView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

struct BetslipInputFieldView: View {
    enum BetslipInputField: String {
        case bet
        case win
    }
    @ObservedObject var viewModel: ViewModel
    @FocusState var focusedField: BetslipInputField?

    var body: some View {
        HStack(spacing: 8) {
            // MARK: TO BET
            VStack(alignment: .leading, spacing: 0) {
                Text("Bet")
                    .font(Font.custom("SF Pro Text", size: 12))
                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        print(focusedField)
                    }

                HStack(spacing: 0) {
                    Text("$")
                        .lineLimit(1)

                    ZStack(alignment: .leading) {
                        // Value placeholder - 0.00
                        if viewModel.toBet == "" {
                            Text("0.00")
                                .lineLimit(1)
                                .font(
                                    Font.custom("SF Pro Text", size: 16)
                                        .weight(.medium)
                                )
                                .foregroundColor(.black)

                        }

                        TextField("", text: $viewModel.toBet)
                            .focused($focusedField, equals: .bet)
                            .font(
                                Font.custom("SF Pro Text", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(.black)

                    }
                }
                .textFieldStyle(.plain)
                .keyboardType(.decimalPad)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(focusedField == .bet ? Color(red: 0, green: 0.39, blue: 0.98) : Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
            )

            //MARK: TO WIN
            VStack(alignment: .leading, spacing: 0) {
                Text("To Win")
                    .font(Font.custom("SF Pro Text", size: 12))
                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onTapGesture {
                        print(focusedField)
                    }

                HStack(spacing: 0) {
                    Text("$")
                        .lineLimit(1)

                    ZStack(alignment: .leading) {
                        // Value placeholder - 0.00
                        if viewModel.toWin == "" {
                            Text("0.00")
                                .lineLimit(1)
                                .font(
                                    Font.custom("SF Pro Text", size: 16)
                                        .weight(.medium)
                                )
                                .foregroundColor(.black)

                        }

                        TextField("", text: $viewModel.toWin)
                            .focused($focusedField, equals: .win)
                            .font(
                                Font.custom("SF Pro Text", size: 16)
                                    .weight(.medium)
                            )
                            .foregroundColor(.black)

                    }
                }
                .textFieldStyle(.plain)
                .keyboardType(.decimalPad)
                .autocorrectionDisabled()
                .autocapitalization(.none)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 4)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(focusedField == .win ? Color(red: 0, green: 0.39, blue: 0.98) : Color(red: 0.75, green: 0.75, blue: 0.75), lineWidth: 1)
            )
        }
        .onChange(of: focusedField) { focus in
            viewModel.focus = focus
        }
        .padding(.horizontal, 16)
    }
}

// MARK: - ViewModel
extension BetslipInputFieldView {
    class ViewModel: ObservableObject {
        let multiplier: Double
        let decimalSeparator = "."
        let groupingSeparator = ","

        @Published var focus: BetslipInputField? {
            didSet {
                toBet = formattedDollarAmount(toBet, field: focus)
                toWin = formattedDollarAmount(toWin, field: focus)
            }
        }
        @Published var toBet: String {
            didSet {
                guard oldValue != toBet else { return }

                toBet = formattedDollarAmount(toBet, field: focus)
            }
        }
        @Published var toWin: String {
            didSet {
                guard oldValue != toWin else { return }

                toWin = formattedDollarAmount(toWin, field: focus)
            }
        }
        

        init(toBet: String, toWin: String, multiplier: Double) {
            self.toBet = toBet
            self.toWin = toWin
            self.multiplier = multiplier
        }

        private lazy var editingNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.currencyCode = "USD"
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 0
            formatter.minimumIntegerDigits = 1
            return formatter
        }()

        private lazy var nonEditingNumberFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.currencyCode = "USD"
            formatter.numberStyle = .currency
            formatter.currencySymbol = ""
            formatter.usesGroupingSeparator = true
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
            return formatter
        }()

        func formattedDollarAmount(_ text: String, field: BetslipInputField?) -> String {
            // Stripping the text of everything non number related (dollar signs, commas, and the possibility the user ever pastes in the field)
            let workingText = text.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()

            // If user is not editing just format using the number formatter and add commas
            if (field != focus || focus == nil),
               let dollarsDouble = Double(workingText),
               let formattedDollars = nonEditingNumberFormatter.string(from: NSDecimalNumber(value: dollarsDouble)) {
                // To ensure 0.00 isnt a valid input
                return formattedDollars == "$0.00" ? "" : formattedDollars
            }

            // If editing you need to split the number into dollarss and cents parts
            var splitNumber = workingText.components(separatedBy: decimalSeparator)

            // Dollars section formatting
            if let dollars = splitNumber.first,
               let dollarsDouble = Double(dollars),
               let formattedDollars = editingNumberFormatter.string(from: NSDecimalNumber(value: dollarsDouble)) {
                splitNumber[0] = formattedDollars
            }

            // Cents formatting section
            if splitNumber.count >= 2 {
                let cents = splitNumber[1]
                // This is for if the first input is a decimal point the dollars section will be empty at this point
                if splitNumber[0].isEmpty {
                    splitNumber[0] = "0"
                }

                // Only taking two decimal places
                splitNumber[1] = String(cents.prefix(2))
            }
            
            // This is to prevent more than one decimal point being entered
            if splitNumber.count > 2 { splitNumber.removeSubrange(2...) }

            let fullNumber = splitNumber.joined(separator: decimalSeparator)

            return fullNumber.isNotEmpty ? fullNumber : ""
        }
    }
}

//struct BetslipInputFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetslipInputFieldView()
//    }
//}
