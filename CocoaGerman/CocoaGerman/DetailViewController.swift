//
//  DetailViewController.swift
//  CocoaGerman
//
//  Created by Enio Ohmaye on 2/17/16.
//  Copyright © 2016 Enio Ohmaye. All rights reserved.
//

import UIKit

var sharedTextView: UITextView!

class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
 //   var exercise: ExerciseBotPossessive
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        sharedTextView = textView
        initializeGermnan()
        textView.text = "German Significant Others"
        textField.text = "Type here"
//        exercise = ExerciseBotPossessive()
//        printText(exercise.showQuestion())
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        printText(exercise.showAnswer())
        textField.text = ""
        return true
    }
    
    func printText(text: String) {
        textView.text = textView.text + "\n" + text
    }

}


extension CollectionType {
    /// Return a copy of `self` with its elements shuffled
    func shuffle() -> [Generator.Element] {
        var list = Array(self)
        list.shuffleInPlace()
        return list
    }
}

extension MutableCollectionType where Index == Int {
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
}

func initializeGermnan() {
    WeakVerb(infinitive: "machen", root: "mach")
    var verb = Verb(infinitive: "haben", root: "")
    verb.cacheVerb(.present, "habe", "hast", "hat", "haben", "habt", "haben")
    verb.cacheVerb(.past, "hatte", "hattest", "hatte", "hatten", "hattet", "hatten")
    verb = Verb(infinitive: "werden", root: "")
    verb.cacheVerb(.present, "werde", "wirst", "wird", "werden", "werdet", "werden")
    verb.cacheVerb(.past, "wurde", "wurdest", "wurde", "wurden", "wurdet", "wurden")
    verb = Verb(infinitive: "sein", root: "")
    verb.cacheVerb(.present, "bin", "bist", "ist", "sind", "seid", "sind")
    verb.cacheVerb(.past, "war", "warst", "war", "waren", "wart", "waren")
    verb = Verb(infinitive: "sehen", root: "")
    verb.cacheVerb(.present, "sehe", "siehst", "sieht", "sehen", "seht", "sehen")
    verb.cacheVerb(.past, "sah", "sahst", "sah", "sahen", "saht", "sahen")
    verb = Verb(infinitive: "geben", root: "")
    verb.cacheVerb(.present, "gebe", "gibst", "gibt", "geben", "gebt", "geben")
    verb.cacheVerb(.past, "gab", "gabst", "gab", "gaben", "gabt", "gaben")
}

/* Testing production of possessive pronoun table.
for aPerson in personEnumeration {
print(aPerson)
for aCase in caseEnumeration {
//print(aCase)
var outString = ""
for aGender in genderEnumeration {
outString += getPossessive(aPerson, aCase: aCase, aGender: aGender) + " "
}
print( outString )
}
}
*/





/* Testing conjugation of cached verbs
for (_, verb) in Verb.verbs {
for person in personEnumeration {
print("\(person) " +  verb.conjugate(person, tense: .present))
}
for person in personEnumeration {
print("\(person) " +  verb.conjugate(person, tense: .past))
}
}
*/

class ExerciseBotPossessive {
    var currentItem = 0
    var questionsAndAnswers = [(promt: String, answer: String)]()
    
    init() {
        for (person, pronoun) in pronounsDict {
            for item in 0...3 {
                let prompt = "SAY: \(pronoun.enPossessive) \(dict[item].en)"
                let pron = getPossessive(person, aCase: .nominative, aGender: dict[item].gender)
                let answer = "ANSWER:                 \(pron) \(dict[item].de)"
                questionsAndAnswers.append((prompt, answer))
            }
        }
    }
    
    func showQuestion() -> String {
        if currentItem < questionsAndAnswers.count {
            let (q, _) = questionsAndAnswers[currentItem++]
            return q
        } else {
            return "You've finished the whole list. Well done!"
        }
    }
    
    func showAnswer() -> String {
        if currentItem < questionsAndAnswers.count {
            let (_, a) = questionsAndAnswers[currentItem++]
            return a
        } else {
            return "..."
        }
    }
    
    
}

func exercisePossessive() {
    for (person, pronoun) in pronounsDict {
        for item in 0...3 {
            print("-")
            print("SAY:                    \(pronoun.enPossessive) \(dict[item].en)")
 //           readLine()
            let pron = getPossessive(person, aCase: .nominative, aGender: dict[item].gender)
            print("ANSWER:                 \(pron) \(dict[item].de)")
        }
    }
}


func exercisePossessiveRandom() {
    var shuffle = [(Person, Pronoun, Int)]()
    
    for (person, pronoun) in pronounsDict {
        for item in 0...3 {
            shuffle.append((person, pronoun, item))
        }
    }
    
    shuffle = shuffle.shuffle()
    for (person, pronoun, item) in shuffle {
        print("-")
        print("SAY:                    \(pronoun.enPossessive) \(dict[item].en)")
        readLine()!
        let pron = getPossessive(person, aCase: .nominative, aGender: dict[item].gender)
        print("ANSWER:                 \(pron) \(dict[item].de)")
    }
}

// subject SEE object. Personal pronoun in nominative + SEHEN + accusative
// Create a list of tupples. (person, person). Which we'll then shuffle to generate exercises.
func exerciseAccusative() {
    var shuffle = [(Person, Pronoun, Pronoun)]()
    
    for (person, subject) in pronounsDict {
        for (_, object) in pronounsDict {
            shuffle.append((person, subject, object))
        }
    }
    shuffle = shuffle.shuffle()
    let shuffleSize = shuffle.count
    var count = 1
    for (person, subject, object) in shuffle {
        print("- \(count++) / \(shuffleSize)")
        print("SAY:                    \(subject.en)  (SEE/s)  \(object.enAccusative)")
//        theInput = readLine()!
        let verb = Verb.verbs["sehen"]!.conjugate(person, tense: .present)
        print("ANSWER:                           \(subject.nominative) \(verb) \(object.accusative)")
    }
}

// SUBJECT (GIVE) IND-OBJECT a book
func exerciseDative() {
    var shuffle = [(Person, Pronoun, Pronoun)]()
    
    for (person, subject) in pronounsDict {
        for (_, object) in pronounsDict {
            if (subject !== object) {
                shuffle.append((person, subject, object))
            }
        }
    }
    shuffle = shuffle.shuffle()
    let shuffleSize = shuffle.count
    var count = 1
    for (person, subject, object) in shuffle {
        print("- \(count++) / \(shuffleSize)")
        print("SAY:                    \(subject.en)  (GIVE/s)  \(object.enAccusative) a book.")
//        theInput = readLine()!
        let verb = Verb.verbs["geben"]!.conjugate(person, tense: .present)
        print("ANSWER:                           \(subject.nominative) \(verb) \(object.dative) ein buch.")
    }
}
/*

var response = ""

while response != "quit" {
    print("1. Possessive 2. Random 3.Accusative 4. Dative")
    response = readLine()!
    switch response {
    case "1": exercisePossessive()
    case "2": exercisePossessiveRandom()
    case "3": exerciseAccusative()
    case "4": exerciseDative()
    default:break
    }
}
*/
