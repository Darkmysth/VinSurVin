import Charts
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    // Récupère le stock de bouteilles en cave
    @Query private var listeBouteilles: [Bouteille]
    var nbBouteilles: Int {
        listeBouteilles.reduce(0) { $0 + $1.quantite }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("\(nbBouteilles) bouteille(s)")
                        .font(.title2)
                        .foregroundColor(.primary)
                        .padding()
                    NavigationLink(destination: CaveView()) {
                        GraphiqueHomeView(data: viewModel.dataPourGraphique)
                            .onAppear {
                                viewModel.chargerBouteilles(depuis: context)
                            }
                    }
                    ConservationHomeView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Accueil")
                        .font(.largeTitle)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) { // Place le bouton à droite
                    NavigationLink(destination: AjoutBouteilleView()) {
                        Image(systemName: "plus") // Icône "+"
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}

