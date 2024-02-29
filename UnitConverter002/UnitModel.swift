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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(color)
        hasher.combine(unitList)
    }
}
