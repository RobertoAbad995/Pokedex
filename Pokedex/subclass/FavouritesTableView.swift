//
//  FavouritesTableView.swift
//  Pokedex
//
//  Created by Consultant on 6/26/22.
//

import Foundation
import UIKit

class FavouritesListViewController: UITableViewController {
 
    @IBOutlet var favTable: UITableView!
    var index = 0
    let pokedexLimit = 151
    var items : [Pokemon] = []
    var favourites = [FavouritePokemon]()
    let database = DatabaseHandler()
    
    override func viewDidAppear(_ animated: Bool) {
        showFavourites()
    }
    
    override func viewDidLoad() {
        favTable.register(UINib(nibName: "pokeCell", bundle: nil), forCellReuseIdentifier: "pokeCell")
        favTable.delegate = self
        favTable.dataSource = self
        showFavourites()
    }
    
    func showFavourites(){
        print("favoritos")
        
        reloadFavorites()
        favTable.reloadData()
    }
    
    func reloadFavorites(){
        favourites = database.fetch(FavouritePokemon.self)
        items.removeAll()
        for i in favourites {
            items.append(contentsOf: [Pokemon(id: Int(i.id))])
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath) as! pokeCell
        let pokemonItem = items[indexPath.row]
        //if pokemon info request have made it, properties must be contain info
        //so if it doestn have, we look for it and save it
        if(pokemonItem.forms.count == 0 || pokemonItem.types.count == 0){
            cell.getPokemon(item: pokemonItem){ [weak self] result in
                switch result {
                case .success(let p):
                    //store the pokemon
                    self?.items[indexPath.row] = p
                    //asign at the cell
                    cell.pokemon = p
                    //show the info in the main thread
                    DispatchQueue.main.async {
                        cell.setPokemon()
                    }
                case .failure(let error):
                    print("We got some error at print cells: \(error)")
                }
            }
        }
        else{
            cell.pokemon = pokemonItem
            cell.setPokemon()
        }
        
        //add favourite button and select image button with FILL OR REGULAR STAR
        let button = ParamUIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        
        button.params["id"] = String(pokemonItem.id)
        
        button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        
        //AD TARGET FUNCTION
        button.addTarget(self, action: #selector(changeStar(sender:)), for: .touchUpInside)
//        button.tag = indexPath.row
        button.tag = pokemonItem.id
        cell.accessoryView = button
        return cell
    }
    
    @objc func changeStar(sender: ParamUIButton ){
        
        //get element from favourties
        if let pokemon = favourites.first(where: {$0.id == sender.tag}) {
           // remove from favourites
            self.database.delete(pokemon)
            self.database.save()
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            self.reloadFavorites()
            
            
        } else {
           // add to favourites
            let newFavourite = FavouritePokemon(context: database.viewContext)
            newFavourite.id = Int64(sender.tag)
            database.save()
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        reloadFavorites()
        favTable.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view =  storyboard?.instantiateViewController(withIdentifier: "PokeDetailViewController") as! PokeDetailViewController
        view.Pokemon = items[indexPath.row]
        view.favourite = UserDefaults.standard.favorites.contains(view.Pokemon.id) ? true: false
        self.navigationController?.show(view, sender: nil)
    }
    
}
