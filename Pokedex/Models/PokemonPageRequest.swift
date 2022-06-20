//
//  PokemonPageRequest.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//

import Foundation


struct PokemonPageRequest: Codable {
    
    let count: Int
    let next: String
    let results: [PokedexItem]
    
}
