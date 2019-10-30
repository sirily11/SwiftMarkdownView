//
//  MarkdownParser.swift
//  NewsFeedUIKit
//
//  Created by 李其炜 on 10/29/19.
//  Copyright © 2019 李其炜. All rights reserved.
//

import Foundation


public class MarkdownParser{
    private var makrdown: String
    
    /**
     Parse header including tag
     */
    let headerPattern = #"(#+)(.*)"#
    /**
     Use this to match header tag, eg. #, ##, ###
     */
    let headerTagPattern = #"(#+) "#
    /**
     Match any image. Use this before link
     */
    let imagePattern = #"!\[(.*)\]\(([^)]+)\)"#
    /**
     Match any link
     */
    let linkPattern = #"\[([^\[\]]+)\]\(([^)]+)\)"#
    /**
     Match link's link
     */
    let linkLinkPattern = #"\(([^)]+)\)"#
    /**
     Link tag
     */
    let linkTagPattern = #"\[(.*)\]"#
    
    
    init(markdown: String) {
        self.makrdown = markdown
    }
    
    /**
     Parse markdown into markdown nodes
     */
    func parseMarkdown() -> [MarkdownNode]{
        var nodes: [MarkdownNode] = []
        
        
        for line in self.makrdown.components(separatedBy: .newlines) {
            if line.count == 0{
                continue
            }
            nodes.append(parse(line))
        }
        return nodes
    }
    
    
    private func parse(_ markdownStr: String) -> MarkdownNode{
        let headerRegex = try! NSRegularExpression(pattern: headerPattern)
        let imageRegex = try! NSRegularExpression(pattern: imagePattern)
        
        let header = headerRegex.firstMatch(in: markdownStr, range: NSRange(markdownStr.startIndex..., in: markdownStr)).map{
            String(markdownStr[Range($0.range, in: markdownStr)!])
        }
         
        let image = imageRegex.firstMatch(in: markdownStr, range: NSRange(markdownStr.startIndex..., in: markdownStr)).map{
                   String(markdownStr[Range($0.range, in: markdownStr)!])
        }
        
        // If the header
        if let header = header{
            return parseHeader(header)
        }
        
        if let image = image{
            return parseImage(image)
        }
        
        let contentStr = parseLink(markdownStr)
        
        return MarkdownNode(type: .text, content: contentStr)
        
    }
    
    
    /**
     Parse  header
     */
    private func parseHeader(_ headerMarkdown: String) -> MarkdownNode{
        let headerRange = headerMarkdown.range(of: self.headerTagPattern, options: .regularExpression)
        let content = headerMarkdown.replacingCharacters(in: headerRange!, with: "")
        return MarkdownNode(type: .header, content: content)
    }
    
    /**
     Parse Image
     */
    private func parseImage(_ imageMarkdown: String) -> MarkdownNode{
        let linkRegex = try! NSRegularExpression(pattern: self.linkLinkPattern)
        let link = linkRegex.firstMatch(in: imageMarkdown, range: NSRange(imageMarkdown.startIndex..., in: imageMarkdown)).map{
               String(imageMarkdown[Range($0.range, in: imageMarkdown)!])
            }
        if let link = link{
            let linkStr = link[1..<link.count - 1]
            return MarkdownNode(type: .image, content: "", link: linkStr)
            
        }
        return MarkdownNode(type: .image, content: "")
        
    }
    
    private func parseContent(_ contentMarkdown: String) -> MarkdownNode{
        return MarkdownNode(type: .text, content: contentMarkdown)
    }
    
    /**
     Replace any link markdown to its content.
     [abc](link) -> abc
     */
    private func parseLink(_ markdown: String) -> String{
        let linkTagRex = try! NSRegularExpression(pattern: linkTagPattern)
        let linkRegex = try! NSRegularExpression(pattern: linkPattern)
        let linkRange = linkRegex.firstMatch(in: markdown, range: NSRange(markdown.startIndex..., in: markdown))?.range
        let linkTextRange = linkTagRex.firstMatch(in: markdown, range: NSRange(markdown.startIndex..., in: markdown))?.range
        if let linkTextRange = linkTextRange{
            let newstr = String(markdown[Range(linkTextRange, in: markdown)!])
                 let linkText = newstr[1..<newstr.count - 1]
                 let newsText = markdown.replacingCharacters(in: Range(linkRange!, in: markdown)!, with: linkText)
                 return newsText
        }
        return markdown
    }
    
    
    
}
