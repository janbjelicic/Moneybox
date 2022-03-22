import RxSwift

protocol AuthorizationServiceProtocol {

    func login(_ request: LoginRequest) -> Single<LoginResponse>

}
