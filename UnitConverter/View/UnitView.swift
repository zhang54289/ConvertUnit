//
//  UnitView.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/28/24.
//

import SwiftUI

struct UnitView: View {
    @ObservedObject var unitViewModel: UnitViewModel
    @Binding var leftIndex: Int
    @Binding var rightIndex: Int
    @Binding var inputNumber: Double
    
    let unit: Unit
    let action: (() -> String)?
    
    var body: some View {
        GeometryReader { geometry in
            let geoMidY = geometry.frame(in: .global).midY
            ZStack {
                Color.gray
                    .onChange(of: geoMidY) { newValue in
                        unitViewModel.geoMidY = newValue
                    }
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                if unitViewModel.isLeft && leftIndex == unitViewModel.index {
                                    Text(String(inputNumber).trimDotZero())
                                } else if !unitViewModel.isLeft && rightIndex == unitViewModel.index {
                                    Text(action?() ?? " ")
                                } else {
                                    Text(" ")
                                }
                            }
                            HStack(spacing: 10) {
                                Text(unit.name.capitalized)
                                Spacer()
                                Text(unit.n)
                            }
                        }
                            .padding(5)
                    )
            }
            .padding(5)
        }
    }
}

extension String {
    func trimDotZero() -> String {
        return self
            .replacingOccurrences(of: "\\.0$", with: "", options: .regularExpression)
    }
}

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

