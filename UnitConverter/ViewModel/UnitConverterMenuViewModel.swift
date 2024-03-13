//
//  UnitConverterMenuViewModel.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import Foundation
import SwiftUI

final class UnitConverterMenuViewModel: ObservableObject {
    @Published var menuList: [UnitMenu]
    @Published var leftNumber: Double
    @Published var rightNumber: Double
    @Published var leftIndex: Int
    @Published var rightIndex: Int
    @Published var leftList: [Unit]
    @Published var rightList: [Unit]
    var selectedMenu: UnitType = .length
    var leftScrollProxy: ScrollViewProxy?
    var rightScrollProxy: ScrollViewProxy?
    @Published var isShowSetting = false

    init() {
        menuList = [UnitMenu(name: "Length".local, type: .length, color: .red,
                             unitList: [Unit(name: "Inch".local, n: "in", toMetic: 0.0254, isEmperial: true),
                                        Unit(name: "Feet".local, n: "ft", toMetic: 0.3048, isEmperial: true),
                                        Unit(name: "Yard".local, n: "yard", toMetic: 0.9144, isEmperial: true),
                                        Unit(name: "Mile".local, n: "mile", toMetic: 1609.344, isEmperial: true),
                                        Unit(name: "Nautical Mile".local, n: "nmi", toMetic: 1852, isEmperial: true),
                                        Unit(name: "Centimeter".local, n: "cm", toMetic: 0.01, isEmperial: false),
                                        Unit(name: "Meter".local, n: "m", toMetic: 1.0, isEmperial: false),
                                        Unit(name: "Kilometer".local, n: "km", toMetic: 1000.0, isEmperial: false)]),
                    UnitMenu(name: "Weight".local, type: .weight, color: .yellow,
                             unitList: [Unit(name: "Carat".local, n: "ct", toMetic: 0.0002, isEmperial: true),
                                        Unit(name: "Ounce".local, n: "oz", toMetic: 0.02834952312, isEmperial: true),
                                        Unit(name: "Pound".local, n: "lb", toMetic: 0.45359237, isEmperial: true),
                                        Unit(name: "Gram".local, n: "gm", toMetic: 0.001, isEmperial: false),
                                        Unit(name: "Kilogram".local, n: "kg", toMetic: 1.0, isEmperial: false)]),
                    UnitMenu(name: "Power".local, type: .power, color: .purple,
                             unitList: [Unit(name: "Horse Power".local, n: "hp", toMetic: 735.4990028, isEmperial: true),
                                        Unit(name: "Kilowatt".local, n: "kW", toMetic: 1000.0, isEmperial: false),
                                        Unit(name: "Watt".local, n: "w", toMetic: 1.0, isEmperial: false)]),
                    UnitMenu(name: "Area".local, type: .area, color: .blue,
                             unitList: [Unit(name: "Square Inch".local, n: "in²", toMetic: 0.00064516, isEmperial: true),
                                        Unit(name: "Square Feet".local, n: "ft²", toMetic: 0.09290304, isEmperial: true),
                                        Unit(name: "Acre".local, n: "acre", toMetic: 2000, isEmperial: true),
                                        Unit(name: "Hectare".local, n: "ha", toMetic: 100000, isEmperial: false),
                                        Unit(name: "SquareMeter".local, n: "m²", toMetic: 1.0, isEmperial: false)]),
                    UnitMenu(name: "Volumn".local, type: .volumn, color: .green,
                             unitList: [Unit(name: "US Cup".local, n: "cup", toMetic: 0.2365882365, isEmperial: true),
                                        Unit(name: "US Tablespoon".local, n: "tblspn", toMetic: 0.01478676478, isEmperial: true),
                                        Unit(name: "UK Tablespoon".local, n: "tblspn", toMetic: 0.015, isEmperial: true),
                                        Unit(name: "AU Tablespoon".local, n: "tblspn", toMetic: 0.02, isEmperial: true),
                                        Unit(name: "US Teaspoon".local, n: "tspn", toMetic: 0.004928921594, isEmperial: true),
                                        Unit(name: "UK Teaspoon".local, n: "tspn", toMetic: 0.005, isEmperial: true),
                                        Unit(name: "US Bushel".local, n: "bushel", toMetic: 35.23907017, isEmperial: true),
                                        Unit(name: "US Barrel".local, n: "barrel", toMetic: 158.9872949, isEmperial: true),
                                        Unit(name: "UK Barrel".local, n: "barrel", toMetic: 163.65924, isEmperial: true),
                                        Unit(name: "US Liquid Gallon".local, n: "gal", toMetic: 3.785411784, isEmperial: true),
                                        Unit(name: "US Dry Gallon".local, n: "gal", toMetic: 4.404883771, isEmperial: true),
                                        Unit(name: "UK Gallon".local, n: "gal", toMetic: 4.54609, isEmperial: true),
                                        Unit(name: "US Fluid Ounce".local, n: "fl oz", toMetic: 0.02957352956, isEmperial: true),
                                        Unit(name: "UK Fluid Ounce".local, n: "fl oz", toMetic: 0.0284130625, isEmperial: true),
                                        Unit(name: "US Pint".local, n: "pint", toMetic: 0.473176473, isEmperial: true),
                                        Unit(name: "UK Pint".local, n: "pint", toMetic: 0.56826125, isEmperial: true),
                                        Unit(name: "US Quart".local, n: "quart", toMetic: 0.946352946, isEmperial: true),
                                        Unit(name: "UK Quart".local, n: "quart", toMetic: 1.1365225, isEmperial: true),
                                        Unit(name: "Cubic Yard".local, n: "yd³", toMetic: 764.554858, isEmperial: true),
                                        Unit(name: "Cubic Foot".local, n: "ft³", toMetic: 28.31684659, isEmperial: true),
                                        Unit(name: "Cubic Inch".local, n: "in³", toMetic: 0.016387064, isEmperial: true),
                                        Unit(name: "Milliliter(cc)".local, n: "cm³", toMetic: 0.001, isEmperial: false),
                                        Unit(name: "Liter".local, n: "dm³", toMetic: 1.0, isEmperial: false),
                                        Unit(name: "Cubic meter".local, n: "m³", toMetic: 1000, isEmperial: false)]),
                    UnitMenu(name: "US Volumn".local, type: .usvolumn, color: .green,
                             unitList: [Unit(name: "Teaspoon".local, n: "tspn", toMetic: 0.004928921594, isEmperial: true),
                                        Unit(name: "Tablespoon".local, n: "tblspn", toMetic: 0.01478676478, isEmperial: true),
                                        Unit(name: "Cubic Inch".local, n: "in³", toMetic: 0.016387064, isEmperial: true),
                                        Unit(name: "Fluid Ounce".local, n: "fl oz", toMetic: 0.02957352956, isEmperial: true),
                                        Unit(name: "Cup".local, n: "cup", toMetic: 0.2365882365, isEmperial: true),
                                        Unit(name: "Pint".local, n: "pint", toMetic: 0.473176473, isEmperial: true),
                                        Unit(name: "Quart".local, n: "quart", toMetic: 0.946352946, isEmperial: true),
                                        Unit(name: "Liquid Gallon".local, n: "gal", toMetic: 3.785411784, isEmperial: true),
                                        Unit(name: "Dry Gallon".local, n: "gal", toMetic: 4.404883771, isEmperial: true),
                                        Unit(name: "Cubic Foot".local, n: "ft³", toMetic: 28.31684659, isEmperial: true),
                                        Unit(name: "Bushel".local, n: "bushel", toMetic: 35.23907017, isEmperial: true),
                                        Unit(name: "Barrel".local, n: "barrel", toMetic: 158.9872949, isEmperial: true),
                                        Unit(name: "Cubic Yard".local, n: "yd³", toMetic: 764.554858, isEmperial: true)])]

        
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
        Toast.shared.showPopup(Text("Debug: Convert ".local)
                               + Text(getDoubleToString(leftNumber)).foregroundColor(.red)
                               + Text("\(leftList[leftIndex].name)" + " TO ".local)
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
        
        var valueString = formatter.string(from: NSNumber(value: round(inputDouble * 100000))) ?? ""
        valueString = valueString.contains(".") ? String(valueString.dropLast(2)) : valueString
        while valueString.count < 6 {
            valueString = "0" + valueString
        }
        let endIndex = valueString.index(valueString.endIndex, offsetBy: -5)
        let decimalString = valueString[..<endIndex] + "." + valueString[endIndex...]
        return decimalString.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            .replacingOccurrences(of: "\\.$", with: "", options: .regularExpression)
            .replacingOccurrences(of: "^\\.", with: "0.", options: .regularExpression)
    }
    
    func scrollToFirstUnit(proxy: ScrollViewProxy, unitMenu: UnitMenu, isLeft: Bool) {
        let keyWord = "firstIndex" + unitMenu.type.name + (isLeft ? "Left" : "Right")
        if let myIndex = UserDefaults.standard.object(forKey: keyWord) as? Int {
            if isLeft {
                leftScrollProxy = proxy
                leftIndex = myIndex
                withAnimation {
                    proxy.scrollTo(leftList[myIndex].id, anchor: .center)
                }
            } else {
                rightScrollProxy = proxy
                rightIndex = myIndex
                withAnimation {
                    proxy.scrollTo(rightList[myIndex].id, anchor: .center)
                }
            }
        } else {
            if isLeft {
                leftScrollProxy = proxy
                let firstLeftUnitID = leftList.first?.id
                leftIndex = leftList.firstIndex(where: { $0.isEmperial }) ?? 0
                UserDefaults.standard.set(leftIndex, forKey: keyWord)
                withAnimation {
                    proxy.scrollTo(firstLeftUnitID, anchor: .center)
                }
            } else {
                rightScrollProxy = proxy
                let firstRightUnitID = rightList.filter({ !$0.isEmperial }).first?.id
                rightIndex = rightList.firstIndex(where: { !$0.isEmperial }) ?? 0
                UserDefaults.standard.set(rightIndex, forKey: keyWord)
                withAnimation {
                    proxy.scrollTo(firstRightUnitID, anchor: .center)
                }
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
