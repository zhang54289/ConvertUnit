import SwiftUI

class Toast: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var content: AnyView? // AnyView allows us to store any type of view
    
    static let shared = Toast()
    
    private var hideTimer: Timer? // Timer to delay hiding of toast
    private var showTime: Date? // Timestamp when the toast was shown
    
    private init() {}
    
    func showPopup<Content: View>(_ content: Content) {
        self.content = AnyView(content)
        
        if isVisible {
            isVisible = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                self.isVisible = true
            }
        } else {
            isVisible = true
        }
        // Set the timestamp when the toast was shown
        showTime = Date()
        
        // Reset the timer
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
            toast.content // Display the content view passed to Toast
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
