//
//  UnitView.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct UnitView: View {
    @ObservedObject var unitViewModel: UnitViewModel
    @EnvironmentObject var colorSettings: ColorSettings

    @Binding var leftIndex: Int
    @Binding var rightIndex: Int
    @Binding var inputNumber: Double
    
    let unit: Unit
    let action: (() -> String)?
    
    @State var isFocused = false
    
    var body: some View {
        GeometryReader { geometry in
            let geoMidY = geometry.frame(in: .global).midY
            ZStack {
                let isFocused = ((unitViewModel.isLeft && (leftIndex == unitViewModel.index))
                                || (!unitViewModel.isLeft && (rightIndex == unitViewModel.index)))
                if isFocused {
                    colorSettings.focusColor
                        .cornerRadius(3)
                }
                (isFocused ? colorSettings.focusBackgroundColor : colorSettings.unitPadColor)
                    .onChange(of: geoMidY) { newValue in
                        unitViewModel.geoMidY = newValue
                    }
                    .cornerRadius(3)
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                if unitViewModel.isLeft && (leftIndex == unitViewModel.index) {
                                    Text(String(inputNumber).trimDotZero())
                                } else if !unitViewModel.isLeft && (rightIndex == unitViewModel.index) {
                                    Text(action?() ?? " ")
                                } else {
                                    Text(" ")
                                }
                            }
                            HStack(spacing: 10) {
                                Text(unit.name)
                                Spacer()
                                Text(unit.n)
                            }
                        }
                            .padding(5)
                    )
                    .padding(5)
            }
            .if((unitViewModel.isLeft && (leftIndex == unitViewModel.index))
                || (!unitViewModel.isLeft && (rightIndex == unitViewModel.index))){ view in
                view.bold()
            }
        }
    }
}

extension String {
    func trimDotZero() -> String {
        return self
            .replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression)
    }
}