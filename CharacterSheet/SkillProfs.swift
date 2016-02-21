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
    
    let athMask: Int32 = 0b00000000000000000000000000000001
    let acrMask: Int32 = 0b00000000000000000000000000000010
    let sleMask: Int32 = 0b00000000000000000000000000000100
    let steMask: Int32 = 0b00000000000000000000000000001000
    let arcMask: Int32 = 0b00000000000000000000000000010000
    let hisMask: Int32 = 0b00000000000000000000000000100000
    let invMask: Int32 = 0b00000000000000000000000001000000
    let natMask: Int32 = 0b00000000000000000000000010000000
    let relMask: Int32 = 0b00000000000000000000000100000000
    let aniMask: Int32 = 0b00000000000000000000001000000000
    let insMask: Int32 = 0b00000000000000000000010000000000
    let medMask: Int32 = 0b00000000000000000000100000000000
    let perMask: Int32 = 0b00000000000000000001000000000000
    let surMask: Int32 = 0b00000000000000000010000000000000
    let decMask: Int32 = 0b00000000000000000100000000000000
    let intMask: Int32 = 0b00000000000000001000000000000000
    let prfMask: Int32 = 0b00000000000000010000000000000000
    let prsMask: Int32 = 0b00000000000000100000000000000000

    
    //MARK: Get proficiency booleans
    
    func getAthProf()->Bool{
        return (profList&athMask != 0)
    }
    
    func getAcrProf()->Bool{
        return (profList&acrMask != 0)
    }
    
    func getSleProf()->Bool{
        return (profList&sleMask != 0)
    }
    
    func getSteProf()->Bool{
        return (profList&steMask != 0)
    }
    
    func getArcProf()->Bool{
        return (profList&arcMask != 0)
    }
    
    func getHisProf()->Bool{
        return (profList&hisMask != 0)
    }
    
    func getInvProf()->Bool{
        return (profList&invMask != 0)
    }
    
    func getNatProf()->Bool{
        return (profList&natMask != 0)
    }
    
    func getRelProf()->Bool{
        return (profList&relMask != 0)
    }
    
    func getAniProf()->Bool{
        return (profList&aniMask != 0)
    }
    
    func getInsProf()->Bool{
        return (profList&insMask != 0)
    }
    
    func getMedProf()->Bool{
        return (profList&medMask != 0)
    }
    
    func getPerProf()->Bool{
        return (profList&perMask != 0)
    }
    
    func getSurProf()->Bool{
        return (profList&surMask != 0)
    }
    
    func getDecProf()->Bool{
        return (profList&decMask != 0)
    }
    
    func getIntProf()->Bool{
        return (profList&intMask != 0)
    }
    
    func getPrfProf()->Bool{
        return (profList&prfMask != 0)
    }
    
    func getPrsProf()->Bool{
        return (profList&prsMask != 0)
    }
    
}
