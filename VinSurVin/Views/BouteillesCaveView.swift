import SwiftUI
import SwiftData

struct BouteillesCaveView: View {
    
    // Requête qui récupère toutes les bouteilles en stock dans la cave
    @Query(
        filter: #Predicate<Bouteille> { $0.quantiteBouteilles > 0 },
        sort: \Bouteille.millesime
    ) var bouteillesCave: [Bouteille]
    
    // Gère les recherches de l'utilisateur
    @State private var searchQuery: String = ""
    var bouteillesFiltrees: [Bouteille] {
        if searchQuery.isEmpty {
            return bouteillesCave
        } else {
            return bouteillesCave.filter {
                $0.vin.nomVin.lowercased().contains(searchQuery.lowercased()) || $0.millesime.description.lowercased().contains(searchQuery.lowercased())
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(bouteillesFiltrees) { bouteille in
                    NavigationLink(destination: BouteilleView(selectedBouteille: bouteille)) {
                        Text("\(bouteille.vin.nomVin) - \(bouteille.millesime.description)")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Bouteilles en cave")
                        .font(.largeTitle)
                        .bold()
                }
            }
            .searchable(text: $searchQuery)
        }
    }
}

#Preview {
    BouteillesCaveView()
        .modelContainer(SampleData.shared.modelContainer)
}
