import RxSwift

protocol AuthorizationRepositoryProtocol {

    func login(_ request: LoginRequest) -> Single<LoginResponse>
    func getToken() -> String?

}
