//
//  Pokemon.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//

import Foundation

struct Pokemon: Codable {
    
    //codeable properties
    var id: Int
    var forms: [Forms]
    var types: [PokeType]
    
    init(id:Int){
        self.id = id
        forms = [Forms]()
        types = [PokeType]()
    }
}
struct PokeType: Codable{
//    var slot:Int
    var type: Forms
}
struct Forms: Codable{
    var name: String
    var url: String
}

