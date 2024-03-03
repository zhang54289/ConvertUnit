//
//  UnitConverterMenuView.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct UnitConverterMenuView: View {
    @StateObject var viewModel = UnitConverterMenuViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer().frame(height: 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                let unitMenus = Array(Menu.menuList).sorted(by: { $0.key.rawValue < $1.key.rawValue })
                ForEach(unitMenus, id: \.key) { key, unitMenu in
                    NavigationLink(destination:
                                    UnitConverterView(viewModel: viewModel,
                                                      unitList: unitMenu.unitList,
                                                      leftNumber: $viewModel.leftNumber,
                                                      rightNumber: $viewModel.rightNumber)
                                        .navigationBarTitle(unitMenu.name.uppercased(), displayMode: .inline)
                    ) {
                        unitMenuView(unitMenu)
                    }
                }
            }
        }
        Spacer()
        NavigationLink(destination: AuthorView().navigationBarTitle("AUTHOR".local, displayMode: .inline)) {
            unitMenuView(UnitMenu(name: "Author".local, color: .green))
        }
    }
    
    @ViewBuilder
    private func unitMenuView(_ unitMenu: UnitMenu) -> some View {
        VStack(spacing: 10) {
            RoundedRectangle(cornerRadius: 6)
                .inset(by: 1.5)
                .fill(unitMenu.color)
                .frame(width: 70, height: 70)
            Text(unitMenu.name.capitalized)
                .bold()
        }
    }
}
