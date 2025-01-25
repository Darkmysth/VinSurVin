import SwiftUI
import SwiftData

struct ReferentielsView: View {
    
    var body: some View {
        NavigationStack {
            List {
                // Lien vers la vue de gestion des Pays
                NavigationLink(destination: ReferentielProvenancesView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "globe.europe.africa")
                        }
                        Text("Provenances")
                    }
                }
                // Lien vers la vue de gestion des Tailles
                NavigationLink(destination: ReferentielTaillesView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "square.resize.up")
                        }
                        Text("Tailles")
                    }
                }
                // Lien vers la vue de gestion des Classifications
                NavigationLink(destination: ReferentielClassificationsView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "medal")
                        }
                        Text("Classifications")
                    }
                }
                // Lien vers la vue de gestion des Vignobles
                NavigationLink(destination: ReferentielVignoblesView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "star")
                        }
                        Text("Vignobles")
                    }
                }
                // Lien vers la vue de gestion des Vins
                NavigationLink(destination: ReferentielVinsView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "bookmark.square.fill")
                        }
                        Text("Vins")
                    }
                }
                // Lien vers la vue de gestion des Domaines
                NavigationLink(destination: ReferentielDomainesView()) {
                    HStack {
                        ZStack {
                            Color.clear.frame(width: 40)
                            Image(systemName: "house.lodge")
                        }
                        Text("Domaines")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Référentiels")
                        .font(.largeTitle)
                        .bold()
                }
            }
        }
    }
}

#Preview {
    ReferentielsView()
}
