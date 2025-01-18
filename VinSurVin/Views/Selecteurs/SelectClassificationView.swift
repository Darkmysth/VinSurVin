import SwiftData
import SwiftUI

struct SelectClassificationView: View {
    let selectedRegion: Provenance?
    let selectedSousRegion: Provenance?
    let selectedAppellation: Provenance?
    @Query(sort: \Classification.nomClassification) private var allClassifications: [Classification]
    @Environment(\.modelContext) var modelContext
    @State private var searchQuery: String = ""
    @Binding var selectedClassification: Classification?
    @Environment(\.dismiss) private var dismiss
 
    // Création d'une propriété calculée qui retourne un tableau de type [Classification] (des classifications filtrées selon la recherche de l'utilisateur)
    var filteredClassifications: [Classification] {
        if let appellation = selectedAppellation {
            let classifications = allClassifications.filter { $0.provenance == appellation }
            if !classifications.isEmpty {
                if searchQuery.isEmpty {
                    return classifications
                }
                return classifications.filter { classification in
                    classification.nomClassification.range(of: searchQuery, options: .caseInsensitive) != nil
                }
            } else {
                if let sousRegion = selectedSousRegion {
                    let classifications = allClassifications.filter { $0.provenance == sousRegion }
                    if !classifications.isEmpty {
                        if searchQuery.isEmpty {
                            return classifications
                        }
                        return classifications.filter { classification in
                            classification.nomClassification.range(of: searchQuery, options: .caseInsensitive) != nil
                        }
                    } else {
                        if let region = selectedRegion {
                            let classifications = allClassifications.filter { $0.provenance == region }
                            if !classifications.isEmpty {
                                if searchQuery.isEmpty {
                                    return classifications
                                }
                                return classifications.filter { classification in
                                    classification.nomClassification.range(of: searchQuery, options: .caseInsensitive) != nil
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
                ForEach(filteredClassifications) { classification in
                    Button {
                        selectedClassification = classification
                        dismiss()
                    } label: {
                        Text(classification.nomClassification)
                    }
                }
            }
            .navigationTitle("Classifications")
            .searchable(text: $searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Rechercher")
        }
    }
}
