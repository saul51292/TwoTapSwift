//
//  ViewController.swift
//  TwoTapTest
//
//  Created by Saul on 8/6/15.
//  Copyright (c) 2015 Saul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var whatToSend:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func confirmTwoTap(sender: AnyObject) {
        whatToSend = "confirm"
        self.performSegueWithIdentifier("moveToView", sender: self)
    }
    @IBAction func walletTwoTap(sender: AnyObject) {
        whatToSend = "wallet"
        self.performSegueWithIdentifier("moveToView", sender: self)
    }
    
    @IBAction func DealTwoTap(sender: AnyObject) {
        whatToSend = "deal"
        self.performSegueWithIdentifier("moveToView", sender: self)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "moveToView") {
            // pass data to next view
            let vc = segue.destinationViewController as! CheckoutVC
            vc.whatToGet = whatToSend
        }
    }
    

}

