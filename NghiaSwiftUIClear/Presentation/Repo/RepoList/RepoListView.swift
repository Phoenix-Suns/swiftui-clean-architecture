//
//  RepoListView.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import SwiftUI

struct RepoListView: View {
    @StateObject var vm = RepoListVM()

    var body: some View {
        RepoList()
    }
    
    fileprivate func RepoList() -> some View {
        List {
            ForEach(vm.repos) { item in
                repoRow(item)
            }
        }
        .navigationTitle("Repo List")
        // Get data First time
        .task {
            await vm.getRepos()
        }
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
}

struct RepoListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            RepoListView()
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
