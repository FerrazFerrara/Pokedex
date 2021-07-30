public enum APIError: Error {
    case generic
    case noData
    case urlUnknown
    case decoderError
}

public protocol APIRepository {
    func fetch<T:Decodable>(endpoint: String, completion: @escaping (Result<T, APIError>) -> Void)
}
