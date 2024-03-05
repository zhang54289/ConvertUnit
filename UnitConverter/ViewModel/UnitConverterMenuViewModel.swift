//
//  UnitConverterMenuViewModel.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import Foundation
import SwiftUI

final class Menu {
    static let menuList: [UnitType: UnitMenu]
    = [.length: UnitMenu(name: "length".local, type: .length, color: .red,
                         unitList: [Unit(name: "Inch".local, n: "in", toMetic: 0.0254, isEmperial: true),
                                    Unit(name: "Feet".local, n: "ft", toMetic: 0.3048, isEmperial: true),
                                    Unit(name: "Yard".local, n: "yard", toMetic: 0.9144, isEmperial: true),
                                    Unit(name: "Mile".local, n: "mile", toMetic: 1609.344, isEmperial: true),
                                    Unit(name: "Nautical Mile".local, n: "nmi", toMetic: 1852, isEmperial: true),
                                    Unit(name: "Meter".local, n: "m", toMetic: 1.0, isEmperial: false),
                                    Unit(name: "Centimeter".local, n: "cm", toMetic: 0.01, isEmperial: false),
                                    Unit(name: "Kilometer".local, n: "km", toMetic: 1000.0, isEmperial: false)
                                   ]),
       .weight: UnitMenu(name: "weight".local, type: .weight, color: .yellow,
                         unitList: [Unit(name: "Carat".local, n: "ct", toMetic: 0.0002, isEmperial: true),
                                    Unit(name: "Ounce".local, n: "oz", toMetic: 0.02834952312, isEmperial: true),
                                    Unit(name: "pound".local, n: "lb", toMetic: 0.45359237, isEmperial: true),
                                    Unit(name: "kilogram".local, n: "kg", toMetic: 1.0, isEmperial: false),
                                    Unit(name: "gram".local, n: "gm", toMetic: 0.001, isEmperial: false)
                                   ]),
       .power: UnitMenu(name: "power".local, type: .power, color: .purple,
                         unitList: [Unit(name: "Horse Power".local, n: "hp", toMetic: 735.4990028, isEmperial: true),
                                    Unit(name: "Watt".local, n: "w", toMetic: 1.0, isEmperial: false),
                                    Unit(name: "Kilowatt".local, n: "kW", toMetic: 1000.0, isEmperial: false)
                                   ]),
       .area: UnitMenu(name: "area".local, type: .area, color: .blue,
                       unitList: [Unit(name: "square Inch".local, n: "in²", toMetic: 0.00064516, isEmperial: true),
                                  Unit(name: "square Feet".local, n: "ft²", toMetic: 0.09290304, isEmperial: true),
                                  Unit(name: "acre".local, n: "acre", toMetic: 2000, isEmperial: true),
                                  Unit(name: "squareMeter".local, n: "m²", toMetic: 1.0, isEmperial: false),
                                  Unit(name: "Hectare".local, n: "ha", toMetic: 100000, isEmperial: false)
                                 ])]
}

//class PositionSettings: ObservableObject {
//    static let shared = PositionSettings()
//    
//    @Published var lengthLeft: Int {
//        didSet {
//            UserDefaults.standard.set(lengthLeft, forKey: "LengthLeft")
//        }
//    }
//    
//    @Published var lengthRight: Int {
//        didSet {
//            UserDefaults.standard.set(lengthRight, forKey: "LengthRight")
//        }
//    }
//    
//    @Published var weightLeft: Int {
//        didSet {
//            UserDefaults.standard.set(weightLeft, forKey: "WeightLeft")
//        }
//    }
//    
//    @Published var weightRight: Int {
//        didSet {
//            UserDefaults.standard.set(weightRight, forKey: "WeightRight")
//        }
//    }
//    
//    @Published var powerLeft: Int {
//        didSet {
//            UserDefaults.standard.set(powerLeft, forKey: "PowerLeft")
//        }
//    }
//    
//    @Published var powerRight: Int {
//        didSet {
//            UserDefaults.standard.set(powerRight, forKey: "PowerRight")
//        }
//    }
//    
//    @Published var areaLeft: Int {
//        didSet {
//            UserDefaults.standard.set(areaLeft, forKey: "AreaLeft")
//        }
//    }
//    
//    @Published var areaRight: Int {
//        didSet {
//            UserDefaults.standard.set(areaRight, forKey: "AreaRight")
//        }
//    }
//    
//    init() {
//        self.lengthLeft = 0
//        self.lengthRight = 0
//        self.weightLeft = 0
//        self.weightRight = 0
//        self.powerLeft = 0
//        self.powerRight = 0
//        self.areaLeft = 0
//        self.areaRight = 0
//
//        self.lengthLeft = initializedIndex(forKey: "LengthLeft", unitType: .length, isEmperial: true)
//        self.lengthRight = initializedIndex(forKey: "LengthRight", unitType: .length, isEmperial: false)
//        
//        self.weightLeft = initializedIndex(forKey: "WeightLeft", unitType: .weight, isEmperial: true)
//        self.weightRight = initializedIndex(forKey: "WeightRight", unitType: .weight, isEmperial: false)
//        
//        self.powerLeft = initializedIndex(forKey: "PowerLeft", unitType: .power, isEmperial: true)
//        self.powerRight = initializedIndex(forKey: "PowerRight", unitType: .power, isEmperial: false)
//        
//        self.areaLeft = initializedIndex(forKey: "AreaLeft", unitType: .area, isEmperial: true)
//        self.areaRight = initializedIndex(forKey: "AreaRight", unitType: .area, isEmperial: false)
//    }
//    
//    private func initializedIndex(forKey key: String, unitType: UnitType, isEmperial: Bool) -> Int {
//        guard let unitMenu = Menu.menuList[unitType],
//              let index = unitMenu.unitList.firstIndex(where: { $0.isEmperial == isEmperial }) else {
//            return 0
//        }
//        return UserDefaults.standard.object(forKey: key) as? Int ?? index
//    }
//}

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
