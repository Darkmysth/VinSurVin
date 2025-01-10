import SwiftUI

struct FonctionnalitesView: View {
    var body: some View {
        NavigationStack {
            List {
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Fonctionnalités")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    FonctionnalitesView()
}
