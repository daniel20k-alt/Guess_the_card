//
//  InterfaceController.swift
//  Guess_the_card WatchKit Extension
//
//  Created by DDDD on 04/11/2020.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
        
    
    @IBOutlet var welcomeText: WKInterfaceLabel!
    
    @IBOutlet var hideButton: WKInterfaceButton!
    
    @IBAction func hideWelcomeText() {
        welcomeText.setHidden(true)
        hideButton.setHidden(true)
    }
    
    //whenever a message it receives - the device returns a .click
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        WKInterfaceDevice().play(.click)
    }
    
    
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user, similar to viewDidLoad()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //protocol stub
    }
}
