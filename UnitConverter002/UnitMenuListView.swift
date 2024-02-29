//
//  UnitMenuListView.swift
//  UnitConverter002
//
//  Created by zhanghuan on 2/28/24.
//

import SwiftUI

struct UnitMenuListView: View {
    @StateObject var viewModel = UnitMenuListViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer().frame(height: 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.unitMenuList, id: \.self) { unitMenu in
                    NavigationLink(destination:
                                    DetailView(viewModel: viewModel,
                                               unitList: unitMenu.unitList,
                                               leftNumber: $viewModel.leftNumber,
                                               rightNumber: $viewModel.rightNumber)
                                        .navigationBarTitle(unitMenu.name.uppercased(), displayMode: .inline)
                    ) {
                        UnitMenuView(unitMenu: unitMenu)
                    }
                }
            }
            .navigationTitle("Select Unit")
        }
    }
}
