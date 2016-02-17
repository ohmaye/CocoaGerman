//
//  Classes.swift
//  CommandLineGerman
//
//  Created by Enio Ohmaye on 2/15/16.
//  Copyright © 2016 Enio Ohmaye. All rights reserved.
//

// EO: Maybe EasyGerman's "BOXES" can be useful as a way of generating IPO loops...
// when, where, what, who, why, with whom, how...

//import Foundation

enum Gender {
    case masculine, feminine, neutral, plural
}

let genderEnumeration: [Gender] = [.masculine, .feminine, .neutral, .plural]


enum Person {
    case ich, du, er, sie, es, wir, ihr, Sie, sieP
}

let personEnumeration: [Person] = [.ich, .du, .er, .sie, .es, .wir, .ihr, .Sie, .sieP]

enum Tense {
    case present, past
}


enum Case {
    case nominative, accusative, genitive, dative
}

let caseEnumeration: [Case] = [ .nominative, .accusative, .genitive, .dative ]

class Pronoun {
    var nominative: String = ""
    var accusative: String = ""
    var genitive: String = ""
    var dative: String = ""
    var en: String = ""
    var enAccusative: String = ""
    var dePossessive: String = ""
    var enPossessive: String = ""
    
    init( _ nominative: String, _ accusative: String, _ genitive: String, _ dative: String, en: String, dePoss: String, enPoss: String, enAcc: String ) {
        self.nominative = nominative
        self.accusative = accusative
        self.genitive = genitive
        self.dative = dative
        self.en = en
        self.enAccusative = enAcc
        self.dePossessive = dePoss
        self.enPossessive = enPoss
    }
}

func getPossessive( aPerson: Person, aCase: Case, aGender: Gender ) -> String {
    var base = pronounsDict[aPerson]!.dePossessive
    
    switch aCase {
    case .nominative:
        switch aGender {
        case .masculine, .neutral: break
        case .feminine, .plural: base += "e"
        }
    case .accusative:
        switch aGender {
        case .masculine: base += "en"
        case .neutral: break
        case .feminine, .plural:  base += "e"
        }
    case .genitive:
        switch aGender {
        case .masculine, .neutral:  base += "es"
        case .feminine, .plural:  base += "er"
        }
    case .dative:
        switch aGender {
        case .masculine, .neutral:  base += "em"
        case .feminine:  base += "er"
        case .plural:  base += "en"
        }
    }
    if base == "eur" {
        base = "euer"
    }
    return base
}

// Create a dictionary of personal pronouns along with objects that associate them with base form for the possessive.

var pronounsDict: [Person: Pronoun] = [
    .ich: Pronoun("ich", "mich", "meiner", "mir", en: "I", dePoss: "mein", enPoss: "my", enAcc: "me"),
    .du: Pronoun("du", "dich", "deiner", "dir", en: "you (sg)", dePoss: "dein", enPoss: "your (sg)", enAcc:  "you (sg)"),
    .er: Pronoun("er", "ihn", "seiner", "ihm", en: "he", dePoss: "sein", enPoss: "his", enAcc: "him"),
    .es: Pronoun("es", "es", "seiner", "ihm", en: "it", dePoss: "sein", enPoss: "its", enAcc:  "it"),
    .sie: Pronoun("sie", "sie", "ihrer", "ihr", en: "she", dePoss: "ihr", enPoss: "her", enAcc: "her"),
    .wir: Pronoun("wir", "uns", "unser", "uns", en: "we", dePoss: "unser", enPoss: "our", enAcc: "us"),
    .ihr: Pronoun("ihr", "euch", "euer", "euch", en: "you (pl)", dePoss: "eur", enPoss: "your (pl)", enAcc:  "you (pl)"),
    .Sie: Pronoun("Sie", "Sie", "Ihrer", "Ihnen", en: "You (pl.pol)", dePoss: "Ihr", enPoss: "Your (pl.pol)", enAcc: "you(pl.pol)"),
    .sieP: Pronoun("sie", "sie", "ihrer", "ihnen", en: "they", dePoss: "ihr", enPoss: "their", enAcc: "them")
]


class Noun {
    var de: String = ""
    var en: String = ""
    var gender: Gender = .neutral
    var dePlural: String = ""
    
    init (_ de: String,  _ gender: Gender, _ dePlural: String, _ en: String ) {
        self.de = de
        self.en = en
        self.gender = gender
        self.dePlural = dePlural
    }
    
}

class Verb {
    // Type storage. Dictionary holds all verbs and cached conjugations.
    static var verbs = [String: Verb]()
    
    var infinitive: String = ""
    var root: String = ""
    var conjugations = [Tense: [String]]()
    
    init( infinitive: String, root: String ) {
        self.infinitive = infinitive
        self.root = root
    }
    
    
    func cacheVerb(tense: Tense, _ ich: String, _ du: String, _ ersiees: String, _ wir: String, _ ihr: String, _ sie: String) {
        let entries = [ich, du, ersiees, wir, ihr, sie]
        self.conjugations[tense] = entries
        
        if  Verb.verbs[infinitive] == nil {
            Verb.verbs[self.infinitive] = self
        }
    }
    
    func conjugate(aPerson: Person, tense: Tense ) -> String {
        let entries = conjugations[tense]
        switch aPerson {
        case .ich: return entries![0]
        case .du: return entries![1]
        case .er, .sie, .es: return entries![2]
        case .wir: return entries![3]
        case .ihr: return entries![4]
        case .Sie, .sieP: return entries![5]
        }
    }
    
}

class WeakVerb : Verb {
    override func conjugate (aPerson: Person, tense: Tense ) -> String {
        var rootPlus = root
        switch tense {
        case .present:
            switch aPerson {
            case .ich: rootPlus += "e"
            case .du: rootPlus +=  "st"
            case .er, .sie, .es: rootPlus +=  "t"
            case .ihr: rootPlus +=  "t"
            default: rootPlus +=  "en"
            }
        case .past:
            switch aPerson {
            case .ich: rootPlus +=  "te"
            case .du: rootPlus += "test"
            case .er, .sie, .es: rootPlus += "te"
            case .ihr: rootPlus +=  "tet"
            default: rootPlus +=  "ten"
            }
        }
        return rootPlus
    }
}

let dict: [Noun] = [
    Noun("Vater", .masculine, "Vater", "father"),
    Noun("Mutter", .feminine, "Mutter", "mother"),
    Noun("Kind", .neutral, "Kinder", "child"),
    Noun("Kinder", .plural, "Kinder", "children"),
    Noun("Mann", .masculine, "Männer", "man" ),
    Noun("Frau", .feminine, "Frauen", "woman"),
    Noun("Kind", .neutral, "Kinder", "child"),
    Noun("Erde", .feminine, "Erden", "earth"),
    Noun("Himmel", .masculine ,"Himmel", "sky"),
    Noun("Mond", .masculine, "Monde", "moon"),
    Noun("Punkt", .masculine, "Punkte", "dot"),
    Noun("Stern", .masculine, "Sterne", "star"),
    Noun("Eis", .neutral, "", "ice"),
    Noun("Ehe", .feminine, "Ehen", "marriage"),
    Noun("Übung", .feminine, "", "exercise"),
    Noun("Ohr", .neutral, "Ohren", "ear")
]




