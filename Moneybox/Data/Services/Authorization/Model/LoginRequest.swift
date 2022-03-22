import Foundation

struct LoginRequest: Encodable {

    let email: String
    let password: String
    let idfa: String = "ANYTHING"

    enum CodingKeys: String, CodingKey {
        case email = "Email"
        case password = "Password"
        case idfa = "Idfa"
    }

}

extension LoginRequest: NetworkRequest {

    var path: String {
        "users/login"
    }

    var method: HttpVerb {
        .post
    }

    var parameters: [String: Any]? {
        ["Email": email,
         "Password": password,
         "Idfa": idfa]
    }

    var requiresAuthentication: Bool {
        false
    }

}
