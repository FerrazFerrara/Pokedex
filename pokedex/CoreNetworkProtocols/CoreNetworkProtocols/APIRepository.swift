public enum APIError: Error {
    case generic
    case noData
}

public protocol APIRepository {
    func fetch<T:Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void)
}
