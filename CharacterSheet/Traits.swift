//
//  Traits.swift
//  CharacterSheet
//
//  Created by Taylor Nelms on 3/13/16.
//  Copyright © 2016 Taylor. All rights reserved.
//

import CoreData

class Trait: NSManagedObject{
    
    @NSManaged var id: Int64
    @NSManaged var name: String?
    @NSManaged var details: String?
    @NSManaged var canon: Bool
    @NSManaged var category: Int16
    @NSManaged var inv_traitList: NSSet?
    
    //MARK: Category getters
    func isPersTrait()->Bool{
        return (category == 1)
    }
    func isIdeal()->Bool{
        return (category == 2)
    }
    func isBond()->Bool{
        return (category == 3)
    }
    func isFlaw()->Bool{
        return (category == 4)
    }
    
    /**
     Handles setting id and such for the custom trait
     - Parameter context The context into which to put the trait
    */
    func addToCoreData(intoContext context: NSManagedObjectContext){
        
        let fetchRequest = NSFetchRequest(entityName: "Trait")
        fetchRequest.predicate = NSPredicate(format: "id > 1000", argumentArray: nil)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [Trait] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Trait]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//catch
        //results now contains all traits above id 1000 (so, all the non-canon ones), in ascending order
        
        if (results.count == 0){
            id = Int64(1001)
        }//if this is first canon entry
        else{
            var newId: Int64 = results[results.count - 1].id
            newId += 1
            id = newId
        }//there are other non-canon traits
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//addToCoreData
    
    /**
    Intelligently removes trait from core data, updating id values
    - Parameter context the context from which to pull the trait
    */
    func removeFromCoreData(fromContext context: NSManagedObjectContext){
        
        let predicateFormatString = "id > \(id)"
        var error: NSError? = nil
        
        let fetchRequest = NSFetchRequest(entityName: "Trait")
        fetchRequest.predicate = NSPredicate(format: predicateFormatString)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        let count = context.countForFetchRequest(fetchRequest, error: &error)
        
        if (count != 0){
            var results: [Trait] = [];
            do{
                results = try context.executeFetchRequest(fetchRequest) as! [Trait]
            }catch let error as NSError{
                print("Could not save \(error), \(error.userInfo)")
            }//catch
            //results now contains all traits above this one's id
            
            for trait in results{
                trait.id = trait.id - 1
            }//for all traits in results
            
        }//if there are any higher-numbered traits

        
        context.deleteObject(self) //just like suicide!
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//removeFromCoreData
    
    /**
    Helper to get the category number for a specific trait category
    * Personality Trait 1: 1
    * Personality Trait 2: 1
    * Ideal: 2
    * Bond: 3
    * Flaw: 4
    - Parameter name: the name of the category
    - Returns: Int16 value representing the category number of the trait
    */
    static func getCategoryNumFromName(name: String)->Int16{
        
        switch (name){
            case "Personality Trait 1":
            return Int16(1)
            case "Personality Trait 2":
            return Int16(1)
            case "Ideal":
            return Int16(2)
            case "Bond":
            return Int16(3)
            case "Flaw":
            return Int16(4)
        default:
            return Int16(0)
        }
        
    }//getCategoryNumFromName
    
}//Trait

class TraitList: NSManagedObject{
    
    @NSManaged var traits: Set<Trait>
    
    //MARK: character set trait methods
    
    func setPersTrait(newTrait: Trait, replaceTrait: Trait?)->Bool{
        if (replaceTrait != nil){
            if(traits.remove(replaceTrait!) == nil){
                traits.insert(newTrait)
                return false
            }//if old trait not found
            else{
                traits.insert(newTrait)
                return true
            }//if successful replace
        }//if replacing
        else{
            traits.insert(newTrait)
            return true
        }//else not replacing
    }//setPersTrait
    func setIdeal(newIdeal: Trait){
        for i in traits{
            if (i.category == 2){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newIdeal)
        return
    }//setIdeal
    func setBond(newBond: Trait){
        for i in traits{
            if (i.category == 3){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newBond)
        return
    }//setBond
    func setFlaw(newFlaw: Trait){
        for i in traits{
            if (i.category == 4){
                traits.remove(i)
            }//if
        }//for
        traits.insert(newFlaw)
        return
    }//setFlaw
    
    static func traitsInit(context: NSManagedObjectContext){
        
        let traitsData: [[[String]]] = [
            [//Acolyte
                ["Hero-Worshipper", "I idolize a particular hero of my faith and constantly refer to that person's deeds and example."],
                ["Diplomat", "I can find common ground between the fiercest enemies, empathizing with them and always working toward peace."],
                ["Omen-Seer", "I see omens in every event and action. The gods try to speak to us; we just need to listen."],
                ["Optimistic", "Nothing can shake my optimistic attitude."],
                ["Quote-Heavy", "I quote (or misquote) sacred texts and proverbs in almost every situation."],
                ["(In)Tolerant", "I am tolerant (or intolerant) of other faiths and respect (or condemn) the worship of other gods."],
                ["Pampered", "I've enjoyed fine food, drink, and high society among my temple's elite. Rough living grates on me."],
                ["Isolated", "I've spent so long in the temple that I have little practical experience dealing with people in the outside world."],
                ["Tradition", "The ancient traditions of worship and sacrifice must be preserved and upheld."],
                ["Charity", "I always try to help those in need, no matter what the personal cost."],
                ["Change", "We must help bring about the changes the gods are constantly working in the world."],
                ["Power", "I hope to one day rise to the top of my faith's religious hierarchy."],
                ["Faith", "I trust that my deity will guide my actions. I have faith that if I work hard, things will go well."],
                ["Aspiration", "I seek to prove myself worthy of my god's favor by matching my actions against his or her teachings."],
                ["Relic", "I would die to recover an ancient relic of my faith that was lost long ago."],
                ["Revenge", "I will someday get revenge on the corrupt temple hierarchy who branded me a heretic."],
                ["Orphan", "I owe my life to the priest who took me in when my parents died."],
                ["Common Folk", "Everything I do is for the common people."],
                ["Temple", "I will do anything to protect the temple where I served."],
                ["Sacred Text", "I seek to preserve a sacred text that my enemies consider heretical and seek to destroy."],
                ["Judgemental", "I judge others harshly, and myself even more severely."],
                ["Trusting of Elders", "I put too much trust in those who wield power within my temple's hierarchy."],
                ["Trusting of Faithful", "My piety sometimes leads me to blindly trust those that profess faith in my god."],
                ["Inflexible", "I am inflecible in my thinking."],
                ["Suspicious", "I am suspicious of strangers and suspect the worst of them."],
                ["Obsessed", "Once I pick a goal, I become obsessed with it to the detriment of everything else in my life."]
            ],
            [//Charlatan
                ["Lover", "I fall in and out of love easiler, and am always pursuing someone."],
                ["Joker", "I have a joke for every occasion, especially occasions where humor is inappropriate."],
                ["Flatterer", "Flattery is my preferred trick for getting what I want."],
                ["Gambler", "I'm a born gambler who can't resist taking a risk for a potential payoff."],
                ["Liar", "I lie about almost everything, even when there's no good reason to."],
                ["Sarcastic", "Sarcasm and insults are my weapon of choice."],
                ["Fake Faith", "I keep multiple holy symbols on me and involve whatever deity might come in useful at any given moment."],
                ["Scavenger", "I pocket anything I see that might have some value."],
                ["Independence", "I am a free spirit - no one tells me what to do."],
                ["Fairness", "I never target people who can't afford to lose a few coins."],
                ["Charity", "I distribute the money I acquire to the people who really need it."],
                ["Creativity", "I never run the same con twice"],
                ["Friendship", "Material goods come and go. Bonds of friendship last forever."],
                ["Aspiration", "I'm determined to make something of myself"],
                ["Bad Target", "I fleeced the wrong person and must work to ensure that this individual never crosses paths with me or those I care about."],
                ["Mentor Debt", "I owe everything to my mentor - a horrible person who's probably rotting in jail somewhere."],
                ["Faraway Child", "Somewhere out there, I have a child who doesn't know me. I'm making the world better for them."],
                ["Noble's Revenge", "I come from a noble family, and one day I'll reclaim my lands and title from those who stole them from me."],
                ["Lover's Revenge", "A powerful person killed someone I love. Some day soon, I'll have my revenge."],
                ["Regret", "I swindled and ruined a person who didn't deserve it. I seek to atone for my misdeeds, but might never be able to forgive myself."],
                ["Easily Charmed", "I can't resist a pretty face."],
                ["Debt", "I'm always in debt. I spend my ill-gotted gains on decadent luxuries faster than I bring them in."],
                ["Pride", "I'm convinced that no one could ever fool me the way I fool others."],
                ["Greed", "I'm too greedy for my own good. I can't resist taking a risk if there's money involved."],
                ["Fight the Power", "I can't resist swindling people who are more powerful than I am."],
                ["Coward", "I hate to admit it and will hate myself for it, but I'll run and preserve my own hide if the going gets tough."]
            ],
            [//Criminal
                ["Planner", "I always have a plan for what to do when things go wrong."],
                ["Calm", "I am always calm, no matter what the situation. I never raise my voice or let my emotions control me."],
                ["Case the Joint", "The first thing I do in a new place is note the locations of everything valuable - or where such things could be hidden."],
                ["Friendly", "I would rather make a new friend than a new enemy."],
                ["Distrustful", "I am incredibly slow to trust. Those who seem the fairest often have the most to hide."],
                ["Reckless", "I don't pay attention to the risks in a situation. Never tell me the odds."],
                ["Daring", "The best way to get me to do something is to tell me I can't do it."],
                ["Easily Insulted", "I blow up at the slightest insult."],
                ["Honor", "I don't steal from others in the trade."],
                ["Freedom", "Chains are meant to be broken, as are those who would forge them."],
                ["Charity", "I steal from the wealthy so that I can help people in need."],
                ["Greed", "I will do whatever it takes to become wealthy."],
                ["People", "I'm loyal to my friends, not to any ideals, and everyone else can take a trip down the Styx for all I care."],
                ["Redemption", "There's a spark of good in everyone."],
                ["Debt", "I'm trying to pay off an old debt I owe to a generous benefactor"],
                ["Family", "My ill-gotten gains go to support my family"],
                ["Counter-Theft", "Something important was taken from me, and I aim to steal it back."],
                ["Aspiration", "I will become the greatest thief that ever lived."],
                ["Guilt", "I'm guilty of a terrible crime. I hope I can redeem myself for it."],
                ["Lost Love", "Someone I loved died because of a mistake I made. That will never happen again."],
                ["Easily Tempted", "When I see something valuable, I can't think about anything but how to steal it."],
                ["Disloyal", "When faced with a choice between money and my friends, I usually choose the money."],
                ["Improviser", "If there's a plan, I'l forget it. If I don't forget it, I'll ignore it."],
                ["Bad Liar", "I have a \"tell\" that reveals when I'm lying."],
                ["Coward", "I turn tail and run when things look bad."],
                ["Heartless", "An innocent person is in prison for a crime that I committed. I'm okay with that."]
            ],
            [//Entertainer
                ["Storyteller", "I know a story relevant to almost every situation."],
                ["Gossip", "Whenever I come to a new place, I collect local rumors and spread gossip."],
                ["Romantic", "I'm a hopeless romantic, always searching for that \"special someone.\""],
                ["Calming Presence", "Nobody stays angry at me or around me for long, since I can defuse any amount of tension."],
                ["Insulting", "I love a good insult, even one directed at me."],
                ["Attention-Seeker", "I get bitter if I'm not the center of attention."],
                ["Perfectionist", "I'll settle for nothing less than perfection."],
                ["Fickle", "I change my mood or my mind as quickly as I change key in a song."],
                ["Beauty", "When I perform, I make the world better than it was."],
                ["Tradition", "The stories, legends, and songs of the past must never be forgotten, for they teach us who we are."],
                ["Creativity", "The world is in need of new udeas and bold action."],
                ["Greed", "I'm only in it for the money and fame."],
                ["People", "I like seeing the smiles on people's faces when I perform. That's all that matters."],
                ["Honesty", "Art should reflect the soul; it should come from within and reveal who we really are."],
                ["Sentimental Instrument", "My instrument is my most treasured possession, and it reminds me of someone I love."],
                ["Stolen Instrument", "Someone stole my precious instrument, and someday I'll get it back."],
                ["Fame", "I want to be famous, whatever it takes."],
                ["Hero-Worship", "I idolize a hero of the old tales and measure my deeds against that person's."],
                ["Rival", "I will do anything to prove myself superior to my hated rival."],
                ["Loyal", "I would do anything for the other members of my old troupe."],
                ["Cutthroat", "I'll do anything to win fame and renown."],
                ["Easily Charmed", "I'm a sucker for a pretty face."],
                ["Scandalized", "A scandal prevents me from ever going home again. That kind of trouble seems to follow me around."],
                ["Bad Target", "I once satirized a noble who still wants my head. It was a mistake that I will likely repeat."],
                ["No Filter", "I have trouble keeping my true feelings hidden. My sharp tongue lands me in trouble."],
                ["Unreliable", "Despite my best efforts, I am unreliable to my friends."]
            ],
            [//Folk Hero
                ["Judge of Deeds", "I judge people by their actions, not their words."],
                ["Helpful", "If someone is in trouble, I'm always ready to help."],
                ["Completionist", "When I set my mind to something, I follow through no matter what gets in my way."],
                ["Fair", "I have a strong sense of fair play and always try to find the most equitable solution to arguments."],
                ["Confident", "I'm confident in my own abilities and do what I can to instill confidence in others."],
                ["Man of Action", "Thinking is for other people. I prefer action."],
                ["Misused Vocabulary", "I misuse long words in an attempt to sound smarter."],
                ["Easily Bored", "I get bored easily. When am I going to get on with my destiny?"],
                ["Respect", "People deserve to be treated with dignity and respect."],
                ["Fairness", "No one should get preferential treatment before the law, and no one is above the law."],
                ["Freedom", "Tyrants must not be allowed to oppress the people."],
                ["Might", "If I become strong, I can take what I want - what I deserve."],
                ["Sincerity", "There's no good in pretending to be something I'm not."],
                ["Destiny", "Nothing and no one can steer me away from my higher calling."],
                ["Lost Family", "I have a family, but I have no idea where they are. One day, I hope to see them again."],
                ["Land", "I worked the land, I love the land, and I will protect the land."],
                ["Revenge", "A proud noble once gave me a horrible beating, and I will take my revenge on any bully I encounter."],
                ["Tools", "My tools are symbols of my past life, and I carry them so that I will never forget my roots."],
                ["Protector", "I protect those who cannot protect themselves."],
                ["Lost Love", "I wish my childhood sweetheart had come with me to pursue my destiny."],
                ["Tyrannical Enemy", "The tyrant who rules my land will stop at nothing to see me killed."],
                ["Blind Destiny", "I'm convinced of the significance of my destiny, and blind to my shortcomings and the risk of failure."],
                ["Shameful Secret", "The people who knew me when I was young know my shameful secret, so I can never go home again."],
                ["Drinker", "I have a weakness for the vices of the city, especially hard drink."],
                ["Tyrannical Desire", "Secretly, I believe that things would be better if I were a tyrant lording over the land."],
                ["Distrustful", "I have trouble trusting in my allies."]
            ],
            [//Guild Artisan
                ["Perfectionist", "I believe that anything worth doing is worth doing right. I can't help it - I'm a perfectionist."],
                ["Snob", "I'm a snob who looks down on those who can't appreciate fine art."],
                ["Tinkerer", "I always want to know how things work and what makes people tick."],
                ["Aphorisms", "I'm full of witty aphorisms and have a proverb for every occasion."],
                ["High Standards", "I'm rude to people who lack my commitment to hard work and fair play."],
                ["Work-Obsessed", "I like to talk at length about my profession."],
                ["Haggler", "I don't part with my money easily and will haggle tirelessly to get the best deal possible."],
                ["Famous", "I'm well known for my work, and I want to make sure everyone appreciates it. I'm always taken aback when people haven't heard of me."],
                ["Community", "It is the duty of all civilized people to strengthen the bonds of community and the security of civilization."],
                ["Generosity", "My talents were given to me so that I could use them to benefit the world."],
                ["Freedom", "Everyone should be free to pursue his or her own livelihood."],
                ["Greed", "I'm only in it for the money."],
                ["People", "I'm committed to the people I care about, not to ideals."],
                ["Aspiration", "I work hard to be the best there is at my craft."],
                ["Home Shop", "The workshop where I learned my trade is the most important place in the world to me."],
                ["Worthy Recipient", "I created a great work for someone, and then found them unworthy to receive it. I'm still looking for someone worthy."],
                ["Guild", "I owe my guild a great debt for forging me into the person I am today."],
                ["Love", "I pursue wealth to secure someone's love."],
                ["Greatness", "One day I will return to my guild and prove that I am the greatest artisan of them all."],
                ["Revenge", "I will get revenge on the evil forces that destroyed my place of business and ruined my livelihood."],
                ["Tempted by Rarity", "I'll do anything to get my hands on something rare or priceless."],
                ["Suspicious", "I'm quick to assume that someone is trying to cheat me."],
                ["Guild Thief", "No one must ever learn that I once stole money from guild coffers."],
                ["Never Enough", "I'm never satisfied with what I have - I always want more."],
                ["Noble Envy", "I would kill to acquire a noble title."],
                ["Jealousy", "I'm horribly jealous of anyone who can outshine my handiwork. Everywhere I go, I'm surrounded by rivals."]
            ],
            [//Hermit
                ["Silent Type", "I've been isolated for so long that I rarely speak, preferring gestures and the occasional grunt."],
                ["Serene", "I am utterly serene, even in the face of disaster."],
                ["Shared Wisdom", "The leader of my community had something wise to say on every topic, and I am eager to share that wisdom."],
                ["Empathetic", "I feel tremendous empathy for all who suffer."],
                ["Socially Inept", "I'm oblivious to etiquette and social expectations."],
                ["Fatalistic", "I connect everything that happens to me to a grand, cosmic plan."],
                ["Lost in Thought", "I often get lost in my own thoughts and contemplation, becoming oblivious to my surroundings."],
                ["Theorist", "I am working on a grand philosophical theory and love sharing my ideas."],
                ["Greater Good", "My gifts are meant to be shared with all, not used for my own benefit."],
                ["Logic", "Emotions must not cloud our sense of what is right and true, or our logical thinking."],
                ["Free Thinking", "Inquiry and curiosity are the pillars of progress."],
                ["Power", "Solitude and contemplation are paths toward mystical or magical power."],
                ["Live and Let Live", "Meddling in the affairs of others only causes trouble."],
                ["Self-Knowledge", "If you know yourself, there's nothing left to know."],
                ["Hermitage", "Nothing is more important than the other members of my hermitage, order, or association."],
                ["Hunted", "I entered seclusion to hide from the ones who might still be hunting me. I must someday confront them."],
                ["Enlightenment", "I'm still seeking the enlightenment I pursued in my seclusion, and it still eludes me."],
                ["Forbidden Love", "I entered seclusion because I loved someone I could not have."],
                ["Ruinous Discovery", "Should my discovery come to light, it could bring ruin to the world."],
                ["Terrible Evil", "My isolation gave me great insight into a great evil that only I can destroy."],
                ["Earthly Delights", "Now that I've returned to the world, I enjoy its delights a little too much."],
                ["Dark Thoughts", "I harbor dark, bloodthirsty thoughts that my isolation and meditation failed to quell."],
                ["Dogmatic", "I am dogmatic in my thoughts and philosophy."],
                ["Always Right", "I let my need to win arguments overshadow friendships and harmony."],
                ["Risk for Knowledge", "I'd risk too much to uncover a lost bit of knowledge."],
                ["Secretive", "I like keeping secrets and won't share them with anyone."]
            ],
            [//Noble
                ["Flatterer", "My eloquent flattery makes everyone I talk to feel like the most wonderful and important person in the world."],
                ["Generous", "The common folk love me for my kindness and generosity."],
                ["Regal", "No one could doubt by looking at my regal bearing that I am a cut above the unwashed masses."],
                ["Fashionable", "I take great pains to always look my best and follow the latest fashions."],
                ["Pampered", "I don't like to get my hands dirty, and I won't be caught dead in unsuitable accommodations."],
                ["Equal", "Despire my noble birth, I do not place myself above other folk. We all have the same blood."],
                ["Holds a Grudge", "My favor, once lost, is lost forever."],
                ["Vengeful", "If you do me an injury, I will crush you, ruin your name, and salt your fields."],
                ["Respect", "Respect is due to me because of my position, but all people regardless of station deserve to be treated with dignity."],
                ["Responsibility", "It is my duty to respect the authority of those above me, just as those below me must respect mine."],
                ["Independence", "I must prove that I can handle myself without the coddling of my family."],
                ["Power", "If I can attain more power, no one will tell me what to do."],
                ["Family", "Blood runs thicker than water."],
                ["Noble Obligation", "It is my duty to protect and care for the people beneath me"],
                ["Family's Approval", "I will face any challenge to win the approval of my family."],
                ["Important Alliance", "My house's alliance with another noble family must be sustained at all costs."],
                ["Family Members", "Nothing is more important than the other members of my family."],
                ["Forbidden Love", "I am in love with the heir of a family that my family despises."],
                ["Loyalty", "My loyalty to my sovereign is unwavering."],
                ["Hero of the People", "The common folk must see me as a hero of the people."],
                ["Superior", "I secretly believe that everyone is beneath me."],
                ["Terrible Secret", "I hide a truly scandalous secret that could ruin my family forever."],
                ["Quick to Anger", "I too often hear veiled insults and threats in every word addressed to me, and I'm quick to anger."],
                ["Lustful", "I have an insatiable desire for carnal pleasures"],
                ["Self-Centered", "In fact, the world does revolve around me."],
                ["Dishonorable", "By my words and actions, I often bring shame to my family."]
            ],
            [//Outlander
                ["Wanderlust", "I'm driven by a wanderlust that led me away from home."],
                ["Maternal", "I watch over my friends as if they were a litter of newborn pups."],
                ["Marathon Devotion", "I once ran twenty-five miles without stopping to warn my clan of an approaching orc horde. I'd do it again if I had to."],
                ["Learned", "I have a lesson for every situation, drawn from observing nature."],
                ["Unrefined", "I place no stock in wealthy or well-mannered folk. Money and manners won't save you from a hungry owlbear."],
                ["Fidgeter", "I'm always picking things up, absently fiddling with them, and sometimes accidentally breaking them."],
                ["Animal Lover", "I feel far more comfortable around animals than people."],
                ["Wolfkin", "I was, in fact, raised by wolves."],
                ["Change", "Life is like the seasons, in constant change, and we must change with it."],
                ["Greater Good", "It is each person's responsibility to make the most happiness for the whole tribe."],
                ["Honor", "If I dishonor myself, I dishonor my whole clan."],
                ["Might", "The strongest are meant to rule."],
                ["Nature", "The natural world is more important than all the constructs of civilization."],
                ["Glory", "I must earn glory in battle, for myself and my clan."],
                ["Family", "My family, clan, or tribe is the most important thing in my life, even when they are far from me."],
                ["Sacred Homeland", "An injury to the unspoiled wilderness of my home is an injury to me."],
                ["Vengeful", "I will bring terrible wrath down on the evildoers who destroyed my homeland."],
                ["Last of the Tribe", "I am the last of my tribe, and it is up to me to ensure their names enter legend."],
                ["Foreseen Calamity", "I suffer awful visions of a coming disaster and will do anything to prevent it."],
                ["Breeder", "It is my duty to provide children to sustain my tribe."],
                ["Drunk", "I am too enamored of ale, wine, and other intoxicants."],
                ["Reckless", "There's no room for caution in a life lived to the fullest."],
                ["Holds a Grudge", "I remember every insult I've received and nurse a silent resentment toward anyone who's ever wronged me."],
                ["Distrustful", "I am slow to trust members of other races, trives, and societies."],
                ["Violent", "Violence is my answer to almost any challenge."],
                ["Darwinist", "Don't expect me to save those who can't save themselves. It is nature's way that the strong thrive and the weak perish."]
            ],
            [//Sage
                ["Polysyllabic", "I use polysyllabic words that convey the impression of great erudition."],
                ["Well-Read", "I've read every book in the world's greatest libraries - or I like to bast that I have."],
                ["Teacher", "I'm used to helping out those who aren't as smart as I am, and I patiently explain anything and everything to others."],
                ["Investigator", "There's nothing I like more than a good mystery."],
                ["Fair", "I'm willing to listen to every side of an argument before I make my own judgement."],
                ["Condescending", "I...speak...slowly...when talking...to idiots, ...which...almost...everyone...is...compared...to me."],
                ["Awkward", "I am horribly, horribly awkward in social situations."],
                ["Guarded", "I'm convinced that people are always trying to steal my secrets."],
                ["Knowledge", "The path to power and self-improvement is through knowledge."],
                ["Beauty", "What is beautiful points us beyond itself toward what is true."],
                ["Logic", "Emotions must not cloud our logical thinking."],
                ["No Limits", "Nothing should fetter the infinite possibility inherent in all existence."],
                ["Power", "Knowledge is the path to power and domination."],
                ["Self-Improvement", "The goal of a life of study is the betterment of oneself."],
                ["Students", "It is my duty to protect my students."],
                ["Ancient Text", "I have an ancient text that holds terrible secrets that must not fall into the wrong hands."],
                ["Institution", "I work to preserve a library, university, scriptorium, or monastery."],
                ["Lore", "My life's work is a series of tomes related to a specific field of lore."],
                ["Question", "I've been searching my whole life for the answer to a certain question."],
                ["Soul", "I sold my soul for knowledge. I hope to do great deeds and win it back."],
                ["Distracted", "I am easily distracted by the promise of information."],
                ["Unafraid", "Most people scream and run when they see a demon. I stop and take notes on its anatomy."],
                ["Uncaring", "Unlocking an ancient mystery is worth the price of a civilization."],
                ["Inefficient", "I overlook obvious solutions in favor of complicated ones."],
                ["No Filter", "I speak without really thinking through my words, invariably insulting others."],
                ["Loose Lips", "I can't keep a secret to save my life, or anyone else's."]
            ],
            [//Sailor
                ["Reliable", "My friends know they canm rely on me, no matter what."],
                ["Work Hard, Play Hard", "I work hard so that I can play hard when the work is done."],
                ["Social", "I enjoy sailing into new ports and making new friends over a flagon of ale."],
                ["Exaggerator", "I stretch the truth for the sake of a good story."],
                ["Brawler", "To me, a tavern brawl is a nice way to get to know a new city."],
                ["Gambler", "I never pass up a friendly wager."],
                ["Foul-Mouthed", "My language is as foul as an otyugh nest."],
                ["Shirker", "I like a job well done, especially if I can convince someone else to do it."],
                ["Respect", "The thing that keeps a ship together is mutual respect between captain and crew."],
                ["Fairness", "We all do the work, so we all share in the rewards."],
                ["Freedom", "The sea is freedom - the freedome to go anywhere and do anything."],
                ["Mastery", "I'm a predator, and the other ships on the sea are my prey."],
                ["People", "I'm committed to my crewmates, not to ideals."],
                ["Aspiration", "Someday I'll get my own ship and chart my own destiny."],
                ["Captain", "I'm loyal to my captain first, everything else second."],
                ["Ship Loyalty", "The ship is most important - crewmates and captains come and go."],
                ["First Ship", "I'll always remember my first ship."],
                ["Paramour", "In a harbor town, I have a paramour whose eyes nearly stole me from the sea."],
                ["Cheated", "I was cheated out of my fair share fo the profits, and I want to get my due."],
                ["Vengeance", "Ruthless pirates murdered my captain and crewmates, plundered our ship, and left me to die. Vengeance will be mine."],
                ["Blind Follower", "I follow orders, even if I think they're wrong."],
                ["Lazy", "I'll say anything to avoid having to do extra work."],
                ["Easily-Goaded", "Once someone questions my courage, I never back down no matter how dangerous the situation."],
                ["Drunk", "Once I start drinking, it's hard for me to stop."],
                ["Sticky-Fingered", "I can't help but pocket loose coins and other trinkets I come across."],
                ["Prideful", "My pride will probably lead to my destruction."]
            ],
            [//Soldier
                ["Polite", "I'm always polite and respectful."],
                ["Haunted", "I'm haunted by memories of war. I can't get the images of violence out of my mind."],
                ["Friendless", "I've lost too many friends, and I'm slow to make new ones."],
                ["Storyteller", "I'm full of inspiring and cautionary tales from my military experience relevant to almost every combat situation."],
                ["Courageous", "I can stare down a hell hound without flinching."],
                ["Strong", "I enjoy being strong and like breaking things."],
                ["Crude", "I have a crude sense of humor."],
                ["Direct", "I face problems head-on. A simple, direct solution is the best path to success."],
                ["Greater Good", "Out lot is to lay down our lives in defense of others."],
                ["Responsibility", "I do what I must and objey just authority."],
                ["Independence", "When people follow orders blindly, they embrace a kind of tyranny."],
                ["Might", "In life as in war, the stronger force wins."],
                ["Live and Let Live", "Ideals aren't worth killing over or going to war for."],
                ["Nation", "My city, nation, or people are all that matter."],
                ["Compatriots", "I would still lay down my life for the people I served with."],
                ["Companion", "Someone saved my life on the battlefield. To this day, I will never leave a friend behind."],
                ["Honor", "My honor is my life."],
                ["Defeat", "I'll never forget the crushing defeat my company suffered or the enemies who dealt it."],
                ["Allies", "Those who fight beside me are those worth dying for."],
                ["Helpless", "I fight for those who cannot fight for themselves."],
                ["Fearful", "The monstrous enemy we faced in battle still leaves me quivering with fear."],
                ["Disdainful", "I have little respect for anyone who is not a proven warrior."],
                ["Secret Mistake", "I made a terrible mistake in battle that cost many lives, and I would do anything to keep that mistake secret."],
                ["Hateful", "My hatred of my enemies is blind and unreasoning."],
                ["Lawful", "I obey the law, even if the law causes misery."],
                ["Always Right", "I'd rather eat my armor than admit when I'm wrong."]
            ],
            [//Urchin
                ["Full Pockets", "I hide scraps of food and trinkets away in my pockets."],
                ["Questioning", "I ask a lot of questions."],
                ["Claustrophillic", "I like to squeeze into small places where no one else can get to me."],
                ["Tight Hold", "I sleep with my back to a wall or tree, with everything I own wrapped in a bundle in my arms."],
                ["Bad Manners", "I eat like a pig and have bad manners."],
                ["Suspicious", "I think anyone who's nice to me is hiding evil intent."],
                ["Dirty", "I don't like to bathe."],
                ["Blunt", "I bluntly say what other people are hinting at or hiding."],
                ["Respect", "All people, rich or poor, deserve respect."],
                ["Community", "We have to take care of each other, because no one else is going to do it."],
                ["Change", "The low are lifted up, and the high and mighty are brought down."],
                ["Retribution", "The rich need to be shown what life and death are like in the gutters."],
                ["People", "I help the people who help me - that's what keeps us alive."],
                ["Aspiration", "I'm going to prove that I'm worthy of a better life."],
                ["Home City", "My town or city is my home, and I'll fight to defend it."],
                ["Orphanage", "I sponsor an orphanage to keep others from enduring what I was forced to endure."],
                ["Mentor", "I owe my survival to another urchin who taught me to live on the streets."],
                ["Savior", "I owe a debt I can never repay to the person who took pity on me."],
                ["Wanted Theif", "I escaped my life of poverty by robbing an important person, and I'm wanted for it."],
                ["Terrible Past", "No one else should have to endure the hardships I've been through."],
                ["Quick to Flee", "If I'm outnumbered, I will run away from a fight."],
                ["Greedy", "Gold seems like a lot of money to me, and I'll do just about anything for more of it."],
                ["Distrustful", "I will never fully trust anyone other than myself."],
                ["Dirty Fighter", "I'd rather kill someone in their sleep than fight fair."],
                ["Thief", "It's not stealing if I need it more than someone else."],
                ["Darwinist", "People who can't take care of themselves get what they deserve."]
            ]
        ]
        
        let tEntity = NSEntityDescription.entityForName("Trait", inManagedObjectContext: context)!
        let tlEntity = NSEntityDescription.entityForName("TraitList", inManagedObjectContext: context)!
        
        //Get a background out
        let fetchRequest = NSFetchRequest(entityName: "Background");
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        var results: [Background] = [];
        do{
            results = try context.executeFetchRequest(fetchRequest) as! [Background]
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }//catch
        
        var traitLists: [TraitList] = []
        
        for i in 0 ..< traitsData.count{
            
            let thisTraitList: TraitList = NSManagedObject(entity: tlEntity, insertIntoManagedObjectContext: context) as! TraitList
            traitLists.append(thisTraitList)
            
            for j in 0 ..< 8{
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 1
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// personality traits
            for j in 8 ..< 14{
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 2
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// ideals
            for j in 14 ..< 20{
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 3
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// bonds
            for j in 20 ..< 26{
                let thisTrait: Trait = NSManagedObject(entity: tEntity, insertIntoManagedObjectContext: context) as! Trait
                
                thisTrait.id = 1 + i * 26 + j
                thisTrait.name = traitsData[i][j][0]
                thisTrait.details = traitsData[i][j][1]
                thisTrait.category = 4
                thisTrait.canon = true
                
                traitLists[i].traits.insert(thisTrait)
            }// flaws
            
            results[i].traitList = traitLists[i]
            
        }//for each background
        
        do{
            try context.save()
        }catch let error as NSError{
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }//traitsInit
    
}//TraitList