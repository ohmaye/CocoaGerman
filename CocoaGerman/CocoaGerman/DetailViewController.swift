//
//  DetailViewController.swift
//  CocoaGerman
//
//  Created by Enio Ohmaye on 2/17/16.
//  Copyright © 2016 Enio Ohmaye. All rights reserved.
//

import UIKit


class DetailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    
    var exercise: Bot!
    
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
        initializeGermnan()
        switch detailItem {
        case "PossessiveBot" as String:
            textView.text = "Possessive. Easy. Please say the following in German:"
            textField.text = "Type here"
            exercise = PossessiveBot()
            printText(exercise.showQuestion())
        case "PossessiveRandomBot" as String:
            textView.text = "Possessive randomly. Harder. Please say the following in German:"
            textField.text = "Type here"
            exercise = PossessiveRandomBot()
            printText(exercise.showQuestion())
        default: break
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        printText("                                                      EO: " + textField.text!)
        printText(exercise.showAnswer())
        exercise.nextQuestion()
        printText("")
        printText(exercise.showQuestion())
        textView.scrollRangeToVisible(NSMakeRange(Int.max, 1))
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


