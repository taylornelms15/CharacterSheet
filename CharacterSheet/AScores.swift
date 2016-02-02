//
//  AScores.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 1/25/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation

class AScores : CustomStringConvertible{
    
    var ascores = [String: AScore]();//makes empty dictionary for the scores
    
    /*!
    *   @brief Initalizes a set of ability scores with the given values
    *   @param str strength value
    *   @param dex dexterity value
    *   @param con constitution value
    *   @param intl intellect value
    *   @param wis wisdom value
    *   @param cha charisma value
    */
    init(str: Int, dex: Int, con: Int, intl: Int, wis: Int, cha: Int){
        ascores["STR"] = AScore(score: str);
        ascores["DEX"] = AScore(score: dex);
        ascores["CON"] = AScore(score: con);
        ascores["INT"] = AScore(score: intl);
        ascores["WIS"] = AScore(score: wis);
        ascores["CHA"] = AScore(score: cha);
    }//init
    
    convenience init(){
        self.init(str: 9, dex: 9, con: 9, intl: 9, wis: 9, cha: 9);
    }//convenience init (no default values)
    
    //MARK: getters:score
    
    func getStr() -> Int{
        return (ascores["STR"]?.score)!;
    }//getStr
    
    func getDex() -> Int{
        return (ascores["DEX"]?.score)!;
    }//getDex
    
    func getCon() -> Int{
        return (ascores["CON"]?.score)!;
    }//getCon
    
    func getInt() -> Int{
        return (ascores["INT"]?.score)!;
    }//getInt
    
    func getWis() -> Int{
        return (ascores["WIS"]?.score)!;
    }//getWis
    
    func getCha() -> Int{
        return (ascores["CHA"]?.score)!;
    }//getCha
    
    //MARK: getters:mod
    
    func getStrMod() -> Int{
        return (ascores["STR"]?.modifier)!;
    }//getStrMod
    
    func getDexMod() -> Int{
        return (ascores["DEX"]?.modifier)!;
    }//getDexMod
    
    func getConMod() -> Int{
        return (ascores["CON"]?.modifier)!;
    }//getConMod
    
    func getIntMod() -> Int{
        return (ascores["INT"]?.modifier)!;
    }//getIntMod
    
    func getWisMod() -> Int{
        return (ascores["WIS"]?.modifier)!;
    }//getWisMod
    
    func getChaMod() -> Int{
        return (ascores["CHA"]?.modifier)!;
    }//getChaMod
    
    //MARK: setters:score
    
    func setStr(str: Int){
        ascores["STR"]?.score = str;
    }//setStr
    
    func setDex(dex: Int){
        ascores["DEX"]?.score = dex;
    }//setDex
    
    func setCon(con: Int){
        ascores["CON"]?.score = con;
    }//setCon
    
    func setInt(int: Int){
        ascores["INT"]?.score = int;
    }//setInt
    
    func setWis(wis: Int){
        ascores["WIS"]?.score = wis;
    }//setWis
    
    func setCha(cha: Int){
        ascores["CHA"]?.score = cha;
    }//setCha
    
    //MARK: modifiers:large format
    
    func addValues(strmod: Int, dexmod: Int, conmod: Int, intmod: Int, wismod: Int, chamod: Int){
        ascores["STR"]?.score += strmod;
        ascores["DEX"]?.score += dexmod;
        ascores["CON"]?.score += conmod;
        ascores["INT"]?.score += intmod;
        ascores["WIS"]?.score += wismod;
        ascores["CHA"]?.score += chamod;
    }//addValues
    
    func addScores(scores: AScores){
        self.addValues(scores.getStr(), dexmod: scores.getDex(), conmod: scores.getCon(), intmod: scores.getInt(), wismod: scores.getWis(), chamod: scores.getCha());
    }//addScores
    
    //MARK: toString
    
    var description: String{
        let str = ascores["STR"]!.score;
        let dex = ascores["DEX"]!.score;
        let con = ascores["CON"]!.score;
        let intl = ascores["INT"]!.score;
        let wis = ascores["WIS"]!.score;
        let cha = ascores["CHA"]!.score;
        return "Ability Scores\nStrength: \(str)\nDexterity: \(dex)\nConditioning: \(con)\nIntellect: \(intl)\nWisdom: \(wis)\nCharisma: \(cha)\n"
    }//description
    
}//AScores