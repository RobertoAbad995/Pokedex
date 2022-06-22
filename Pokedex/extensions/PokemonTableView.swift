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
        
        //first register the custom cell pokeCell
        tableView.register(UINib(nibName: "pokeCell", bundle: nil), forCellReuseIdentifier: "pokeCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //start request for the first page
        getNextPage()
    }
    
    func getNextPage(){
        
        if  items.count >= 150{
            return
        }
        
        for i in index...(index + 29) {
            items.append(contentsOf: [Pokemon(id: (i + 1))])
        }
        index = items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
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
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view =  storyboard?.instantiateViewController(withIdentifier: "PokeDetailViewController") as! PokeDetailViewController
        view.Pokemon = items[indexPath.row]
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
}
