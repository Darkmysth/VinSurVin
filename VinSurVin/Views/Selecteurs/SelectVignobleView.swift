import SwiftData
import SwiftUI

struct SelectVignobleView: View {
    let selectedRegion: Provenance?
    let selectedSousRegion: Provenance?
    let selectedAppellation: Provenance?
    @Query(sort: \Vignoble.nomVignoble) private var allVignobles: [Vignoble]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @Binding var selectedVignoble: Vignoble?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Vignoble] (des vignobles filtrés selon la recherche de l'utilisateur)
    var filteredVignobles: [Vignoble] {
        if let appellation = selectedAppellation {
            let vignobles = allVignobles.filter { $0.provenance == appellation }
            if !vignobles.isEmpty {
                if searchQuery.isEmpty {
                    return vignobles
                }
                return vignobles.filter { vignoble in
                    vignoble.nomVignoble.range(of: searchQuery, options: .caseInsensitive) != nil
                }
            } else {
                if let sousRegion = selectedSousRegion {
                    let vignobles = allVignobles.filter { $0.provenance == sousRegion }
                    if !vignobles.isEmpty {
                        if searchQuery.isEmpty {
                            return vignobles
                        }
                        return vignobles.filter { vignoble in
                            vignoble.nomVignoble.range(of: searchQuery, options: .caseInsensitive) != nil
                        }
                    } else {
                        if let region = selectedRegion {
                            let vignobles = allVignobles.filter { $0.provenance == region }
                            if !vignobles.isEmpty {
                                if searchQuery.isEmpty {
                                    return vignobles
                                }
                                return vignobles.filter { vignoble in
                                    vignoble.nomVignoble.range(of: searchQuery, options: .caseInsensitive) != nil
                                }
                            }
                        }
                    }
                }
            }
        }
        return []
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredVignobles) { vignoble in
                    Button {
                        selectedVignoble = vignoble
                        dismiss()
                    } label: {
                        Text(vignoble.nomVignoble)
                    }
                }
            }
            .navigationTitle("Vignobles")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
