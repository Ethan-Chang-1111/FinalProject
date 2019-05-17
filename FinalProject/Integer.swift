//
//  Integer.swift
//  FinalProject
//
//  Created by Ethan Chang on 5/17/19.
//  Copyright © 2019 SomeAweApps. All rights reserved.
//

import UIKit

class Integer: Codable {
    var integer = Int();
    
    init(imput:Int) {
        integer = imput
    }
    func getInt() -> Int{
        return integer
    }
    func setInt(imput:Int){
        integer = imput
        
    }
}
