import SwiftUI

struct Stargazers: View {
    
    var stargazers: Int = 0
    
    var body: some View {
        VStack {
            
            HStack {
                Image(systemName: "star")
                Text("Stars")
            }
            
            Text("\(stargazers)").frame(alignment: .leading)
        }
        .padding(.all, 4)
        .font(.system(size: 12))
        .background(Color(.systemGroupedBackground))
        .cornerRadius(5)
    }
}

struct Stargazers_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Stargazers()
                .preferredColorScheme(.light)
                .previewDevice("iPhone 12 mini")
        }
    }
}
