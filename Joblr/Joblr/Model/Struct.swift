//
//  Struct.swift
//  Joblr
//
//  Created by 王锴文 on 10/26/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import Foundation

struct Job: Codable {
    var type: String
    var url: String
    var created_at: String
    var company: String
    var location: String
    var title: String
    var description: StringLiteralType
    var how_to_apply: StringLiteralType
    var company_logo: StringLiteralType?
}

struct Jobset: Codable {
    var jobs: [Job]
}

struct URLHead {
    let head = "https://jobs.github.com/positions.json?"
    var description: String?
    var location: String?
}

struct Liked {
    var type: String
    var created_at: String
    var company: String
    var location: String
    var title: String
    var company_logo: StringLiteralType
}
