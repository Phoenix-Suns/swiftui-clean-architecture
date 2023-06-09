//
//  PullToRefreshView.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/7/23.
//

import SwiftUI

struct PullToRefreshView: View {
    
    var coordinateSpaceName: String
    var onRefresh: ()->Void
    
    @State var needRefresh: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            if (geo.frame(in: .named(coordinateSpaceName)).midY > 50) {
                Spacer()
                    .onAppear {
                        needRefresh = true
                    }
            } else if (geo.frame(in: .named(coordinateSpaceName)).maxY < 10) {
                Spacer()
                    .onAppear {
                        if needRefresh {
                            needRefresh = false
                            onRefresh()
                        }
                    }
            }
            HStack {
                Spacer()
                if needRefresh {
                    ProgressView()
                } else {
                    Text("⬇️")
                }
                Spacer()
            }
        }.padding(.top, -50)
    }
}

struct PullToRefreshView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            PullToRefreshView(coordinateSpaceName: "pullToRefresh") {
                // do your stuff when pulled
            }
            Text("Some view...")
        }.coordinateSpace(name: "pullToRefresh")
    }
}
