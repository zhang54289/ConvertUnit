//
//  ConverterGuruView.swift
//  ConverterGuru
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct ConverterGuruView: View {
    @ObservedObject var viewModel: ConverterGuruMenuViewModel
    let unitMenu: UnitMenu
    @Binding var leftNumber: Double
    @Binding var rightNumber: Double
    
    var body: some View {
        HStack {
            UnitListView(viewModel: viewModel,
                         inputNumber: $leftNumber,
                         isLeft: true,
                         unitMenu: unitMenu)
            UnitListView(viewModel: viewModel,
                         inputNumber: $rightNumber,
                         isLeft: false,
                         unitMenu: unitMenu)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            viewModel.selectedMenu = unitMenu.type
            viewModel.leftList = unitMenu.unitList
            viewModel.rightList = unitMenu.unitList
        }
        .onDisappear {
            leftNumber = 0
        }
        CalculatorView(viewModel: viewModel,
                       inputNumber: $leftNumber)
    }
}
