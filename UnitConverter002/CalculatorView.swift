//
//  CalculatorView.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import Foundation
import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case clear = "AC"
    case decimal = "."
    case back = "DEL"
    case none = ""

    var buttonColor: Color {
        switch self {
        case .back:
            return .orange
        case .clear :
            return Color(.lightGray)
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

struct CalculatorView: View {
    @Binding var inputNumber: Double

    @State var value = "0" {
        didSet {
            inputNumber = Double(showValue) ?? 0
        }
    }
    @State var value2 = "" {
        didSet {
            inputNumber = Double(showValue) ?? 0
        }
    }
    @State var isDecimal = false {
        didSet {
            inputNumber = Double(showValue) ?? 0
        }
    }
    var showValue: String {
        return isDecimal ? "\(value).\(value2)" : "\(value)"
    }
    @State var runningNumber = 0

    let buttons: [[CalcButton]] = [
        [.seven, .eight, .nine, .back],
        [.four, .five, .six, .clear],
        [.one, .two, .three, .none],
        [.zero, .decimal, .none],
    ]

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)

            VStack {
                Spacer()

                // Text display
                HStack {
                    Spacer()
                    Text(showValue)
                        .bold()
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                .padding()

                // Our buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .font(.system(size: 32))
                                    .frame(
                                        width: self.buttonWidth(item: item),
                                        height: self.buttonHeight()
                                    )
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }

    func didTap(button: CalcButton) {
        switch button {
        case .clear:
            value = "0"
            isDecimal = false
            value2 = ""
        case .back:
            if value2.count > 0 {
                value2 = String(value2.dropLast())
            } else if isDecimal {
                isDecimal = false
            } else {
                value = String(value.dropLast())
                value = value.isEmpty ? "0" : self.value
            }
        case .decimal:
            if isDecimal {
                value = String(Int(value + value2) ?? 0)
                value2 = ""
            }
            isDecimal.toggle()
        case .none:
            break
        default:
            if (value.count + value2.count) > Const.maxDigital {
                Toast.shared.showPopup(Text("Only support max ") + Text("\(Const.maxDigital)").foregroundColor(.red) + Text(" digital."))
                return
            }
            let number = button.rawValue
            if !isDecimal {
                if value == "0" {
                    value = number
                } else {
                    value = "\(value)\(number)"
                }
            } else {
                if value2.isEmpty {
                    value2 = number
                } else {
                    value2 = "\(value2)\(number)"
                }
            }
        }
    }

    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }

    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*12)) / 4
    }
}

struct Const {
    static let maxDigital: Int = 12
    static let spaceHeight: CGFloat = 100.0
}
