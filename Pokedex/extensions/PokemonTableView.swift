//
//  PokemonTableView.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        reloadFavorites()
        getNextPage()
    }
    
    func setupTable(){
        //first register the custom cell pokeCell
        tableView.register(UINib(nibName: "pokeCell", bundle: nil), forCellReuseIdentifier: "pokeCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func reloadFavorites(){
        favourites = database.fetch(FavouritePokemon.self)
    }
    
    func getNextPage(){
        if  items.count >= 150{ return }
        for i in index...(index + 29) { items.append(contentsOf: [Pokemon(id: (i + 1))])}
        index = items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return items.count }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
//        button.params["name"] = pokemonItem.forms[0].name
//        button.params["desc"] = cell.lblInfo.text
        
//        if let pokemon = favourites.first(where: {$0.id == pokemonItem.id}) {
        if isFavourite(id: pokemonItem.id){
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
        else{
            button.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
//        button.setImage(UIImage(systemName: (favourites.contains(indexPath.row) ? "star.fill" : "star")), for: .normal)
        //AD TARGET FUNCTION
        button.addTarget(self, action: #selector(changeStar(sender:)), for: .touchUpInside)
//        button.tag = indexPath.row
        button.tag = pokemonItem.id
        cell.accessoryView = button
        return cell
    }
    
    func isFavourite(id: Int) -> Bool {
        if favourites.first(where: {$0.id == id}) != nil{
            return true
        }
        else{
            return false
        }
                                   
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
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view =  storyboard?.instantiateViewController(withIdentifier: "PokeDetailViewController") as! PokeDetailViewController
        view.Pokemon = items[indexPath.row]
        view.favourite = UserDefaults.standard.favorites.contains(view.Pokemon.id) ? true: false
        self.navigationController?.show(view, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //infinite scroll
        //if list has not fill with the first 150 AND
        //if the user has scrolled to the bottom of the list
        if index < pokedexLimit && tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height + 50){
            //you reached end of the table
            getNextPage()
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action,view, completionHandler) in
            
            let index = (indexPath.row + 1)
            let pokeDeleting = self.favourites.first(where: {$0.id == index})
            
            self.database.delete(pokeDeleting!)
            self.database.save()
            self.reloadFavorites()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
