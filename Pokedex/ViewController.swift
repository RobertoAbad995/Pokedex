//
//  ViewController.swift
//  Pokedex
//
//  Created by Consultant on 6/17/22.
//
import UIKit

//FRON CLASS CLEAR, ONLY OUTLETS
class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var index = 0
    let pokedexLimit = 151
    var items : [Pokemon] = []
    var favourites = [FavouritePokemon]()
    let database = DatabaseHandler()
}

