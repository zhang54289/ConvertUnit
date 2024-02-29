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
    
    init(viewModel: UnitConverterMenuViewModel, unitList: [Unit], leftNumber: Binding<Double>, rightNumber: Binding<Double>) {
        self.viewModel = viewModel
        self.unitList = unitList
        self._leftNumber = leftNumber
        self._rightNumber = rightNumber
    }
    
    var body: some View {
        HStack {
            UnitListView(viewModel: viewModel, isLeft: true, list: unitList.filter{ $0.isEmperial }, inputNumber: $leftNumber)
            UnitListView(viewModel: viewModel, isLeft: false, list: unitList.filter{ !$0.isEmperial }, inputNumber: $rightNumber)
        }
        .frame(maxHeight: .infinity)
        .onAppear {
             viewModel.leftList = unitList.filter{ $0.isEmperial }
             viewModel.rightList = unitList.filter{ !$0.isEmperial }
        }
        CalculatorView(inputNumber: $leftNumber)
    }
}
