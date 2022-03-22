import Foundation
import Resolver

enum HttpVerb: String {

    case get = "GET"
    case post = "POST"

}

protocol NetworkRequest {

    var path: String { get }
    var method: HttpVerb { get }
    var parameters: [String: Any]? { get }
    var requiresAuthentication: Bool { get }

}

extension NetworkRequest {

    private var baseUrl: String {
        "https://api-test02.moneyboxapp.com/"
    }

    private var url: URL? {
        guard var urlComponents = URLComponents(string: baseUrl) else { return nil }
        urlComponents.path += path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }

    public func urlRequest() -> URLRequest? {
        guard let url = url else { return nil }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        // If headers are different for different requests this could be also added to the NetworkRequest protocol.
        urlRequest.allHTTPHeaderFields = ["AppId": "8cb2237d0679ca88db6464",
                                          "Content-Type": "application/json",
                                          "appVersion": "7.10.0",
                                          "apiVersion": "3.0.0"]

        let authorizationRepository = Resolver.resolve(AuthorizationRepositoryProtocol.self)
        if requiresAuthentication,
           let token = authorizationRepository.getToken() {
            urlRequest.setValue("Bearer \(token)",
                                forHTTPHeaderField: "Authorization")
        }

        urlRequest.httpBody = jsonBody
        return urlRequest
    }

    private var queryItems: [URLQueryItem]? {
        // Chek if it is a GET method.
        guard method == .get, let parameters = parameters else {
            return nil
        }
        // Convert parameters to query items.
        return parameters.map { (key: String, value: Any) -> URLQueryItem in
            let valueString = String(describing: value)
            return URLQueryItem(name: key, value: valueString)
        }
    }

    /// Returns the URLRequest body `Data`
    private var jsonBody: Data? {
        guard method == .post, let parameters = parameters else {
            return nil
        }

        // Convert parameters to JSON data
        var body: Data?
        do {
            body = try JSONSerialization.data(withJSONObject: parameters,
                                                  options: .prettyPrinted)
        } catch {
            print(error)
        }
        return body
    }

}
