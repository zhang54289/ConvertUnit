//
//  UnitConverterMenuViewModel.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import Foundation
import SwiftUI

final class UnitConverterMenuViewModel: ObservableObject {
    let unitMenuList: [UnitMenu]
    @Published var leftNumber: Double
    @Published var rightNumber: Double
    @Published var leftIndex: Int
    @Published var rightIndex: Int
    @Published var leftList: [Unit]
    @Published var rightList: [Unit]
    
    init() {
        self.unitMenuList = [UnitMenu(name: "length", type: .length, color: .red,
                                      unitList: [Unit(name: "Inch", n: "in", toMetic: 0.0245, isEmperial: true),
                                                 Unit(name: "Feet", n: "ft", toMetic: 0.3048, isEmperial: true),
                                                 Unit(name: "Mile", n: "mile", toMetic: 1609.344, isEmperial: true),
                                                 Unit(name: "Mile", n: "mile", toMetic: 1609.344, isEmperial: true),
                                                 Unit(name: "Mile", n: "mile", toMetic: 1609.344, isEmperial: true),
                                                 Unit(name: "Mile", n: "mile", toMetic: 1609.344, isEmperial: true),
                                                 Unit(name: "Centimeter", n: "cm", toMetic: 0.01, isEmperial: false),
                                                 Unit(name: "Meter", n: "m", toMetic: 1.0, isEmperial: false)]),
                             UnitMenu(name: "weight", type: .weight, color: .yellow,
                                      unitList: [Unit(name: "pound", n: "lb", toMetic: 0.450, isEmperial: true),
                                                 Unit(name: "kilogram", n: "kg", toMetic: 1.0, isEmperial: false)]),
                             UnitMenu(name: "area", type: .area, color: .blue,
                                      unitList: [Unit(name: "acre", n: "acre", toMetic: 2000, isEmperial: true),
                                                 Unit(name: "squareMeter", n: "m2", toMetic: 1.0, isEmperial: false)])]
        self.leftNumber = 0
        self.rightNumber = 0
        self.leftIndex = 0
        self.rightIndex = 0
        self.leftList = []
        self.rightList = []
    }
    
    func getConvertString() -> String {
        guard leftList.count > 0, leftNumber != 0 else { return "0" }
        let ret: Double = leftNumber * leftList[leftIndex].toMetic / rightList[rightIndex].toMetic
        Toast.shared.showPopup(Text("Debug: Convert ")
                               + Text(getDoubleToString(leftNumber)).foregroundColor(.red)
                               + Text("\(leftList[leftIndex].name) TO ")
                               + Text(getDoubleToString(ret)).foregroundColor(.green)
                               + Text("\(rightList[rightIndex].name)"))
        return getDoubleToString(ret)
    }
    
    private func getDoubleToString(_ inputDouble: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        var valueString = formatter.string(from: NSNumber(value: round(inputDouble * 10000000000))) ?? ""
        valueString = valueString.contains(".") ? String(valueString.dropLast(2)) : valueString
        while valueString.count < 11 {
            valueString = "0" + valueString
        }
        let endIndex = valueString.index(valueString.endIndex, offsetBy: -10)
        let decimalString = valueString[..<endIndex] + "." + valueString[endIndex...]
        return decimalString.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
    }
    
}
