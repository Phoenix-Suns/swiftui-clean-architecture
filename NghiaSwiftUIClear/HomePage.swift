//
//  HomePage.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/5/23.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
        NavigationView {
            List {
                // Navigation Button
                NavigationLink {
                    RepoListView()
                } label: {
                    Text("Repo List")
                }
                NavigationLink {
                    ReposWithLoadingView()
                } label: {
                    Text("Repo List With Loading")
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
