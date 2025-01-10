import Charts
import SwiftUI

struct HomeView: View {
    
    let data = [
        (typeVin: "Blanc", quantite: 50),
        (typeVin: "Rouge", quantite: 100),
        (typeVin: "Rosé", quantite: 5)
    ]
    
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
    HomeView()
}
