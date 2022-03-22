@testable import Moneybox

import Foundation
import RxSwift

class FakeNetworkManager: NetworkManagerProtocol {

    private (set) var responseJSON: String?
    private (set) var error: Error?

    private (set) var method: HttpVerb?
    private (set) var path: String?
    private (set) var parameters: [String: Any]?
    private (set) var requiresAuthentication: Bool

    init(responseJSON: String? = nil,
         error: Error? = nil) {
        self.responseJSON = responseJSON
        self.error = error
        requiresAuthentication = true
    }

    func request<T: Decodable>(request: NetworkRequest) -> Single<T> {
        method = request.method
        path = request.path
        parameters = request.parameters
        requiresAuthentication = request.requiresAuthentication

        if let error = error {
            return .error(error)
        } else if let responseJSON = responseJSON {
            do {
                let response = try JSONDecoder().decode(T.self, from: responseJSON.data(using: .utf8) ?? Data())
                return .just(response)
            } catch {
                return .error(NetworkError.generic)
            }
        } else {
            return .error(NetworkError.generic)
        }
    }

}
