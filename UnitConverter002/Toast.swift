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
    
    var body: some View {
        if toast.isVisible {
            VStack {
                Spacer()
                Text(toast.message)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .transition(.move(edge: .bottom))
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
            .onAppear {
                // Invalidate previous timer if exists
                hideTimer?.invalidate()
                
                // Start timer to hide toast after a delay
                hideTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                    withAnimation {
                        self.toast.isVisible = false
                    }
                }
            }
            .onDisappear {
                // Invalidate timer when view disappears
                hideTimer?.invalidate()
            }
        }
    }
}
