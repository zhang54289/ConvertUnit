//
//  UnitListView.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import SwiftUI

struct UnitListView: View {
    @ObservedObject var viewModel: UnitMenuListViewModel

    let isLeft: Bool
    let list: [Unit]
    @Binding var inputNumber: Double
    @State private var scrollProxy: ScrollViewProxy?
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer().frame(height: Const.spaceHeight)
                    VStack(spacing: 0) {
                        Divider()
                            .frame(height: 10)
                        ForEach(list.indices, id: \.self) { index in
                            VStack(spacing: 0) {
                                UnitView(unitViewModel: UnitViewModel(proxy,
                                                                           list[index].id,
                                                                           isLeft, index,
                                                                           leftFunc: { viewModel.leftIndex =  index } ,
                                                                           rightFunc: { viewModel.rightIndex =  index} ),
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
                    Spacer().frame(height: Const.spaceHeight)
                }
                .border(Color.green)
                .onAppear {
                    self.scrollProxy = proxy
                    scrollToFirstUnit(proxy: proxy)
                }
            }

            Spacer()
        }
    }
    
    private func scrollToFirstUnit(proxy: ScrollViewProxy) {
        if let firstUnitID = list.first?.id {
            withAnimation {
                proxy.scrollTo(firstUnitID, anchor: .center)
            }
        }
    }
}
