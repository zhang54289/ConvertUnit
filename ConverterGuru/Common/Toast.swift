//
//  Toast.swift
//  ConverterGuru
//
//  Created by Huan Zhang on 2/12/24.
//

import SwiftUI

class Toast: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var content: AnyView?
    @ObservedObject var settings = GlobalSettings.shared
    
    static let shared = Toast()
    
    private var hideTimer: Timer?
    private var showTime: Date?
    
    private init() {}
    
    func showPopup<Content: View>(_ content: Content, isDebug: Bool = false) {
        guard !isDebug || settings.isSwitchedOn else {
            return
        }
        
        DispatchQueue.main.async {
            self.content = AnyView(content)
            self.isVisible = true
            
            self.showTime = Date()
            
            self.hideTimer?.invalidate()
            self.hideTimer = Timer.scheduledTimer(withTimeInterval: Const.toastExistTime, repeats: false) { _ in
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
    @EnvironmentObject var colorSettings: ColorSettings
    
    @State private var hideTimer: Timer?
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            toast.content
                .padding()
                .background(colorSettings.toastBackgroudColor)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
                .offset(y: yOffset)
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: toast.isVisible) { _, newValue in
            if newValue {
                withAnimation(.easeInOut(duration: 1.0)) {
                    yOffset = 0
                }
            } else {
                withAnimation(.easeInOut(duration: 1.0)) {
                    yOffset = UIScreen.main.bounds.height
                }
                hideTimer?.invalidate()
            }
        }
    }
}

class GlobalSettings: ObservableObject {
    static let shared = GlobalSettings()
    
    @Published var isSwitchedOn: Bool {
        didSet {
            UserDefaults.standard.set(isSwitchedOn, forKey: "isSwitchedOn")
        }
    }
    
    private init() {
        self.isSwitchedOn = UserDefaults.standard.bool(forKey: "isSwitchedOn")
    }
}

struct ToggleView: View {
    @ObservedObject var settings = GlobalSettings.shared
    
    var body: some View {
        Toggle(isOn: $settings.isSwitchedOn) {
            Text("Debug toast:  ".local)
            + Text("\(settings.isSwitchedOn ? "On".local : "Off".local)")
                .foregroundColor(settings.isSwitchedOn ? .red: .green)
        }
        .onChange(of: settings.isSwitchedOn) { _, value in
            if !value {
                Toast.shared.isVisible = false
            }
        }
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
