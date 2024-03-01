//
//  UnitView.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import SwiftUI

struct UnitView: View {
    @ObservedObject var unitViewModel: UnitViewModel
    @Binding var leftIndex: Int
    @Binding var rightIndex: Int
    @Binding var inputNumber: Double
    
    let unit: Unit
    let action: (() -> String)?
    
    var body: some View {
        GeometryReader { geometry in
            let geoMidY = geometry.frame(in: .global).midY
            ZStack {
                Color.gray
                    .onChange(of: geoMidY) { newValue in
                        unitViewModel.geoMidY = newValue
                    }
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                if unitViewModel.isLeft && leftIndex == unitViewModel.index {
                                    Text(String(inputNumber).trimDotZero())
                                } else if !unitViewModel.isLeft && rightIndex == unitViewModel.index {
                                    Text(action?() ?? " ")
                                } else {
                                    Text(" ")
                                }
                            }
                            HStack(spacing: 10) {
                                Text(unit.name.capitalized)
                                Spacer()
                                Text(unit.n)
                            }
                        }
                            .padding(5)
                    )
            }
            .padding(5)
        }
    }
}

extension String {
    func trimDotZero() -> String {
        return self
            .replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression)
    }
}
