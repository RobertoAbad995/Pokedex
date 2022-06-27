//
//  FavouritePokemon+CoreDataProperties.swift
//  Pokedex
//
//  Created by Consultant on 6/26/22.
//
//

import Foundation
import CoreData


extension FavouritePokemon {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavouritePokemon> {
        return NSFetchRequest<FavouritePokemon>(entityName: "FavouritePokemon")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var pokeDescription: String?
    @NSManaged public var pokeTypes: [String]?

}

extension FavouritePokemon : Identifiable {

}
