//
//  SettingView.swift
//  ConverterGuru
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
            ColorSettingView()
            Spacer()
        }
        .padding(.top, 60)
        .padding(.horizontal, 40)
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
                .onTapGesture {
                    dismiss()
                }
        }
    }
}
