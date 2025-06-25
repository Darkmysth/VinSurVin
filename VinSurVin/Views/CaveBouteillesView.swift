import SwiftUI
import SwiftData

struct CaveBouteillesView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveBouteillesViewModel()
    
    // Récupère la couleur et le vin choisis par l'utilisateur
    let couleurSelectionnee: Couleur?
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(alignment: .leading, spacing: 16) {
                ForEach(viewModel.regionsEtAppellations) { regionGroup in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(regionGroup.region?.nomProvenance ?? "Région inconnue")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)

                        ForEach(regionGroup.appellations) { appellationGroup in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(appellationGroup.appellation?.nomProvenance ?? "Appellation inconnue")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 12) {
                                        ForEach(appellationGroup.bouteilles) { recap in
                                            BouteilleCardView(bouteilleSelectionnee: recap.bouteille)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .padding(.top)
            .padding(.bottom, 90)
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if let couleur = couleurSelectionnee {
                viewModel.chargerBouteilles(couleurFiltre: couleur, from: context)
            }
        }
        .navigationTitle("Bouteilles")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    CaveBouteillesView(couleurSelectionnee: .blanc)
        .modelContainer(SampleData.shared.modelContainer)
}
