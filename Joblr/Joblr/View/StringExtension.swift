//
//  StringExtension.swift
//  Joblr
//
//  Created by 王锴文 on 11/5/19.
//  Copyright © 2019 Bear. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func urlEncoded() -> String {
        let encodeUrlString = self.addingPercentEncoding(withAllowedCharacters:
            .letters)
        return encodeUrlString ?? ""
    }
    func urlDecoded() -> String {
        return self.removingPercentEncoding ?? ""
    }
}

func stringParser(source: String) -> String {
    let array = source.components(separatedBy: " ")
    var ans: String = ""
    for str in array {
        ans += str.urlEncoded() + "+"
    }
    ans.popLast()
    return ans
}
