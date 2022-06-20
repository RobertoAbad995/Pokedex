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
    
    

//    func getPokemonPage(pagination: Bool = false, startIndex: Int = 0, limit: Int = 30,  completion: @escaping (Result<[Pokemon],Error>)->()){
//        URLSession.shared.getRequest(url: URL(string: ""), decoding: [Pokemon].self, completion: completion)
//        /*
//        var data = PokemonPageRequest(count: 0, next: "", results: [])
//
//        URLSession.shared.getRequest(
//            url: URL(string: self.baseUrl + "pokemon/?offset=\(startIndex)&limit=\(limit)"),
//            decoding: PokemonPageRequest.self)
//        { result in
//
//            switch result {
//            case .success(let user):
//                data = user
//            case .failure(let error):
//                print(error)
//            }
//        }*/
//    }
}
