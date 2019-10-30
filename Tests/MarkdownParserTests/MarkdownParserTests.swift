import XCTest
@testable import MarkdownParser

class MarkdownParsingTests: XCTestCase {
    func testHeaderParsing(){
        let markdown = "# This is the header\n"
        let parser = Parser(markdown: markdown)
        let nodes = parser.parseMarkdown()
        XCTAssertEqual(nodes.count, 1)
        XCTAssertEqual(nodes[0].type, MarkdownType.header)
        XCTAssertEqual(nodes[0].content, "This is the header")
    }
    
    func testImageParsing() {
        let markdown = "![](link)\n"
        let parser = Parser(markdown: markdown)
        let nodes = parser.parseMarkdown()
        XCTAssertEqual(nodes.count, 1)
        XCTAssertEqual(nodes[0].type, MarkdownType.image)
        XCTAssertEqual(nodes[0].content, "")
        XCTAssertEqual(nodes[0].link, "link")
    }
    
    func testParseHeaderAndLink() {
        let markdown = "# Header\n![](link)\nsome content"
        let parser = Parser(markdown: markdown)
        let nodes = parser.parseMarkdown()
        XCTAssertEqual(nodes.count, 3)
        XCTAssertEqual(nodes[0].type, MarkdownType.header)
        XCTAssertEqual(nodes[0].content, "Header")
        XCTAssertEqual(nodes[0].link, nil)
        XCTAssertEqual(nodes[1].type, MarkdownType.image)
        XCTAssertEqual(nodes[1].link, "link")
        XCTAssertEqual(nodes[2].type, MarkdownType.text)
        XCTAssertEqual(nodes[2].content, "some content")
    }
    
    func testInlineLink(){
        let markdown = "content with inline [link](some link)\n"
         let parser = Parser(markdown: markdown)
         let nodes = parser.parseMarkdown()
         XCTAssertEqual(nodes.count, 1)
         XCTAssertEqual(nodes[0].type, MarkdownType.text)
         XCTAssertEqual(nodes[0].content, "content with inline link")
         XCTAssertEqual(nodes[0].link, nil)
        
    }
    
}
