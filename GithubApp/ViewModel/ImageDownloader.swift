import UIKit
import Combine

class ImageDownloader: ObservableObject {
    
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = false
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchAvatarImage(imageUrl: String) {
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: URL(string: imageUrl)!)
            .receive(on: DispatchQueue.main)
            .map { UIImage(data: $0.data) }
            .sink { completion in
                
                switch completion {
                
                case .failure(let error):
                    self.isLoading = false
                    fatalError(error.localizedDescription)
                    
                case .finished: break
                    
                }
                
            } receiveValue: { [weak self] downloadedImage in
                self?.image = downloadedImage
                self?.isLoading = false
            }
            .store(in: &cancellable)
        
    }
}
