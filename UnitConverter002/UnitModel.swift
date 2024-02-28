//
//  UnitModel.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import Foundation
import SwiftUI

enum UnitType: Equatable, Hashable {
    case length
    case weight
    case area
}

struct Unit: Identifiable, Equatable, Hashable {
    var id = UUID()
    var name: String
    var n: String
    var toMetic: Double
    var isEmperial: Bool
    var isFocused: Bool
    
    init(name: String, n: String, toMetic: Double, isEmperial: Bool) {
        self.name = name
        self.n = n
        self.toMetic = toMetic
        self.isEmperial = isEmperial
        self.isFocused = false
    }
}

struct UnitMenu: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var type: UnitType
    var color: Color
    var unitList: [Unit]
    
    init(name: String, type: UnitType, color: Color, unitList: [Unit]) {
        self.name = name
        self.type = type
        self.color = color
        self.unitList = unitList
    }
}

extension UnitMenu {
    static func == (lhs: UnitMenu, rhs: UnitMenu) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.color == rhs.color
    }
}

extension UnitMenu {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(color)
        hasher.combine(unitList)
    }
}

final class UnitMenuListViewModel: ObservableObject {
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
                                                 Unit(name: "Centimeter", n: "cm", toMetic: 100, isEmperial: false),
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
}

