//
//  PokeDetailViewController.swift
//  Pokedex
//
//  Created by Consultant on 6/20/22.
//

import UIKit

class PokeDetailViewController: UIViewController {

    
    var Pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Pokemon.forms[0].name)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
