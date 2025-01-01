import SwiftUI
import SwiftData

struct ContentView: View {
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .frame(width: 150, height: 150)
                    .foregroundStyle(.tint)
                
                Image(systemName: "wineglass")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
            }
            
            Text("VinSurVin")
                .font(.title)
                .fontWeight(.semibold)
                .padding(.top)
            
            Text("L'App qui optimise ma cave")
                .font(.title2)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
