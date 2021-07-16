public enum APIError: Error {
    case generic
    case noData
    case urlUnknown
    case decoderError
}

public protocol APIRepository {
    func fetch<T:Decodable>(url: String, completion: @escaping (Result<T, APIError>) -> Void)
}
