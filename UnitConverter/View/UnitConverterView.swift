//
//  UnitConverterView.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import SwiftUI

struct UnitConverterView: View {
    @ObservedObject var viewModel: UnitConverterMenuViewModel
    let unitList: [Unit]
    @Binding var leftNumber: Double
    @Binding var rightNumber: Double
    
    var body: some View {
        HStack {
            UnitListView(viewModel: viewModel,
                         inputNumber: $leftNumber,
                         isLeft: true,
                         list: unitList)
            UnitListView(viewModel: viewModel,
                         inputNumber: $rightNumber,
                         isLeft: false,
                         list: unitList)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            viewModel.leftList = unitList
            viewModel.rightList = unitList
        }
        .onDisappear {
            leftNumber = 0
        }
        CalculatorView(inputNumber: $leftNumber)
    }
}
