protocol ViewConfiguration {
    func buildHierarchy()
    func addConstraints()
    func additionalConfigurations()
    func setupScene()
}

extension ViewConfiguration {
    func additionalConfigurations() {}

    func setupScene() {
        buildHierarchy()
        addConstraints()
        additionalConfigurations()
    }
}
