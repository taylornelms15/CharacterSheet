//
//  AScore.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
struct AScore{
    var score: Int = 0;
    var modifier: Int{
    get{
        return (score / 2) - 5;
    }//get
    }//modifier

    init(score: Int){
        self.score = score;
        return;
    }//init
    
}//AScore