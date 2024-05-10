// ContentView.swift

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @State private var likedArticles: [Article] = []
    @AppStorage("selectedTab") var selectedTab: Tab = .user
    @State private var articles: [Article] = []
    @State private var selectedCountry: String = "US"
    @State private var selectedCategory: String?
    @State private var searchText = ""
    @State var isOpen = false
    
    @State private var isSearchBarVisible = false

    let countries = ["US", "GB", "TR"]
    let categories = ["science", "general", "sports"]
    let button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoPlay: false)
    let button2 = RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH")

    var body: some View {
        VStack {
            NavigationView {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(articles, id: \.url) { article in
                            Button(action: {
                                guard let url = URL(string: article.url) else { return }
                                UIApplication.shared.open(url)
                            }) {
                                if selectedTab == .user {
                                    ArticleCard(article: article)
                                        .frame(width: UIScreen.main.bounds.width - 64)
                                        .rotation3DEffect(
                                            .degrees(isOpen ? -30 : 0),
                                            axis: (x: 0, y: 1, z: 0),
                                            anchor: .center,
                                            perspective: 0.9
                                        )
                                        .scaleEffect(isOpen ? 0.9 : 1)
                                        .offset(x: isOpen ? 225 : 0)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding()
                .background(LinearGradient(colors: [.white, .blue], startPoint: .top, endPoint: .trailing))
                .onAppear {
                    fetchNews(country: selectedCountry, category: selectedCategory ?? "") { fetchedArticles in
                        DispatchQueue.main.async {
                            self.articles = fetchedArticles
                        }
                    }
                }
            }
            .overlay(
                ZStack {
                    if selectedTab == .user {
                  
                        SideMenu(){ country, category in
                   
                            fetchNews(country: country, category: category ?? "") { fetchedArticles in
                                DispatchQueue.main.async {
                                    self.articles = fetchedArticles
                                }
                            }
                        }
                        .opacity(isOpen ? 1 : 0)
                        .offset(x: isOpen ? 0 : -100)
                        .rotation3DEffect(
                            .degrees(isOpen ? 0 : 30),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .safeAreaInset(edge: .top) {
                            Color.clear.frame(height: 104)
                        }
                        .safeAreaInset(edge: .bottom) {
                            Color.clear.frame(height: 80)
                        }
                        .mask(RoundedRectangle(cornerRadius: 50, style: .continuous))
                        .rotation3DEffect(
                            .degrees(isOpen ? 30 : 0),
                            axis: (x: 0, y: 1, z: 0)
                        )
                        .offset(x: isOpen ? 5 : 0)
                        .scaleEffect(isOpen ? 0.9 : 1)
                        .ignoresSafeArea()
                    }
                    if selectedTab == .user {
                        button.view()
                            .background(.white)
                            .frame(width: 44, height: 44)
                            .mask(Circle())
                            .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding()
                            .offset(x: isOpen ? 216 : 0)
                            .onTapGesture {
                                button.setInput("isOpen", value: isOpen)
                                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                    isOpen.toggle()
                                }
                            }
                    }

                    switch selectedTab {
                    case .user:
                        
                        Text("")
                    case .likeStar:
                        LikeStarView()
                    case .search:
                        SearchView()
                    }
                    TabBar(selectedTab: $selectedTab)
                        .offset(y: isOpen ? 300 : 0)
                }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        
    }
}

private func performSearch() {}
