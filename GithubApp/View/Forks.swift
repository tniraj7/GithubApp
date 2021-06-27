import SwiftUI

struct Forks: View {
    
    var forkCount: Int
    
    var body: some View {
        
        VStack {
            
            HStack {
                Image(systemName: "arrow.triangle.branch")
                Text("Forks")
            }
            
            Text("\(forkCount)")
        }
        .padding(.all, 4)
        .font(.system(size: 12))
        .background(Color(.systemGroupedBackground))
        .cornerRadius(5)
    }
}
