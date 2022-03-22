import Foundation

class BundleClass {

    var bundle: Bundle {
        Bundle(for: type(of: self))
    }

}
