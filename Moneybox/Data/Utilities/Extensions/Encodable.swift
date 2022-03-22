import Foundation

extension Encodable {

    var jsonObject: [String: String]? {
        try? JSONEncoder().encodeJSONObject(self) as? [String: String]
    }

}
