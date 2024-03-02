//
//  UnitListView.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct UnitListView: View {
    @ObservedObject var viewModel: UnitConverterMenuViewModel
    @Binding var inputNumber: Double
    
    let isLeft: Bool
    let list: [Unit]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height: geometry.size.height / 2 - 30)
                        VStack(spacing: 0) {
                            Divider()
                                .frame(height: 10)
                            ForEach(list.indices, id: \.self) { index in
                                VStack(spacing: 0) {
                                    UnitView(unitViewModel: UnitViewModel(proxy,
                                                                          list[index].id,
                                                                          isLeft, index,
                                                                          listHeight: geometry.size.height,
                                                                          leftFunc: { viewModel.leftIndex =  index } ,
                                                                          rightFunc: { viewModel.rightIndex =  index}),
                                             leftIndex: $viewModel.leftIndex,
                                             rightIndex: $viewModel.rightIndex,
                                             inputNumber: $inputNumber,
                                             unit: list[index]) {
                                        String(viewModel.getConvertString())
                                    }
                                             .frame(height: 60)
                                             .id(list[index].id)
                                             .onTapGesture {
                                                 withAnimation {
                                                     proxy.scrollTo(list[index].id, anchor: .center)
                                                 }
                                             }
                                    Divider()
                                        .frame(height: 10)
                                }
                            }
                        }
                        Spacer().frame(height: geometry.size.height / 2 - 30)
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            viewModel.scrollToFirstUnit(proxy: proxy, isLeft: isLeft)
                        }
                    }
                }
            }
        }
    }
}
