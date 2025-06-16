import SwiftData
import SwiftUI

struct ConservationHomeView: View {
    
    // Accès au contexte SwiftData
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel: ConservationViewModel
    
    // Ajoute cet init pour injecter le ViewModel
    init() {
        _viewModel = StateObject(wrappedValue: ConservationViewModel()) // ou avec un paramètre
    }
    
    var body: some View {
        VStack {
            List {
                // Bouteilles en déclin
                let declin = viewModel.quantitesParStatut.first(where: { $0.statut == .declin }) ?? .init(statut: .declin, quantite: 0)
                NavigationLink(destination: ConservationBouteillesView(statut: .declin)) {
                    HStack {
                        Label("Déclin", systemImage: "chart.line.downtrend.xyaxis")
                        Spacer()
                        Text("\(declin.quantite) bouteille(s)")
                    }
                }
                .listRowBackground(Color.red.opacity(0.2))
                .foregroundColor(.red)
                
                // Bouteilles à leur apogée encore 1 an
                let derniereAnneeApogee = viewModel.quantitesParStatut.first(where: { $0.statut == .derniereAnneeApogee }) ?? .init(statut: .derniereAnneeApogee, quantite: 0)
                NavigationLink(destination: ConservationBouteillesView(statut: .derniereAnneeApogee)) {
                    HStack {
                        Label("Dernière année", systemImage: "exclamationmark.triangle.fill")
                        Spacer()
                        Text("\(derniereAnneeApogee.quantite) bouteille(s)")
                    }
                }
                .listRowBackground(Color.yellow.opacity(0.2))
                .foregroundColor(.orange)
                
                // Bouteilles à leur apogée
                let apogee = viewModel.quantitesParStatut.first(where: { $0.statut == .apogee }) ?? .init(statut: .apogee, quantite: 0)
                NavigationLink(destination: ConservationBouteillesView(statut: .apogee)) {
                    HStack {
                        Label("Apogée", systemImage: "checkmark.circle.fill")
                        Spacer()
                        Text("\(apogee.quantite) bouteille(s)")
                    }
                }
                .listRowBackground(Color.green.opacity(0.2))
                .foregroundColor(.green)
                
                // Bouteilles à conserver
                let conservation = viewModel.quantitesParStatut.first(where: { $0.statut == .conservation }) ?? .init(statut: .conservation, quantite: 0)
                NavigationLink(destination: ConservationBouteillesView(statut: .conservation)) {
                    HStack {
                        Label("Conservation", systemImage: "hourglass")
                        Spacer()
                        Text("\(conservation.quantite) bouteille(s)")
                    }
                }
                .listRowBackground(Color.blue.opacity(0.2))
                .foregroundColor(.blue)
            }
            .frame(height: 400)
            .scrollDisabled(true)
        }
        .onAppear{
            viewModel.chargerBouteillesLimiteConservation(from: context)
        }
    }
}

#Preview {
    ConservationHomeView()
        .modelContainer(SampleData.shared.modelContainer)
}
