import SwiftUI
import Combine

struct RepositoryListView: View {
    
    @StateObject var viewModel = RepositoriesViewModel()
    @State var isSearching = false
    
    var body: some View {
        
        NavigationView {
            
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack(spacing: 10) {
                    
                    SearchBar(isSearching: $isSearching, searchKeyword: $viewModel.searchKeyword)

                    if (!isSearching) {
                        Text("Type to search repositories")
                            .font(.title3)
                            .padding(.top, 20)
                    }
                    
                    if let repositoryList = viewModel.repositoryList {
                        if (repositoryList.isEmpty && isSearching) {
                            
                            Text("No Results Found")
                                .font(.title3)
                                .foregroundColor(.red)
                                .padding(.top, 20)
                            
                        }  else {
                            
                            ForEach(repositoryList) { repository in
                                RepositoryView(repository: repository)
                            }
                        }
                    } else {
                        
                        if (viewModel.searchKeyword != "" && viewModel.isLoading) {
                            ProgressView("searching..")
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(1.0)
                        }
                    }
                }
                .animation(.easeOut)
                .navigationBarTitle("Github Repositories")

            }
        }
    }
}
