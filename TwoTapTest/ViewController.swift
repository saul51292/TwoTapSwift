//
//  ViewController.swift
//  TwoTapTest
//
//  Created by Saul on 8/6/15.
//  Copyright (c) 2015 Saul. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var urlString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func startTwoTap(sender: AnyObject) {
        urlString = "http://www.nastygal.com/sale/the-jetset-diaries-eternal-whispers-embroidered-dress"
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
            vc.urlString = urlString
        }
    }
    

}

