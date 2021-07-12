// MARK: - Protocol Modules
import CoreNetworkProtocols

// MARK: - Contrete Modules
import CoreNetwork

struct Injector {
    func make() -> APIRepository {
        API()
    }
}
