//
//  PokemonTableView.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//

import Foundation
import UIKit

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
//    var fav = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //first register the custom cell pokeCell
        tableView.register(UINib(nibName: "pokeCell", bundle: nil), forCellReuseIdentifier: "pokeCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        //Recover favorites
        var favorites = [Int]()
        if let fav = UserDefaults.standard.array(forKey: "favorites") as? [Int] {
            favorites = fav
        }
        self.fav = favorites
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
        
        
        //add favorite button
        //add favourite button and select image button with FILL OR REGULAR STAR
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        
        
        button.setImage(UIImage(systemName: (fav.contains(indexPath.row) ? "star.fill" : "star")), for: .normal)
        
//        if fav.contains(indexPath.row)
//        {
//            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
//        }
//        else
//        {
//            button.setImage(UIImage(systemName: "star"), for: .normal)
//        }
        
        //AD TARGET FUNCTION
        button.addTarget(self, action: #selector(changeStar(sender:)), for: .touchUpInside)
        button.tag = indexPath.row
        cell.accessoryView = button
        
        
        
        return cell
    }
    
    @objc func changeStar(sender: UIButton ){
        let buttonTag = sender.tag
        
        if sender.currentImage!.isEqual(UIImage(systemName: "star")) {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
            
            UserDefaults.standard.favorites.append(buttonTag)
        
        }else{
            sender.setImage(UIImage(systemName: "star"), for: .normal)
            
            if let num = UserDefaults.standard.favorites.firstIndex(of: buttonTag){
                UserDefaults.standard.favorites.remove(at: num)
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view =  storyboard?.instantiateViewController(withIdentifier: "PokeDetailViewController") as! PokeDetailViewController
        view.Pokemon = items[indexPath.row]
        
        let fav = fav.contains(indexPath.row)
        
        view.favourite = fav
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
