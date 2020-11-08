//
//  CardViewController.swift
//  Guess_the_card
//
//  Created by DDDD on 05/11/2020.
//

import UIKit

class CardViewController: UIViewController {
    
    weak var delegate: ViewController!
    
    var front: UIImageView!
    var back: UIImageView!
    
    var isCorrect = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        perform(#selector(wiggleCards), with: nil, afterDelay: 1) //calling the scaling of cards 

        view.bounds = CGRect(x: 0, y: 0, width: 100, height: 140)
        front = UIImageView(image: UIImage(named: "cardBack"))
        back = UIImageView(image: UIImage(named: "cardBack")) //change later to cardFront, for testing dimensions purposes only
        
        view.addSubview(front)
        view.addSubview(back)
        
        front.isHidden = true
        back.alpha = 0
        
        UIView.animate(withDuration: 0.2) {
            self.back.alpha = 1
        }
        
        //allowing to send impulses when hovering over the right card
        let tap = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        back.isUserInteractionEnabled = true
        back.addGestureRecognizer(tap)
        
    }
    
    
    @objc func cardTapped() {
        delegate.cardTapped(self)
    }
    
    
    @objc func wasntTapped() {
        UIView.animate(withDuration: 0.7) {
            self.view.transform = CGAffineTransform(scaleX: 0.00001, y: 0.00001)
            self.view.alpha = 0
        }
    }
    
    
    @objc func wasTapped() {
        UIView.transition(with: view, duration: 0.7, options: [.transitionFlipFromRight], animations: { [unowned self] in
            self.back.isHidden = true
            self.front.isHidden = false
        })
    }
    
    
    @objc func wiggleCards() {
        if Int.random(in: 0...3) == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
                self.back.transform = CGAffineTransform(scaleX: 1.01, y: 1.01) //1%
            }) { _ in
                self.back.transform = CGAffineTransform.identity
            }
            
            perform(#selector(wiggleCards), with: nil, afterDelay: 8) //after first move
        
        } else {
            perform(#selector(wiggleCards), with: nil,afterDelay: 2)
        }
    }
    
}
