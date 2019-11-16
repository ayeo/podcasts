import Foundation
import SWXMLHash

class Parser {
    func getMetadata(data: Data) {
        let xml = SWXMLHash.parse(data)
        print(xml)
    }
}
