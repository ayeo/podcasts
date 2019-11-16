import Foundation
import SWXMLHash

class Parser {
    func getMetadata(data: Data) -> (title: String?, image: String?) {
        let xml = SWXMLHash.parse(data)
        return (
            xml["rss"]["channel"]["title"].element?.text,
            xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text
        )
    }
}
