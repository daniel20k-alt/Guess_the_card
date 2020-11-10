//
//  ViewController.swift
//  Guess_the_card
//
//  Created by DDDD on 04/11/2020.
//

import UIKit
import AVFoundation
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate {
    
    var allCards = [CardViewController]()
    
    @IBOutlet var cardContainer: UIView!
    
    @IBOutlet var gradientView: GradientView!
    
    var music: AVAudioPlayer!
    var lastMessage: CFAbsoluteTime = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createParticles()
        loadCards()
        playMusic()
        
        view.backgroundColor = UIColor.red
        UIView.animate(withDuration: 20, delay: 0, options: [.allowUserInteraction, .autoreverse, .repeat], animations: {
            self.view.backgroundColor = UIColor.blue
        })
        
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    
    func sendWatchMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        //exit if less than half a second has passed since last buzz
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        //if watch reacheable - send message
        if WCSession.default.isReachable {
            //the message doesn't matter
            let message = ["Mesaj1": "Mesaj2"]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        //updating the time limiting propery
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
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
    
    
    //loading and playing the music
    func playMusic() {
        if let musicURL = Bundle.main.url(forResource: "PhantomFromSpace", withExtension: "mp3") {
            if let audioPlayer = try? AVAudioPlayer(contentsOf: musicURL) {
                music = audioPlayer
                music.numberOfLoops = -1
                music.play()
            }
        }
    }
    
    //whenever the user uses force touch at maximum possible force - the card is set to correct
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        
        guard let touch = touches.first else { return }
        let location = touch.location(in: cardContainer)
        
        for card in allCards {
            if card.view.frame.contains(location) { //true if point/user is inside rectangle/card
                if view.traitCollection.forceTouchCapability == .available { //checking if 3dtouch is enabled
                    if touch.force == touch.maximumPossibleForce {
                        card.front.image = UIImage(named: "cardStar")
                        card.isCorrect = true
                        
                    }
                }
                
                if card.isCorrect {
                    sendWatchMessage()
                }
            }
        }
    }
}
