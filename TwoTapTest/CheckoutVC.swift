//
//  CheckoutVC.swift
//  TwoTapTest
//
//  Created by Saul on 8/6/15.
//  Copyright (c) 2015 Saul. All rights reserved.
//

import UIKit
import WebKit


class CheckoutVC: UIViewController,WKNavigationDelegate {
    
    var customCSS:String!
    var theWebView = WKWebView(frame: CGRectMake(0, 70, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height - 70))
    var ttPath:String!
    var urlString:String!
    var localhostString = "localhost"
    
    @IBOutlet weak var topView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        customCSS = "http:/\(localhostString):2500/stylesheets/integration_twotap_ios.css"
          ttPath = "http://\(localhostString):2500/integration_iframe?custom_css_url=\(customCSS)&product=\(urlString)"
        navigationController?.navigationBar.hidden = true
        theWebView.navigationDelegate = self
        if let url = NSURL(string: ttPath) {
            let req = NSURLRequest(URL: url)
            theWebView.loadRequest(req)
            self.view.addSubview(theWebView)
            self.view.insertSubview(topView, aboveSubview: theWebView)
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "postMessage", userInfo: nil, repeats: true)
        }

        // Do any additional setup after loading the view.
    }
   
    func closeAlert(){
        let alert = UIAlertController(title: "Your progress will be lost. Are you sure you want to close the checkout?", message: nil, preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func postMessage(){
        self.theWebView.evaluateJavaScript("postMessagesJSON()", completionHandler: { (object, error) -> Void in
            if(object != nil){
                    println(object)
                    var objectString:String = object as! String
                    if(objectString.rangeOfString("close_pressed") != nil){
                        self.closeAlert()
                }
            }
        })
    }
    @IBAction func closeClicked(sender: AnyObject) {
         closeAlert()
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.theWebView.evaluateJavaScript("backPressed()", completionHandler: { (object, error) -> Void in
            println("back")
        })
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

