//
//  Untitled.swift
//  GithubFeaturedExplorer
//
//  Created by EVGENY SYSENKA on 06/06/2025.
//

import Foundation

struct Readme: Decodable {
    var name: String
    var download_url: String
}

struct Markdown: Encodable {
    var text: String
    var mode = "gfm"
}
