import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String 

    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                HStack {
                    TextField("Search", text: $searchText)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                .padding(.leading, 50)
                Spacer()
            }
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(searchText: .constant(""))
    }
}

