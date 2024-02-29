//
//  UnitConverter002App.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI

@main
struct UnitConverter002App: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                VStack {
                    UnitConverterMenuView()
                }
                .padding()
            }
            .overlay(ToastView().zIndex(1))
        }
    }
}

struct Const {
    static let maxDigital: Int = 10
    static let spaceHeight: CGFloat = 110.0
    static let toastExistTime: TimeInterval = 2
}
