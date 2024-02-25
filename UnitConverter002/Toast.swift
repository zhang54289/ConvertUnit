import SwiftUI

class Toast: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var message: String = ""
    
    static let shared = Toast()
    
    private var hideTimer: Timer? // Timer to delay hiding of toast
    
    private init() {}
    
    func showPopup(_ message: String) {
        self.message = message
        isVisible = true
        
        hideTimer?.invalidate() // Invalidate previous timer if exists
        hideTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
            DispatchQueue.main.async {
                self.isVisible = false
            }
        }
    }
    
    deinit {
        hideTimer?.invalidate() // Invalidate timer when the object is deallocated
    }
}

struct ToastView: View {
    @ObservedObject var toast = Toast.shared
    
    // Timer to delay hiding of toast
    @State private var hideTimer: Timer?
    
    // State to track the toast's vertical offset
    @State private var yOffset: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Spacer()
            Text(toast.message)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .padding(.bottom, 10)
                .offset(y: yOffset) // Apply vertical offset
        }
        .frame(maxWidth: .infinity, alignment: .bottom)
        .edgesIgnoringSafeArea(.all)
        .onChange(of: toast.isVisible) { newValue in
            if newValue {
                // Show toast with slide-in animation
                withAnimation(.easeInOut) {
                    yOffset = 0
                }
                
                // Start timer to hide toast after a delay
                hideTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    withAnimation {
                        self.toast.isVisible = false
                    }
                }
            } else {
                // Hide toast with slide-out animation
                withAnimation(.easeInOut) {
                    yOffset = UIScreen.main.bounds.height
                }
                
                // Invalidate timer when hiding toast
                hideTimer?.invalidate()
            }
        }
    }
}
