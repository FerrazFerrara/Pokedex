import Foundation
import CoreNetworkProtocols

public protocol NetworkSession {
    func loadData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

extension URLSession: NetworkSession {
    public func loadData(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = dataTask(with: url) { data, urlResponse, error in
            completion(data, urlResponse, error)
        }
        dataTask.resume()
    }
}

public final class API {
    let networkSession: NetworkSession

    public init(networkSession: NetworkSession = URLSession.shared) {
        self.networkSession = networkSession
    }
}

extension API: APIRepository {
    public func fetch<T:Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(.urlUnknown))
            return
        }

        networkSession.loadData(url: url) { data, response, error in
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
    }
}
