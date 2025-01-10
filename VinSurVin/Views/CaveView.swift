import SwiftUI
import SwiftData

struct CaveView: View {
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    ZStack {
                        Color.clear.frame(width: 40)
                        Image(systemName: "globe.europe.africa")
                    }
                    Text("Provenance")
                }
                HStack {
                    ZStack {
                        Color.clear.frame(width: 40)
                        Image(systemName: "house.lodge")
                    }
                    Text("Domaine")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Ma cave")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    CaveView()
}
