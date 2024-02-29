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
    
    init(viewModel: UnitMenuListViewModel, unitList: [Unit], leftNumber: Binding<Double>, rightNumber: Binding<Double>) {
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
                                UnitView(unitViewModel: UnitViewModelModel(proxy,
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

final class UnitViewModelModel: ObservableObject {
    @Published var geoMidY: CGFloat = 0
    var proxy: ScrollViewProxy
    var scrollToID: UUID
    let isLeft: Bool
    let index: Int
    let leftFunc: (() -> Void)?
    let rightFunc: (() -> Void)?

    private var cancellables = Set<AnyCancellable>()

    init(_ proxy: ScrollViewProxy, _ scrollToID: UUID, _ isLeft: Bool, _ index: Int,
         leftFunc: (() -> Void)?, rightFunc: (() -> Void)?) {
        self.proxy = proxy
        self.scrollToID = scrollToID
        self.isLeft = isLeft
        self.index = index
        self.leftFunc = leftFunc
        self.rightFunc = rightFunc
        
        $geoMidY
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                if abs((self?.geoMidY ?? 0) - 240) < 35.5 {
                    withAnimation {
                        proxy.scrollTo(self?.scrollToID, anchor: .center)
                    }
                    if let isLeft = self?.isLeft {
                        if isLeft {
                            self?.leftFunc?()
                            print("Focus on left index:", index)
                        } else {
                            self?.rightFunc?()
                            print("Focus on right index:", index)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
}

struct UnitView: View {
    @ObservedObject var unitViewModel: UnitViewModelModel
    @Binding var leftIndex: Int
    @Binding var rightIndex: Int
    @Binding var inputNumber: Double
    
    let unit: Unit
    let action: (() -> String)?

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
                                if unitViewModel.isLeft && leftIndex == unitViewModel.index {
                                    Text(String(inputNumber))
                                } else if !unitViewModel.isLeft && rightIndex == unitViewModel.index {
                                    Text(action?() ?? " ")
                                } else {
                                    Text(" ")
                                }
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

struct Const {
    static let maxDigital: Int = 10
    static let spaceHeight: CGFloat = 110.0
}