//
//  UnitModel.swift
//  ConverterGuru
//
//  Created by Huan Zhang on 2/12/24.
//

import Foundation
import SwiftUI

enum UnitType: Int, Equatable, Hashable {
    case length = 0 // in menu, sorted in this order
    case weight
    case area
    case power
    case volumn
    case usvolumn
    case height
}

extension UnitType {
    var name: String {
        switch self {
        case .length:
            return "length"
        case .weight:
            return "weight"
        case .area:
            return "area"
        case .power:
            return "power"
        case .volumn:
            return "volumn"
        case .usvolumn:
            return "usvolumn"
        case .height:
            return "height"
        }
    }
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
    var leftNumber: Double
    var rightNumber: Double
    var leftIndex: Int
    var rightIndex: Int
    var leftList: [Unit]
    var rightList: [Unit]

    init(name: String, type: UnitType = .length, color: Color, unitList: [Unit] = []) {
        self.name = name
        self.type = type
        self.color = color
        self.unitList = unitList
        self.leftNumber = 0
        self.rightNumber = 0
        self.leftIndex = 0
        self.rightIndex = 0
        self.leftList = []
        self.rightList = []
    }
}

extension UnitMenu {
    static func == (lhs: UnitMenu, rhs: UnitMenu) -> Bool {
        return lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.type == rhs.type &&
        lhs.color == rhs.color
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(color)
        hasher.combine(unitList)
    }
}
