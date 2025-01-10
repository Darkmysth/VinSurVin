import SwiftUI
import SwiftData

struct ReglagesView: View {
    
    var body: some View {
        NavigationStack {
            List {
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Réglages")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    ReglagesView()
}
