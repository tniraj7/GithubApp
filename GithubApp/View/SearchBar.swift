import SwiftUI

struct SearchBar: View {
    
    @Binding var isSearching: Bool
    @Binding var searchKeyword: String
    
    var body: some View {
        
        HStack {
            
            HStack {
                TextField("Search ...", text: $searchKeyword)
                    .padding(.leading, 30 )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.all, 10)
            .background(Color(.systemGray5))
            .cornerRadius(8)
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
            }
            .overlay (
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    if isSearching {
                        Button(action: {
                            searchKeyword = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        }
                    }
                }
                .padding(.horizontal, 32)
                .foregroundColor(.gray)
            )
            
            
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchKeyword = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
        }
    }
}
