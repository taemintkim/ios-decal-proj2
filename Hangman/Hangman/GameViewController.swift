//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var puzzleWord: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var incorrectGuesses: UILabel!
    @IBOutlet weak var inputField: UITextField!
    var phrase: String = "default"
    var charDict = [Character: [Int]]()
    var imageList: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputField.delegate = self
        prepareNewGame()
        // Do any additional setup after loading the view.
    }
    
    private func prepareNewGame() {

        
        let hangmanPhrases = HangmanPhrases()
        phrase = hangmanPhrases.getRandomPhrase()
        print(phrase)
        puzzleWord.text = freshLabel()
        let firstimg = UIImage(named: "hangman1")!
        imageView.image = firstimg
        imageList.append(UIImage(named: "hangman7")!)
        imageList.append(UIImage(named: "hangman6")!)
        imageList.append(UIImage(named: "hangman5")!)
        imageList.append(UIImage(named: "hangman4")!)
        imageList.append(UIImage(named: "hangman3")!)
        imageList.append(UIImage(named: "hangman2")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func guessButtonPress(_ sender: UIButton) {
        if inputField.text == nil || inputField.text == "" {
            return
        }
        
        assert(inputField.text!.characters.count == 1)
        let inputChar: Character = inputField.text!.uppercased().characters.first!
        if charDict[inputChar] != nil {
            puzzleWord.text = replaceChars(in: puzzleWord.text!, at: charDict[inputChar]!, with: inputChar)
            if !puzzleWord.text!.contains("_") {
                alert("You Win!")
            }
        } else {
            if !incorrectGuesses.text!.contains(String(inputChar)) {
                incorrectGuesses.text!.append(inputChar)
                evolveHangman()
            }
        }
        inputField.text = ""
    }
    
    /* 
     Restrict user from typing in more than 1 char.
    */
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let newLength = text.utf16.count + string.utf16.count - range.length
        return newLength <= 1
    }
    
    private func evolveHangman() {
        if imageList.count > 0 {
            imageView.image = imageList.popLast()
            if imageList.count == 0 {
                alert("You Lose!")
            }
        } else {
            alert("You Lose!")
        }
    }
    
    private func replaceChars(in str: String, at indexes: [Int], with char: Character) -> String {
        var count: Int = 0
        var result: String = ""
        for c in str.characters {
            if indexes.contains(count) {
                result.append(char)
            }
            else {
                result.append(c)
            }
            count += 1
        }
        return result
    }
    
    
    private func freshLabel() -> String {
        var result: String = ""
        var i: Int = 0
        
        for c in phrase.characters {
            if c != " " {
                if charDict[c] != nil {
                    charDict[c]!.append(i)
                } else {
                    charDict[c] = [i]
                }
                result += "_"
            } else {
                result += " "
            }
            result.append(" ")
            i += 2
        }
        return result
    }
    
    private func alert(_ endMessage: String) {
        //Creating the alert controller
        //It takes the title and the alert message and prefferred style
        let alertController = UIAlertController(title: endMessage, message: "gg", preferredStyle: .alert)
        
        //then we create a default action for the alert...
        //It is actually a button and we have given the button text style and handler
        //currently handler is nil as we are not specifying any handler
        let defaultAction = UIAlertAction(title: "Play Again", style: .default, handler: alertHandler)
        
        //now we are adding the default action to our alertcontroller
        alertController.addAction(defaultAction)
        
        //and finally presenting our alert using this method
        present(alertController, animated: true, completion: nil)
    }
    
    private func alertHandler(alert: UIAlertAction!) {
        imageList = []
        puzzleWord.text = ""
        incorrectGuesses.text = ""
        inputField.text = ""
        charDict = [Character: [Int]]()
        prepareNewGame()
    }




}

extension NSRange {
    func range(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        
        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }
        
        return fromIndex ..< toIndex
    }
}
