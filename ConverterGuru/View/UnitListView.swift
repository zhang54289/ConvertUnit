//
//  UnitListView.swift
//  ConverterGuru
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct UnitListView: View {
    @ObservedObject var viewModel: ConverterGuruMenuViewModel
    
    @EnvironmentObject var colorSettings: ColorSettings
    @Binding var inputNumber: Double
    
    let isLeft: Bool
    let unitMenu: UnitMenu
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height: geometry.size.height / 2 - 30)
                        VStack(spacing: 0) {
                            Divider()
                                .frame(height: 10)
                            ForEach(unitMenu.unitList.indices, id: \.self) { index in
                                VStack(spacing: 0) {
                                    UnitView(unitViewModel: UnitViewModel(proxy,
                                                                          unitMenu.unitList[index].id,
                                                                          isLeft, index,
                                                                          listHeight: geometry.size.height,
                                                                          leftFunc: { withAnimation { viewModel.leftIndex =  index }} ,
                                                                          rightFunc: { withAnimation { viewModel.rightIndex =  index}}),
                                             leftIndex: $viewModel.leftIndex,
                                             rightIndex: $viewModel.rightIndex,
                                             inputNumber: $inputNumber,
                                             unit: unitMenu.unitList[index]) {
                                        String(viewModel.getConvertString())
                                    }
                                             .frame(height: 60)
                                             .id(unitMenu.unitList[index].id)
                                             .onTapGesture {
                                                 withAnimation {
                                                     proxy.scrollTo(unitMenu.unitList[index].id, anchor: .center)
                                                 }
                                             }
                                             .onChange(of: viewModel.leftIndex) { index in
                                                 guard (ConverterGuruMenuViewModel.selectedMenu == unitMenu.type) else { return }
                                                 let keyWord = "firstIndex" + unitMenu.type.name + "Left"
                                                 UserDefaults.standard.set(index, forKey: keyWord)
                                             }
                                             .onChange(of: viewModel.rightIndex) { index in
                                                 guard (ConverterGuruMenuViewModel.selectedMenu == unitMenu.type) else { return }
                                                 let keyWord = "firstIndex" + unitMenu.type.name + "Right"
                                                 UserDefaults.standard.set(index, forKey: keyWord)
                                             }
                                    Divider()
                                        .frame(height: 10)
                                }
                            }
                        }
                        Spacer().frame(height: geometry.size.height / 2 - 30)
                    }
                    .background(colorSettings.listBackgroundColor)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            viewModel.scrollToFirstUnit(proxy: proxy, unitMenu: unitMenu, isLeft: isLeft)
                        }
                    }
                }
            }
        }
    }
}
