import SwiftUI

struct RepositoryView: View {
    
    var repository: Item
    
    var body: some View  {
        
        VStack(alignment: .leading, spacing: 8) {
            
            Group {
                
                HStack(alignment: VerticalAlignment.center, spacing: 10) {
                    AvatarView(avatarURL: repository.owner.avatar_url)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("Repo Name: \(repository.name)")
                            .font(.subheadline)
                        
                        
                        Text("Owner: \(repository.owner.login)")
                            .font(.subheadline)
                        
                        if (repository.language != nil) {
                            Text("Language: \(repository.language!)")
                                .font(.subheadline)
                        }
                    }
                }
                
                HStack(spacing: 10) {
                    Stargazers(stargazers: repository.stargazers_count)
                    Watchers(watchers: repository.watchers_count)
                    Forks(forkCount: repository.forks_count)
                }
            }
            .padding()
        }
        .frame(maxWidth: UIScreen.main.bounds.width - 20, alignment: .leading)
        .background(Color(.systemGray5))
        .cornerRadius(10)
        .shadow(radius: 1)
        
    }
}
