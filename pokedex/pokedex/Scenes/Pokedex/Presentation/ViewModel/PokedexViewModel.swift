protocol PokedexViewModeling {
    func numberOfItemsInSection() -> Int
    func cellForItemAt()
    func didSelectCellAt(_ index: Int)
}

final class PokedexViewModel {
    
}

extension PokedexViewModel: PokedexViewModeling {
    func numberOfItemsInSection() -> Int {
        5
    }
    
    func cellForItemAt() {

    }

    func didSelectCellAt(_ index: Int) {

    }
}
