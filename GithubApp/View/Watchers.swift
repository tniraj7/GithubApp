import SwiftUI

struct Watchers: View {
    
    var watchers: Int
    
    var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "eye")
                Text("Watch")
            }
            Text("\(watchers)")
        }
        .padding(.all, 4)
        .font(.system(size: 12))
        .background(Color(.systemGroupedBackground))
        .cornerRadius(5)
    }
}
