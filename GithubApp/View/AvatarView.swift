import SwiftUI
import Combine

struct AvatarView: View {
    
    @StateObject var imageDownloader = ImageDownloader()
    
    var avatarURL: String
    
    var body: some View {
        
        VStack {
            
            if imageDownloader.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.1)
            } else {
                
                if let downloadedImage = imageDownloader.image {
                    Image(uiImage: downloadedImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                        .cornerRadius(5)
                } else {
                    Image(systemName: "photo")
                }
            }
        }.onAppear {
            imageDownloader.fetchAvatarImage(imageUrl: avatarURL)
        }
    }
}
