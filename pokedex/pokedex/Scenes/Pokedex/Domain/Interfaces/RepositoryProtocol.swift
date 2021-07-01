protocol Repository {
    func fetchPokemons(completion: @escaping (Result<[PokemonEntity], GetPokemonListError>) -> Void)
}
