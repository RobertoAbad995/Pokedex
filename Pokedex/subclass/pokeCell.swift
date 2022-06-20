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
    
    func setPokemon(item: Pokemon) -> Pokemon! {
        pokemon = item
        lblName.text = "pokemon \(pokemon!.id)"
        imgView.downloaded(from: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon.id).png")
        
        
        if pokemon.forms.count == 0
        {
            PokemonAPI().getById(id: pokemon.id){ [weak self] result in
                
                switch result {
                case .success(let p):
                    self?.pokemon = p
                    DispatchQueue.main.async {
    //                    self?.tableview.reloadData()
                        self?.lblName.text = p.forms[0].name
                        self?.lblInfo.text = p.types[0].type.name
    //                    self?.lblInfo.text = p.forms[0].url
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        return self.pokemon
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        
//        let view =  storyboard.instantiateViewController(withIdentifier: "pokeDetail") as! pokeDetail
//        view.C = items[indexPath.row]
//        self.navigationController?.show(view, sender: nil)
//    }
    
    
    
    
}
