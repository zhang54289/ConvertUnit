//
//  UnitViewModel.swift
//  ConverterGuru
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
    let listHeight: CGFloat
    
    private var cancellables = Set<AnyCancellable>()
    
    init(_ proxy: ScrollViewProxy, _ scrollToID: UUID, _ isLeft: Bool, _ index: Int, listHeight: CGFloat,
         leftFunc: (() -> Void)?, rightFunc: (() -> Void)?) {
        self.proxy = proxy
        self.scrollToID = scrollToID
        self.isLeft = isLeft
        self.index = index
        self.listHeight = listHeight
        self.leftFunc = leftFunc
        self.rightFunc = rightFunc
        
        $geoMidY
            .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard self?.geoMidY != 0 else { return }
                if abs((self?.geoMidY ?? 0) - (self?.theMiddle ?? 0)) < 35.5 {
                    withAnimation {
                        proxy.scrollTo(self?.scrollToID, anchor: .center)
                    }
                    if let isLeft = self?.isLeft {
                        if isLeft {
                            self?.leftFunc?()
                            Toast.shared.showPopup(Text("Focus on left index:".local + String(index)), isDebug: true)
                        } else {
                            self?.rightFunc?()
                            Toast.shared.showPopup(Text("Focus on right index:".local + String(index)), isDebug: true)
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    var theMiddle: CGFloat {
        switch UIScreen.main.bounds.height {
        case 667.0:
            return 187.0
        case 736.0:
            return 202.0
        case 852.0:
            return 270.33
        case 932.0:
            return 291.83
        default:
            return 292
        }
    }
}
