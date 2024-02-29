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
                         list: unitList.filter{ $0.isEmperial })
            UnitListView(viewModel: viewModel,
                         inputNumber: $rightNumber,
                         isLeft: false,
                         list: unitList.filter{ !$0.isEmperial })
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            viewModel.leftList = unitList.filter{ $0.isEmperial }
            viewModel.rightList = unitList.filter{ !$0.isEmperial }
        }
        CalculatorView(inputNumber: $leftNumber)
    }
}
