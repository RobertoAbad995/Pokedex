//
//  pokeCell.swift
//  Pokedex
//
//  Created by Consultant on 6/19/22.
//

import UIKit

class pokeCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    var pokemon : Pokemon!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func getPokemon(item: Pokemon,completion: @escaping (Result<Pokemon,Error>)->()){
        imgView.downloaded(from: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(item.id).png")
        PokemonAPI().getById(id: item.id,completion: completion)
    }
    
    func setPokemon(){
        lblName.text = pokemon.forms[0].name.uppercased()
        lblInfo.text = pokemon.types[0].type.name
        imgView.downloaded(from: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")
    }
}
