import Charts
import SwiftUI
import SwiftData

struct HomeView: View {
    
    @Environment(\.modelContext) private var context
    
    // Relie cette vue avec son ViewModel
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            //NavigationLink(destination: CaveView()) {
                GraphiqueHomeView(data: viewModel.dataPourGraphique)
                    .onAppear {
                        viewModel.chargerBouteilles(depuis: context)
                    }
            //}
            CaveView()
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(SampleData.shared.modelContainer)
}

