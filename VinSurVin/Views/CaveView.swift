import SwiftUI
import SwiftData

struct CaveView: View {
    @Query private var listeBouteilles: [Bouteille]
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
            List {
                ForEach(listeBouteilles) { bouteille in
                    Text(bouteille.vin.nomVin)
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
