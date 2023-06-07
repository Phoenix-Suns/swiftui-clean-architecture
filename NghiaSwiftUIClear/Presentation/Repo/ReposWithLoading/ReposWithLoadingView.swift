//
//  RepoListView.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import SwiftUI

struct ReposWithLoadingView: View {
    @StateObject var vm = ReposWithLoadingViewModel()

    var body: some View {
        RepoList()
    }
    
    fileprivate func RepoList() -> some View {
        List {
            SearchbarView(text: $vm.searchKey)
            ForEach(vm.repos) { item in
                repoRow(item)
            }
            
            // === Load More ===
            if vm.refreshing || vm.loadingMore {
                ProgressView()
            } else {
                Button(action: loadMore) {
                    Text("Load More")
                }
                .onAppear {
                    Task {
                        try? await Task.sleep(nanoseconds: 100_000_000) // 100 milisecond
                        self.loadMore()
                    }
                }
            }
        }
        .refreshable {
            if (!vm.refreshing) {
                Task {
                    await vm.getRepos(vm.searchKey)
                }
            }
        }
        .navigationTitle("Repo List")
        // Get data First time
//        .task {
//            await vm.getRepos("")
//        }
        .alert("Error", isPresented: $vm.hasError) {
        } message: {
            Text(vm.errorMessage)
        }
    }
    
    fileprivate func repoRow(_ repo: Repo) -> some View {
        HStack{
            AsyncImage(url: URL(string: repo.avatarURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        //.frame(maxWidth: 300, maxHeight: 100)
                case .failure:
                    Image(systemName: "photo")
                @unknown default:
                    EmptyView()
                }
            }
                .frame(width: 50, height: 50)
            Text("\(repo.name)")
        }
    }
    
    func loadMore() {
        print("Load more...")
        Task {
            await vm.getMoreRepos()
        }
    }
}

struct ReposWithLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ReposWithLoadingView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
