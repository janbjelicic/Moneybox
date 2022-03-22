import RxSwift

protocol NetworkManagerProtocol {

    func request<T: Decodable>(request: NetworkRequest) -> Single<T>

}
