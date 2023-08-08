//
//  BetslipInputFieldView.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-04.
//

import SwiftUI

enum BetslipInputField: String {
    case bet
    case win
}

struct BetslipInputFieldView: View {
    @ObservedObject var viewModel: ViewModel
    @FocusState var focusedField: BetslipInputField?

    var body: some View {
        HStack(spacing: 8) {
            // MARK: TO BET
            VStack(alignment: .leading, spacing: 0) {
                Text(viewModel.title)
                    .font(Font.custom("SF_Pro_Text", size: 12))
                    .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                    .frame(maxWidth: .infinity, alignment: .leading)

                HStack(spacing: 0) {
                    Text("$")
                        .lineLimit(1)

                    ZStack(alignment: .leading) {
                        // Value placeholder - 0.00
                        if viewModel.text == "" {
                            Text("0.00")
                                .lineLimit(1)
                                .font(
                                    Font.custom("SF_Pro_Text", size: 16)
                                        .weight(.medium)
                                )
                                .foregroundColor(.black)

                        }

                        TextField("", text: $viewModel.text)
                            .focused($focusedField, equals: .bet)
                            .font(
                                Font.custom("SF_Pro_Text", size: 16)
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
        let title: String
        let field: BetslipInputField
        var updateOtherField: () -> Void

        let decimalSeparator = "."
        let groupingSeparator = ","

        var editing: Bool {
            field == focus
        }

        @Published var focus: BetslipInputField? = nil {
            didSet {
                text = formattedString
            }
        }
        @Published var text: String = "" {
            didSet {
                guard oldValue != text else { return }

                text = formattedString
                updateOtherField()
            }
        }

        init(title: String, field: BetslipInputField, text: String, updateOtherField: @escaping () -> Void) {
            self.title = title
            self.field = field
            self.text = text
            self.updateOtherField = updateOtherField
        }

        var formattedString: String {
            // Stripping the text of everything non number related (dollar signs, commas, and the possibility the user ever pastes in the field)
            let workingText = text.components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted).joined()

            // If user is not editing just format using the number formatter and add commas
            if !editing,
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

        func updateValue(_ value: Double, multiplier: Double) {
            text = String(value * multiplier)
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
    }
}

//struct BetslipInputFieldView_Previews: PreviewProvider {
//    static var previews: some View {
//        BetslipInputFieldView()
//    }
//}
