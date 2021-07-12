public protocol ViewConfiguration {
    func buildHierarchy()
    func addConstraints()
    func additionalConfigurations()
    func setupScene()
}

public extension ViewConfiguration {
    func additionalConfigurations() {}

    func setupScene() {
        buildHierarchy()
        addConstraints()
        additionalConfigurations()
    }
}
