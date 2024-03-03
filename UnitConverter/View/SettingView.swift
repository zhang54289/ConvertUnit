//
//  SettingView.swift
//  UnitConverter
//
//  Created by zhanghuan on 3/2/24.
//

import SwiftUI

struct SettingView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            closeButton
                .padding(.bottom, 20)
            ToggleView()
            Spacer()
        }
        .padding(.top, 60)
        .font(.system(size: 20))
    }
    
    @ViewBuilder
    private var closeButton: some View {
        HStack {
            Spacer()
            Image(systemName: "xmark")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .padding(.trailing, 40)
                .onTapGesture {
                    dismiss()
                }
        }
    }
}

struct ColorPickerView: View {
    @State private var bgColor = Color.red
    let title: String

    var body: some View {
        VStack {
            ColorPicker(title, selection: $bgColor)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor)
    }
}
