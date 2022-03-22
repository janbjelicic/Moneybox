import Foundation

class TestUtilities {

    static func loadTextFile(_ file: String) -> String? {
        if let filePath = BundleClass().bundle.path(forResource: file, ofType: nil) {
            return try? String.init(contentsOfFile: filePath)
        }
        return nil
    }

}
