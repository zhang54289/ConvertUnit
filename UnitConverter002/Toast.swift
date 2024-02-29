//
//  Toast.swift
//  UnitConverter002
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI

class Toast: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var content: AnyView?
    
    static let shared = Toast()
    
    private var hideTimer: Timer?
    private var showTime: Date?
    
    private init() {}
    
    func showPopup<Content: View>(_ content: Content) {
        DispatchQueue.main.async {
            self.content = AnyView(content)
            self.isVisible = true
            
            self.showTime = Date()
            
            self.hideTimer?.invalidate()
            self.hideTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
                DispatchQueue.main.async {
                    self.isVisible = false
                }
            }
        }
    }
    
    deinit {
        hideTimer?.invalidate()
    }
}

struct ToastView: View {
    @ObservedObject var toast = Toast.shared
    
    @State private var hideTimer: Timer?
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            toast.content
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
                .offset(y: yOffset)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: toast.isVisible) { newValue in
            if newValue {
                withAnimation(.easeInOut) {
                    yOffset = 0
                }
            } else {
                withAnimation(.easeInOut) {
                    yOffset = UIScreen.main.bounds.height
                }
                hideTimer?.invalidate()
            }
        }
    }
}
