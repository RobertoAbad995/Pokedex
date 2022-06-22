//
//  PokemonAPI.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//

import Foundation

final class PokemonAPI{
    
    private var semaphore = DispatchSemaphore(value: 0)
    private var baseUrl = "https://pokeapi.co/api/v2/"
    
    func getById(id: Int, completion: @escaping (Result<Pokemon,Error>)->()){
        URLSession.shared.getRequest(url: URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)/"), decoding: Pokemon.self, completion: completion)
    }
}
