//
//  UnitMenuView.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import SwiftUI

struct UnitMenuView: View {
    let unitMenu: UnitMenu
    
    var body: some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .inset(by: 1.5)
                .fill(unitMenu.color)
                .frame(width: 70, height: 70)
            Text(unitMenu.name.capitalized)
        }
    }
}
