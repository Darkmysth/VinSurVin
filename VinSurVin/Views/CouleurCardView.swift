import SwiftUI
import SwiftData

struct CouleurCardView: View {
    
    let couleurSelectionnee: Couleur
    
    var body: some View {
        switch couleurSelectionnee {
        case .blanc:
            Image("blanc")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 190)
                .clipped()
                .cornerRadius(12)
        case .rouge:
            Image("rouge")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 190)
                .clipped()
                .cornerRadius(12)
        case .rose:
            Image("rose")
                .resizable()
                .scaledToFill()
                .frame(width: 400, height: 190)
                .clipped()
                .cornerRadius(12)
        }
    }
}

#Preview {
    CouleurCardView(couleurSelectionnee: .blanc)
}
