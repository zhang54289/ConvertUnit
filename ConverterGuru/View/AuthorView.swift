//
//  AuthorView.swift
//  ConverterGuru
//
//  Created by zhanghuan on 3/1/24.
//

import SwiftUI

struct AuthorView: View {
    var body: some View {
        VStack(spacing: 40) {
            picView
            if Locale.current.language.languageCode?.identifier == "en" {
                linkedInView
            }
            emailView
                .bold()
            Spacer()
        }
        .padding(.top, 60)
        .font(.system(size: 20))
    }
    
    @ViewBuilder
    private var picView: some View {
        let imageSize: CGFloat = 150
        ZStack {
            Image("HuanZhang")
                .resizable()
                .scaledToFill()
                .frame(width: imageSize, height: imageSize)
                .clipShape(Capsule())
                .padding(50)
            Capsule()
                .strokeBorder(LinearGradient(gradient: Gradient(colors: [.blue, .red]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 10)
                .frame(width: imageSize + 20, height: imageSize + 20)
        }
    }
    
    @ViewBuilder
    private var linkedInView: some View {
        let linkedinString = "https://www.linkedin.com/in/huan-zhang2202/"
        Button  {
            if let linkedinUrl = URL(string: linkedinString) {
                UIApplication.shared.open(linkedinUrl)
            }
        } label: {
            Text("Huan Zhang's LinkedIn".local)
        }
    }
    
    @ViewBuilder
    private var emailView: some View {
        Link(destination: URL(string: "mailto:zhang54288@gmail.com")!) {
            HStack {
                Image(systemName: "envelope.fill")
                Text("Contact author Huan Zhang".local)
            }
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
