import SwiftUI
import SwiftData

struct CaveView: View {
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = CaveViewModel()
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    let columns = [
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        let quantiteBlanc = viewModel.couleurs.first { $0.couleur == .blanc }?.quantite ?? 0
        let quantiteRouge = viewModel.couleurs.first { $0.couleur == .rouge }?.quantite ?? 0
        let quantiteRose = viewModel.couleurs.first { $0.couleur == .rose }?.quantite ?? 0
        
        
        NavigationStack {
            VStack {
                Spacer()
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        NavigationLink(destination: CaveBouteillesView(couleurSelectionnee: .blanc)) {
                            CouleurCardView(couleurSelectionnee: .blanc)
                        }
                        .disabled(quantiteBlanc == 0)
                        .opacity(quantiteBlanc == 0 ? 0.6 : 1.0)
                        HStack {
                            Spacer()
                            Text("\(quantiteBlanc) bouteille(s)")
                                .font(.headline)
                        }
                        NavigationLink(destination: CaveBouteillesView(couleurSelectionnee: .rouge)) {
                            CouleurCardView(couleurSelectionnee: .rouge)
                        }
                        .disabled(quantiteRouge == 0)
                        .opacity(quantiteRouge == 0 ? 0.6 : 1.0)
                        HStack {
                            Spacer()
                            Text("\(quantiteRouge) bouteille(s)")
                                .font(.headline)
                        }
                        NavigationLink(destination: CaveBouteillesView(couleurSelectionnee: .rose)) {
                            CouleurCardView(couleurSelectionnee: .rose)
                        }
                        .disabled(quantiteRose == 0)
                        .opacity(quantiteRose == 0 ? 0.6 : 1.0)
                        HStack {
                            Spacer()
                            Text("\(quantiteRose) bouteille(s)")
                                .font(.headline)
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle(Text("Ma cave"))
        }
        .onAppear {
            viewModel.chargerCouleurs(from: context)
        }
    }
}

#Preview {
    CaveView()
        .modelContainer(SampleData.shared.modelContainer)
}
