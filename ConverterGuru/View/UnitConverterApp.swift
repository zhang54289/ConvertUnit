//
//  UnitConverterApp.swift
//  UnitConverter
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI

@main
struct UnitConverterApp: App {
    @StateObject var colorSettings = ColorSettings()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSettings)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var colorSettings: ColorSettings

    var body: some View {
        NavigationView {
            VStack {
                UnitConverterMenuView()
            }
            .padding()
            .navigationTitle("Select Unit".local)
            .background(colorSettings.menuBackgroudColor)
        }
        .overlay(ToastView().zIndex(1))
    }
}

struct Const {
    static let maxDigital: Int = 10
    static let spaceHeight: CGFloat = 180
    static let toastExistTime: TimeInterval = 2
}
