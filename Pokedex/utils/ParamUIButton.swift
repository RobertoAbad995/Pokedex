//
//  ParamUIButton.swift
//  Pokedex
//
//  Created by Consultant on 6/26/22.
//
import UIKit
import Foundation

class ParamUIButton: UIButton{
    var params: Dictionary<String, String>
    
    override init(frame: CGRect) {
        self.params = [:]
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        self.params = [:]
        super.init(coder: aDecoder)
    }
}
