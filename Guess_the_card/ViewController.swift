//
//  ViewController.swift
//  Guess_the_card
//
//  Created by DDDD on 04/11/2020.
//

import UIKit

class ViewController: UIViewController {
    
    var allCards = [CardViewController]()
    
    @IBOutlet var cardContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCards()
        
        
    }
    
    @objc func loadCards() {
        
        //enabling user interaction
        view.isUserInteractionEnabled = true
        
        //this will remove any existing cards
        for card in allCards {
            card.view.removeFromSuperview()
            card.removeFromParent()
        }
        
        allCards.removeAll(keepingCapacity: true)

        
        // creating a card array positions
        let positions = [
            CGPoint(x: 75, y: 85),
            CGPoint(x: 185, y: 85),
            CGPoint(x: 295, y: 85),
            CGPoint(x: 405, y: 85),
            CGPoint(x: 75, y: 235),
            CGPoint(x: 185, y: 235),
            CGPoint(x: 295, y: 235),
            CGPoint(x: 405, y: 235),
        ]
        
        //loading the cards
        let circle = UIImage(named: "cardCircle")!
        let cross = UIImage(named: "cardCross")!
        let lines = UIImage(named: "cardLines")!
        let square = UIImage(named: "cardSquare")!
        let star = UIImage(named: "cardStar")!
        
        //creating array for iamges and shuffling
        var images = [circle, circle, cross, cross, lines, lines, square, star]
        images.shuffle()
        
        
        for (index, position) in positions.enumerated() {
            //looping through each card and creating new view controller
            let card = CardViewController()
            card.delegate = self
            
            //add the card views tol the CardViewControler()
            addChild(card)
            cardContainer.addSubview(card.view)
            card.didMove(toParent: self)
            
            //positioning the card and giving it an image from array
            card.view.center = position
            card.front.image = images[index]
            
            if card.front.image == star {
                card.isCorrect = true
            }
            
            //adding the card view controller to array for ease of tracking
            allCards.append(card)
        }
    }
    
    
    func cardTapped(_ tapped: CardViewController) {
     
        guard view.isUserInteractionEnabled == true else { return }
        view.isUserInteractionEnabled = false
        
        for card in allCards {
            if card == tapped {
                card.wasTapped()
                card.perform(#selector(card.wasntTapped), with: nil, afterDelay: 1)
            } else {
                card.wasntTapped()
            }
        }
        
        perform(#selector(loadCards), with: nil, afterDelay: 2) //calling loadCards() after 2 sec
    }
}
