//
//  RepoListView.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import SwiftUI

struct ReposWithLoadingView: View {
    @StateObject var vm = ReposWithLoadingVM()
    
    var body: some View {
        RepoList()
    }
    
    fileprivate func RepoList() -> some View {
        List {
            SearchbarView(text: $vm.searchKey)
            ForEach(vm.repos) { item in
                repoRow(item)
            }
            
            
            if vm.refreshing {
                
            } else if vm.loadingMore {
                // === Load More ===
                ProgressView().id(UUID())
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
                //refreshable support await
                await vm.getRepos(vm.searchKey)
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
            let page = vm.page + 1
            await vm.getRepos(vm.searchKey, page: page)
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
