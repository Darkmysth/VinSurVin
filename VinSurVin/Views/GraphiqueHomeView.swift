import Charts
import SwiftUI

struct GraphiqueHomeView: View {
    let data: [(typeVin: String, quantite: Int)]
    var body: some View {
        NavigationStack {
            Chart(data, id: \.typeVin) { typeVin, quantite in
                SectorMark(
                    angle: .value("Quantité", quantite),
                    innerRadius: .ratio(0.5),
                    outerRadius: .inset(10),
                    angularInset: 1
                )
                .cornerRadius(4)
                .foregroundStyle(by: .value("Vin", typeVin))
            }
            .chartForegroundStyleScale([
                "Blanc": .yellow,
                "Rouge": .red,
                "Rosé": .pink
            ])
            .chartLegend(position: .topLeading) // Positionne la légende
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Accueil")
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) { // Place le bouton à droite
                    NavigationLink(destination: AddBouteilleView()) {
                        Image(systemName: "plus") // Icône "+"
                    }
                }
            }
        }
    }
}


#Preview {
   GraphiqueHomeView(
    data: [
        ("Blanc", 10),
        ("Rouge", 15),
        ("Rosé", 3)
    ]
   )
}
