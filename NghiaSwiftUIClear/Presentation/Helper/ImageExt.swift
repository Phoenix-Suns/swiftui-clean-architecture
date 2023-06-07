//
//  Helper.swift
//  NghiaSwiftUIClear
//
//  Created by Nghia Tran on 6/6/23.
//

import Foundation
import SwiftUI

extension Image {
        /**
         Using:
         Image(systemName: "photo")
            .loadURL(urlPath: repo.avatarURL)
         **/
        func loadURL(urlPath: String) -> Image? {
            guard let url =  URL(string:  urlPath) else {
                return nil
            }
    
            if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
                return Image(uiImage: uiImage)
                    .resizable()
            }
            return self
                .resizable()
        }
}
