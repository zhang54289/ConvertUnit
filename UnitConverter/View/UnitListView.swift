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
    
    @State private var scrollProxy: ScrollViewProxy?
    
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
                        scrollProxy = proxy
                        scrollToFirstUnit(proxy: proxy, isLeft: isLeft)
                    }
                }
            }
        }
    }
    
    private func scrollToFirstUnit(proxy: ScrollViewProxy, isLeft: Bool) {
        if isLeft, let firstUnitID = list.first?.id {
            viewModel.leftIndex = list.firstIndex(where: { $0.isEmperial }) ?? 0
            withAnimation {
                proxy.scrollTo(firstUnitID, anchor: .center)
            }
        }
        if !isLeft, let firstUnitID = list.filter({ !$0.isEmperial }).first?.id {
            viewModel.rightIndex = list.firstIndex(where: { !$0.isEmperial }) ?? 0
            withAnimation {
                proxy.scrollTo(firstUnitID, anchor: .center)
            }
        }
        
    }
}
