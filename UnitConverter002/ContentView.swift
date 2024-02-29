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
                UnitConverterMenuView()
            }
            .padding()
        }
    }
}

struct Const {
    static let maxDigital: Int = 10
    static let spaceHeight: CGFloat = 110.0
}
