//
//  SkillProfs.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 2/20/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import Foundation
import CoreData

class SkillProfs: NSManagedObject {

    @NSManaged var profList: Int32
    @NSManaged var pCharacter: PCharacter?
    @NSManaged var background: Background?
    
    static let athMask: Int32 = 0b00000000000000000000000000000001
    static let acrMask: Int32 = 0b00000000000000000000000000000010
    static let sleMask: Int32 = 0b00000000000000000000000000000100
    static let steMask: Int32 = 0b00000000000000000000000000001000
    static let arcMask: Int32 = 0b00000000000000000000000000010000
    static let hisMask: Int32 = 0b00000000000000000000000000100000
    static let invMask: Int32 = 0b00000000000000000000000001000000
    static let natMask: Int32 = 0b00000000000000000000000010000000
    static let relMask: Int32 = 0b00000000000000000000000100000000
    static let aniMask: Int32 = 0b00000000000000000000001000000000
    static let insMask: Int32 = 0b00000000000000000000010000000000
    static let medMask: Int32 = 0b00000000000000000000100000000000
    static let perMask: Int32 = 0b00000000000000000001000000000000
    static let surMask: Int32 = 0b00000000000000000010000000000000
    static let decMask: Int32 = 0b00000000000000000100000000000000
    static let intMask: Int32 = 0b00000000000000001000000000000000
    static let prfMask: Int32 = 0b00000000000000010000000000000000
    static let prsMask: Int32 = 0b00000000000000100000000000000000
    let descs = ["ath": SkillProfs.athMask, "acr": SkillProfs.acrMask, "sle": SkillProfs.sleMask,
                "ste": SkillProfs.sleMask, "arc": SkillProfs.arcMask, "his": SkillProfs.hisMask,
                "inv": SkillProfs.invMask, "nat": SkillProfs.natMask, "rel": SkillProfs.relMask,
                "ani": SkillProfs.aniMask, "ins": SkillProfs.insMask, "med": SkillProfs.medMask,
                "per": SkillProfs.perMask, "sur": SkillProfs.surMask, "dec": SkillProfs.decMask,
                "int": SkillProfs.intMask, "prf": SkillProfs.prfMask, "prs": SkillProfs.prsMask]

    /**
     Table relating the skills to their relevant ability scores. 
     The index is the index of the skill (overall).
     The value is a tuple indicating the indexPath for each skill: the first value is the section, the second is the row
     The section corresponds to an ability score. Notably, Constitution is missing.
     */
    static let SkillStatTable: [(Int, Int)] = [
        (0, 0),
        (1, 0),
        (1, 1),
        (1, 2),
        (2, 0),
        (2, 1),
        (2, 2),
        (2, 3),
        (2, 4),
        (3, 0),
        (3, 1),
        (3, 2),
        (3, 3),
        (3, 4),
        (4, 0),
        (4, 1),
        (4, 2),
        (4, 3)
    ]
    
    ///A table containing the long name of all the skills
    static let skillNameTable: [String] = [
        "Athletics", "Acrobatics", "Sleight of Hand", "Stealth", "Arcana", "History", "Investigation",
        "Nature", "Religion", "Animal Handling", "Insight", "Medicine", "Perception", "Survival", "Deception", "Intimidation", "Performance", "Persuasion"
    ]
    
    //MARK: Get proficiency booleans
    
    func getProf(atIndex index: Int)-> Bool{
        switch(index){
        case 0:
            return getAthProf()
        case 1:
            return getAcrProf()
        case 2:
            return getSleProf()
        case 3:
            return getSteProf()
        case 4:
            return getArcProf()
        case 5:
            return getHisProf()
        case 6:
            return getInvProf()
        case 7:
            return getNatProf()
        case 8:
            return getRelProf()
        case 9:
            return getAniProf()
        case 10:
            return getInsProf()
        case 11:
            return getMedProf()
        case 12:
            return getPerProf()
        case 13:
            return getSurProf()
        case 14:
            return getDecProf()
        case 15:
            return getIntProf()
        case 16:
            return getPrfProf()
        case 17:
            return getPrsProf()
        default:
            return false
        }//switch
    }//getProf
    
    func getAthProf()->Bool{
        return (profList&SkillProfs.athMask != 0)
    }
    
    func getAcrProf()->Bool{
        return (profList&SkillProfs.acrMask != 0)
    }
    
    func getSleProf()->Bool{
        return (profList&SkillProfs.sleMask != 0)
    }
    
    func getSteProf()->Bool{
        return (profList&SkillProfs.steMask != 0)
    }
    
    func getArcProf()->Bool{
        return (profList&SkillProfs.arcMask != 0)
    }
    
    func getHisProf()->Bool{
        return (profList&SkillProfs.hisMask != 0)
    }
    
    func getInvProf()->Bool{
        return (profList&SkillProfs.invMask != 0)
    }
    
    func getNatProf()->Bool{
        return (profList&SkillProfs.natMask != 0)
    }
    
    func getRelProf()->Bool{
        return (profList&SkillProfs.relMask != 0)
    }
    
    func getAniProf()->Bool{
        return (profList&SkillProfs.aniMask != 0)
    }
    
    func getInsProf()->Bool{
        return (profList&SkillProfs.insMask != 0)
    }
    
    func getMedProf()->Bool{
        return (profList&SkillProfs.medMask != 0)
    }
    
    func getPerProf()->Bool{
        return (profList&SkillProfs.perMask != 0)
    }
    
    func getSurProf()->Bool{
        return (profList&SkillProfs.surMask != 0)
    }
    
    func getDecProf()->Bool{
        return (profList&SkillProfs.decMask != 0)
    }
    
    func getIntProf()->Bool{
        return (profList&SkillProfs.intMask != 0)
    }
    
    func getPrfProf()->Bool{
        return (profList&SkillProfs.prfMask != 0)
    }
    
    func getPrsProf()->Bool{
        return (profList&SkillProfs.prsMask != 0)
    }
    
    //MARK: Setting Proficiency functions
    
    func toggleProficiency(atIndex: Int){
        
        let myMask: Int32 = SkillProfs.athMask << Int32(atIndex);
        
        profList = profList^myMask;
        
    }//toggleProficiency
    
    //MARK: SkillProfs arithmetic
    
    func subtractSkillProfs(secondProfs: SkillProfs){
        profList = profList & ~secondProfs.profList
    }//subtractSkillProfs
    
    func addSkillProfs(secondProfs: SkillProfs){
        profList = profList | secondProfs.profList
    }//addSkillProfs
    
    func shortDesc()->String{
        var results = "["
        for a in descs{
            if (profList & a.1 != 0){
                results.appendContentsOf(a.0)
                results.appendContentsOf(", ")
            }//if match
        }//descs
        results.append(Character("]"));
        return results
    }//shortDesc
}
