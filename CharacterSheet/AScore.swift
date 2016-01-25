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
        if (score < 1) {self.score = 1;}
        else if (score > 30) {self.score = 30;}
        else {self.score = score;}
        return;
    }//init
    
}//AScore