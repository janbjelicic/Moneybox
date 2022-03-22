import Foundation

enum NetworkError: Error {

    case generic
    case descriptive(information: ErrorInformation)
    case badRequest
    case unauthorized

}
