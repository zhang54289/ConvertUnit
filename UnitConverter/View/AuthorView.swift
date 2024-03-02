//
//  AuthorView.swift
//  UnitConverter
//
//  Created by zhanghuan on 3/1/24.
//

import SwiftUI

struct AuthorView: View {
    var body: some View {
        VStack(spacing: 60) {
            picView
            linkedInView
            gitHubView
            Spacer()
            ToggleView()
        }
        .padding(.top, 60)
        .font(.system(size: 20))
    }
    
    @ViewBuilder
    private var picView: some View {
        let imageSize: CGFloat = 150
        Image("Author")
            .resizable()
            .scaledToFill()
            .frame(width: imageSize, height: imageSize)
            .clipShape(Capsule())
    }
    
    @ViewBuilder
    private var linkedInView: some View {
        let linkedinString = "https://www.linkedin.com/in/huan-zhang2202/"
        Button  {
            if let linkedinUrl = URL(string: linkedinString) {
              UIApplication.shared.open(linkedinUrl)
            }
        } label: {
            Text("Huan Zhang's LinkedIn")
        }
    }
    
    @ViewBuilder
    private var gitHubView: some View {
        let linkedinString = "https://github.com/zhang54289/ConvertUnit"
        Button  {
            if let linkedinUrl = URL(string: linkedinString) {
              UIApplication.shared.open(linkedinUrl)
            }
        } label: {
            Text("GitHub Source Code")
        }
    }
}