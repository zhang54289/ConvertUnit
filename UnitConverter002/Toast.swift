import SwiftUI

class Toast: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var message: String = ""
    
    static let shared = Toast()
    
    private init() {}
    
    func showPopup(_ message: String) {
        self.message = message
        isVisible = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isVisible = false
        }
    }
}

struct ToastView: View {
    @ObservedObject var toast = Toast.shared
    
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
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            withAnimation {
                                self.toast.isVisible = false
                            }
                        }
                    }
                    .padding(.bottom, 10)
            }
            .frame(maxWidth: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.all)
            .transition(.opacity)
        }
    }
}
