//
//  UnitConverterMenuViewModel.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import Foundation
import SwiftUI

enum MenuType: Int {
    case length = 0
    case weight
    case area
}

final class Menu {
    static let menuList: [MenuType: UnitMenu]
    = [.length: UnitMenu(name: "length", type: .length, color: .red,
                         unitList: [Unit(name: "Inch", n: "in", toMetic: 0.0254, isEmperial: true),
                                    Unit(name: "Feet", n: "ft", toMetic: 0.3048, isEmperial: true),
                                    Unit(name: "Yard", n: "yard", toMetic: 0.9144, isEmperial: true),
                                    Unit(name: "Rod", n: "rod", toMetic: 5.0292, isEmperial: true),
                                    Unit(name: "Mile", n: "mile", toMetic: 1609.344, isEmperial: true),
                                    Unit(name: "Nautical Mile", n: "nmi", toMetic: 1852, isEmperial: true),
                                    Unit(name: "Centimeter", n: "cm", toMetic: 0.01, isEmperial: false),
                                    Unit(name: "Meter", n: "m", toMetic: 1.0, isEmperial: false),
                                    Unit(name: "Kilometer", n: "km", toMetic: 1000.0, isEmperial: false)]),
       .weight: UnitMenu(name: "weight", type: .weight, color: .yellow,
                         unitList: [Unit(name: "Carat", n: "ct", toMetic: 0.0002, isEmperial: true),
                                    Unit(name: "Ounce", n: "oz", toMetic: 0.02834952312, isEmperial: true),
                                    Unit(name: "pound", n: "lb", toMetic: 0.45359237, isEmperial: true),
                                    Unit(name: "gram", n: "gm", toMetic: 0.001, isEmperial: false),
                                    Unit(name: "kilogram", n: "kg", toMetic: 1.0, isEmperial: false)]),
       .area: UnitMenu(name: "area", type: .area, color: .blue,
                       unitList: [Unit(name: "square Inch", n: "in²", toMetic: 0.00064516, isEmperial: true),
                                  Unit(name: "square Feet", n: "ft²", toMetic: 0.09290304, isEmperial: true),
                                  Unit(name: "acre", n: "acre", toMetic: 2000, isEmperial: true),
                                  Unit(name: "Hectare", n: "ha", toMetic: 100000, isEmperial: false),
                                  Unit(name: "squareMeter", n: "m²", toMetic: 1.0, isEmperial: false)])]
}

final class UnitConverterMenuViewModel: ObservableObject {
    @Published var leftNumber: Double
    @Published var rightNumber: Double
    @Published var leftIndex: Int
    @Published var rightIndex: Int
    @Published var leftList: [Unit]
    @Published var rightList: [Unit]
    var isMenuSelected = false
    var leftScrollProxy: ScrollViewProxy?
    var rightScrollProxy: ScrollViewProxy?
    @Published var isShowSetting = false

    init() {
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
                               + Text("\(rightList[rightIndex].name)"),
                               isDebug: true)
        return getDoubleToString(ret)
    }
    
    private func getDoubleToString(_ inputDouble: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.usesGroupingSeparator = false
        
        var valueString = formatter.string(from: NSNumber(value: round(inputDouble * 1000000))) ?? ""
        valueString = valueString.contains(".") ? String(valueString.dropLast(2)) : valueString
        while valueString.count < 7 {
            valueString = "0" + valueString
        }
        let endIndex = valueString.index(valueString.endIndex, offsetBy: -6)
        let decimalString = valueString[..<endIndex] + "." + valueString[endIndex...]
        return decimalString.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^\\.", with: "0.", options: .regularExpression)
    }
    
    func scrollToFirstUnit(proxy: ScrollViewProxy, isLeft: Bool) {
        if isLeft {
            leftScrollProxy = proxy
            let firstLeftUnitID = leftList.first?.id
            leftIndex = leftList.firstIndex(where: { $0.isEmperial }) ?? 0
            withAnimation {
                proxy.scrollTo(firstLeftUnitID, anchor: .center)
            }
        } else {
            rightScrollProxy = proxy
            let firstRightUnitID = rightList.filter({ !$0.isEmperial }).first?.id
            rightIndex = rightList.firstIndex(where: { !$0.isEmperial }) ?? 0
            withAnimation {
                proxy.scrollTo(firstRightUnitID, anchor: .center)
            }
        }
    }
    
    func scrollSwap() {
        let swapToLeftUnitID = leftList[rightIndex].id
        let swapToRightUnitID = rightList[leftIndex].id
        
        let tempIndex = rightIndex
        rightIndex = leftIndex
        leftIndex = tempIndex
        
        withAnimation {
            leftScrollProxy?.scrollTo(swapToLeftUnitID, anchor: .center)
            rightScrollProxy?.scrollTo(swapToRightUnitID, anchor: .center)
        }
    }
}
