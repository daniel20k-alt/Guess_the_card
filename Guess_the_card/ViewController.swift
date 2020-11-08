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
    
    @IBOutlet var gradientView: GradientView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createParticles()
        loadCards()
        
        view.backgroundColor = UIColor.red
        UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.view.backgroundColor = UIColor.blue
        })
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
    
    
    //creating the particle emmiter
    func createParticles() {
     let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.frame.width / 2, y: -50)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.width, height: 1)
        particleEmitter.renderMode = .additive
        
        let cell = CAEmitterCell()
        cell.birthRate = 2 //particles created per sec
        cell.lifetime = 5.0 //lifetime of particle in sec
        cell.velocity = 100 //base movements speed
        cell.velocityRange = 50 //velocity variation
        cell.emissionLongitude = .pi //direction particles are fired
        cell.spinRange = 5 //spin variation of particles
        cell.scale = 0.5 //size of particles, 1.0 max
        cell.scaleRange = 0.25 //size variation of particles
        cell.color = UIColor(white: 1, alpha: 0.1).cgColor //particle color
        cell.alphaSpeed = -0.025 //fade out of particles
        cell.contents = UIImage(named: "particle")?.cgImage
        particleEmitter.emitterCells = [cell]
        
        gradientView.layer.addSublayer(particleEmitter) //the emitter will be behind cards
    
    }
}
