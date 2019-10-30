//
//  File.swift
//  
//
//  Created by 李其炜 on 10/29/19.
//

import Foundation

public struct MarkdownNode : Identifiable{
    var id: ObjectIdentifier = UUID()
    var type: MarkdownType
    var content: String
    var link: String?
}
