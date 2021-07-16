import Foundation
import CoreNetworkProtocols

public final class API {
    public init() {}

    func createURLRequest(url: String) -> URLRequest? {
        guard let url = URL(string: url) else {
            return nil
        }

        return  URLRequest(url: url)
    }
}

extension API: APIRepository {
    public func fetch<T:Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let urlRequest = createURLRequest(url: url) else {
            completion(.failure(.urlUnknown))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { (data, _, _)  in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }

            guard let value = try? JSONDecoder().decode(T.self, from: data) else {
                completion(.failure(.decoderError))
                return
            }

            completion(.success(value))
        }
        task.resume()
    }
}
