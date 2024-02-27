//
//  ContentView.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI
import Combine

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

struct DetailView: View {
    @ObservedObject var viewModel: UnitMenuListViewModel
    let unitList: [Unit]
    @Binding var leftNumber: Double
    @Binding var rightNumber: Double
    
    var body: some View {
        HStack {
            let leftList = unitList.filter{ $0.isEmperial }
            UnitListView(viewModel: viewModel, isLeft: true, list: leftList, inputNumber: $leftNumber)
            let rigfhtList = unitList.filter{ !$0.isEmperial }
            UnitListView(viewModel: viewModel, isLeft: false, list: rigfhtList, inputNumber: $rightNumber)
        }
        .frame(maxHeight: .infinity)
        CalculatorView(inputNumber: $leftNumber)
    }
}

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
                                UnitView(viewModel: viewModel, unitViewModel: UnitViewModelModel(proxy, list[index].id, isLeft, index),
                                         unit: list[index], inputNumber: $inputNumber )
                                    .frame(height: 60)
                                    .id(list[index].id)
                                    .onTapGesture {
                                        withAnimation {
//                                            print("proxy.scrollTo(list[index].id, anchor: .center)")
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
//            .simultaneousGesture(
//                DragGesture()
//                    .onEnded { value in
//                        print(".onEnded gesture", value)
//                    }
//            )

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

final class UnitViewModelModel: ObservableObject {
    @Published var geoMidY: CGFloat = 0
    var proxy: ScrollViewProxy
    var scrollToID: UUID
    let isLeft: Bool
    let index: Int

    private var cancellables = Set<AnyCancellable>()

    init(_ proxy: ScrollViewProxy, _ scrollToID: UUID, _ isLeft: Bool, _ index: Int) {
        self.proxy = proxy
        self.scrollToID = scrollToID
        self.isLeft = isLeft
        self.index = index
        
        $geoMidY
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
//                print("geoMidY has stabilized for 1 second, current value: \(self?.geoMidY ?? 0)")
                if abs((self?.geoMidY ?? 0) - 240) < 35.5 {
                    proxy.scrollTo(self?.scrollToID, anchor: .center)
                    if let isLeft = self?.isLeft {
                        if isLeft {
                            print("Focus on left index:", index)
                        } else {
                            print("Focus on right index:", index)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

struct UnitView: View {
    @ObservedObject var viewModel: UnitMenuListViewModel
    @ObservedObject var unitViewModel: UnitViewModelModel

    let unit: Unit
    @Binding var inputNumber: Double
    
    var body: some View {
        GeometryReader { geometry in
            let geoMidY = geometry.frame(in: .global).midY
            ZStack {
                Color.gray
                    .onChange(of: geoMidY) { newValue in
                        unitViewModel.geoMidY = newValue
                    }
                    .overlay(
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
                            .padding(5)
                    )
            }
            .padding(5)
        }
    }
}

//            .simultaneousGesture(
//                DragGesture()
//                    .onEnded { value in
//                        print(".onEnded gesture", value)
//                    }
//            )
            
            //                .simultaneousGesture(DragGesture()
            //                    .onEnded { _ in
            //                        print("DragGesture onEnded")
            //                        if abs(geoMidY - 240) < 35 {
            //                            withAnimation {
            //                                print("proxy.scrollTo(unit.id, anchor: .center)")
            //                                proxy.scrollTo(unit.id, anchor: .center)
            //                            }
            //                        }
            //                    }
            //                )

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
