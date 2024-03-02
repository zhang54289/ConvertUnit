//
//  UnitViewModel.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/28/24.
//

import Foundation
import SwiftUI
import Combine

final class UnitViewModel: ObservableObject {
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
