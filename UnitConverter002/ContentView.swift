//
//  ContentView.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                UnitMenuListView()
            }
            .padding()
        }
    }
}

struct UnitMenuListView: View {
    @StateObject var viewModel = UnitMenuListViewModel()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Spacer().frame(height: 20)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.unitMenuList, id: \.self) { unitMenu in
                    NavigationLink(destination:
                                    DetailView(unitList: unitMenu.unitList,
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
    
    struct DetailView: View {
        let unitList: [Unit]
        @Binding var leftNumber: Double
        @Binding var rightNumber: Double
        
        var body: some View {
            HStack {
                let leftList = unitList.filter{ $0.isEmperial }
                UnitListView(list: leftList, inputNumber: $leftNumber)
                let rigfhtList = unitList.filter{ !$0.isEmperial }
                UnitListView(list: rigfhtList, inputNumber: $rightNumber)
            }
            .frame(maxHeight: .infinity)
            CalculatorView(inputNumber: $leftNumber)
        }
    }
    
    struct UnitView: View {
        let unit: Unit
        @Binding var inputNumber: Double
        
        var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text(String(inputNumber))
                }
                HStack(spacing: 10) {
                    Text(unit.name.capitalized)
                    Spacer()
                    Text(unit.n)
                }
            }
            .padding(10)
        }
    }
    
    struct UnitListView: View {
        let list: [Unit]
        @Binding var inputNumber: Double
        @State private var scrollProxy: ScrollViewProxy?
        
        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        Spacer().frame(height: 200)
                        VStack(spacing: 0) {
                            ForEach(list.indices, id: \.self) { index in
                                Divider()
                                VStack {
                                    UnitView(unit: list[index], inputNumber: $inputNumber)
                                        .id(list[index].id)
                                    Divider()
                                }
                            }
                        }
                        Spacer().frame(height: 200)
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
    
    struct UnitMenuView: View {
        let unitMenu: UnitMenu
        
        var body: some View {
            VStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 6)
                    .inset(by: 1.5)
                    .fill(unitMenu.color)
                    .frame(width: 70, height: 70)
                Text(unitMenu.name.capitalized)
            }
        }
    }
}
