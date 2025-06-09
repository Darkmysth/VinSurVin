import Charts
import SwiftUI
import SwiftData

struct GraphiqueHomeView: View {
    
    let data: [(typeVin: String, quantite: Int)]
    var body: some View {
        VStack {
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
            .frame(height: 350)
            .chartForegroundStyleScale([
                "Blanc": .yellow,
                "Rouge": .red,
                "Rosé": .pink
            ])
            .chartLegend(position: .top) // Positionne la légende
            .padding(20)
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
