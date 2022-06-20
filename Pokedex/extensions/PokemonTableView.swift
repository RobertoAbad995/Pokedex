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
        
        //start request with first page
        getNextPage()
    }
    
    func getNextPage(){
        
        for i in index...(index + 29){
            let pokemon = Pokemon(id: (i + 1))
            items.append(contentsOf: [pokemon])
        }
        
        index = items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pokeCell", for: indexPath) as! pokeCell
        items[indexPath.row] = cell.setPokemon(item: items[indexPath.row])
        return cell
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let vc = segue.destination as! PokeDetailViewController
//        vc.Pokemon = sender as! Pokemon
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let view =  storyboard?.instantiateViewController(withIdentifier: "PokeDetailViewController") as! PokeDetailViewController
        view.Pokemon = items[indexPath.row]
        self.navigationController?.show(view, sender: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if items.count <= 150{
            if tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height){
                //you reached end of the table
                getNextPage()
                tableView.reloadData()
            }
        }
    }
}
