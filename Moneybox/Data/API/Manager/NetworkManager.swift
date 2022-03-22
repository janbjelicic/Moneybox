import Foundation
import RxCocoa
import RxSwift

class NetworkManager: NetworkManagerProtocol {

    private var urlSession: URLSession!
    private let disposeBag = DisposeBag()

    init() {
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.timeoutIntervalForResource = 30

        // Possible to customize a delegation queue where you can
        // for example define how many operations do you want to support
        // in a queue.
        urlSession = URLSession(configuration: urlSessionConfiguration)
    }

    deinit {
        urlSession.invalidateAndCancel()
        urlSession = nil
    }

    /// Simple implementation that can be used from multiple services and can provide different generic responses.
    /// Also we are expecting to receive json.
    func request<T: Decodable>(request: NetworkRequest) -> Single<T> {
        guard let urlRequest = request.urlRequest() else {
            let error = NetworkError.badRequest
            self.logError(request: request,
                          error: error)
            return Single.error(error)
        }
        return Single<T>.create { [weak self] singleEmmiter in
            guard let self = self else {
                return Disposables.create()
            }
            self.urlSession.rx.response(request: urlRequest)
                .subscribe(onNext: { response, data in
                    guard (200..<300).contains(response.statusCode) else {
                        let error = self.getError(response: response, data: data)
                        singleEmmiter(.failure(error))
                        return
                    }

                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        singleEmmiter(.success(response))

                        self.logSuccess(request: request,
                                         response: response)
                    } catch {
                        singleEmmiter(.failure(error))
                        self.logError(request: request,
                                      error: error)
                    }
                }, onError: { error in
                    singleEmmiter(.failure(error))
                    self.logError(request: request,
                                  error: error)
                })
                .disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }

    private func getError(response: HTTPURLResponse,
                          data: Data) -> NetworkError {
        if response.statusCode == StatusCode.unauthorized.rawValue {
            return .unauthorized
        } else {
            do {
                let response = try JSONDecoder().decode(ErrorInformation.self, from: data)
                return .descriptive(information: response)
            } catch {
                return .generic
            }
        }
    }

    private func logSuccess(request: NetworkRequest, response: Decodable) {
        print("Method: \(request.method)\n Path: \(request.path) \n Response: \(response)")
    }

    private func logError(request: NetworkRequest, error: Error) {
        print("Method: \(request.method)\n Path: \(request.path) \n Response: \(error)")
    }

}
