//
//  CalculatorView.swift
//  UnitConverter
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
    case decimal = "."
    case clear = "AC"
    case back = "DEL"
    case swap = "🔄"
    case setting = "⚙️"
    case none = ""
    
    var buttonColor: Color {
        switch self {
        case .clear:
            return .orange
        case .back:
            return Color(.lightGray)
        case .swap:
            return .brown
        case .setting:
            return .brown
        default:
            return Color(UIColor(red: 55/255.0, green: 55/255.0, blue: 55/255.0, alpha: 1))
        }
    }
}

struct CalculatorView: View {
    @ObservedObject var viewModel: UnitConverterMenuViewModel
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
    
    @State var runningNumber = 0
    
    var showValue: String {
        return isDecimal ? "\(value).\(value2)" : "\(value)"
    }
    
    let buttons: [[CalcButton]] = [
        [.seven, .eight, .nine, .clear],
        [.four, .five, .six, .back],
        [.one, .two, .three, .swap],
        [.zero, .decimal, .setting],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                    Text(showValue)
                        .bold()
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .padding(.trailing, 50)
                }
                .padding()
                
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                buttonContent(item: item)
                            })
                        }
                    }
                    .padding(.bottom, 3)
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isShowSetting) {
            SettingView()
        }
    }
    
    @ViewBuilder
    private func buttonContent(item: CalcButton) -> some View {
            if item == .swap {
                let imagePadding: CGFloat = 16
                Image(systemName: "arrow.triangle.2.circlepath")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: buttonWidth(item: item) - imagePadding * 2,
                           height: buttonHeight() - imagePadding * 2)
                    .padding(imagePadding)
                    .background(item.buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(buttonWidth(item: item) / 2)
            } else {
                Text(item.rawValue)
                    .font(.system(size: [.clear, .back].contains(item) ? 26 : 32))
                    .frame(width: buttonWidth(item: item), height: buttonHeight())
                    .background(item.buttonColor)
                    .foregroundColor(.white)
                    .cornerRadius(buttonWidth(item: item) / 2)
            }
    }
    
//    if item == .swap {
//        Text(item.rawValue)
//            .font(.system(size: 32))
//            .frame(
//                width: self.buttonWidth(item: item),
//                height: self.buttonHeight()
//            )
//            .background(item.buttonColor)
//            .foregroundColor(.white)
//            .cornerRadius(self.buttonWidth(item: item)/2)
//
////                                        Image(systemName: "arrow.triangle.2.circlepath")
////                                            .frame(
////                                                width: self.buttonWidth(item: item),
////                                                height: self.buttonHeight()
////                                            )
////                                            .background(item.buttonColor)
////                                            .foregroundColor(.white)
////                                            .cornerRadius(self.buttonWidth(item: item)/2)
//    } else {
//        Text(item.rawValue)
//            .font(.system(size: 32))
//            .frame(
//                width: self.buttonWidth(item: item),
//                height: self.buttonHeight()
//            )
//            .background(item.buttonColor)
//            .foregroundColor(.white)
//            .cornerRadius(self.buttonWidth(item: item)/2)
//    }
//}

                                   
    private func didTap(button: CalcButton) {
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
        case .swap:
            viewModel.scrollSwap()
        case .setting:
            viewModel.isShowSetting = true
        case .none:
            break
        default:
            if (value.count + value2.count) >= Const.maxDigital {
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
    
    let size: CGFloat = 30
    private func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4*size)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5*size)) / 4
    }
    
    private func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5*size)) / 4
    }
}

