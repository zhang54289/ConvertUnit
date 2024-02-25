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
            ContentView()
                .overlay(ToastView().zIndex(1)) // Add ToastView overlay
        }
    }
}
