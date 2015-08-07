//
//  CheckoutVC.swift
//  TwoTapTest
//
//  Created by Saul on 8/6/15.
//  Copyright (c) 2015 Saul. All rights reserved.
//

import UIKit
import WebKit


class CheckoutVC: UIViewController {
    
    var theWebView:WKWebView!
    var whatToGet:String!
    @IBOutlet weak var buttonView: UIView!
    var customCSS:String!
    var ttPath:String!
    override func viewDidLoad() {
        super.viewDidLoad()
       println("WHAT TO GET \(whatToGet)")
        switch(whatToGet){
            case "deal":
               customCSS = "http://192.168.1.17:2500/stylesheets/integration_twotap_ios.css"
            case "wallet":
                customCSS = "http://192.168.1.17:2500/stylesheets/integration_twotap_ios_wallet.css"
            case "confirm":
                customCSS = "http://192.168.1.17:2500/stylesheets/integration_twotap_ios_confirm.css"
            
        default:
            println("Error")
        }
        
          ttPath = "http://192.168.1.17:2500/integration_iframe?custom_css_url=\(customCSS)&product=http://www.nastygal.com/sale/the-jetset-diaries-eternal-whispers-embroidered-dress"
        navigationController?.navigationBar.hidden = true
        if let url = NSURL(string: ttPath) {
            let req = NSURLRequest(URL: url)
            var theConfiguration = WKWebViewConfiguration()
            theWebView = WKWebView(frame:self.view.frame)
            //frame when buttonView is shown
                 //theWebView = WKWebView(frame:CGRectMake(0, (self.view.frame.origin.y+buttonView.frame.height+20), self.view.frame.width, self.view.frame.height-buttonView.frame.height-20))
            
            println(theWebView.frame)
                   //end of changes
            theWebView.loadRequest(req)
            self.view.insertSubview(theWebView, atIndex: 0)
            evaluateView()
            buttonView.hidden = true

            NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "getMessageJSON:", userInfo: nil, repeats: true)
        }
       
        // Do any additional setup after loading the view.
    }
    @IBAction func getSiteInfoJSON(sender: AnyObject) {
        theWebView?.evaluateJavaScript("sitesInfoJSON()", completionHandler: { (data, error) -> Void in
            println(data)
        })
    }
    @IBAction func getPurchasePriceJSON(sender: AnyObject) {
        theWebView?.evaluateJavaScript("currentPurchasePricesJSON()", completionHandler: { (data, error) -> Void in
            println(data)
        })
        
    }
    @IBAction func getCartJSON(sender: AnyObject) {
        theWebView?.evaluateJavaScript("currentCartJSON()", completionHandler: { (data, error) -> Void in
            println(data)
        })
    }
    
    @IBAction func getMessageJSON(sender: AnyObject) {
        theWebView?.evaluateJavaScript("postMessagesJSON()", completionHandler: { (data, error) -> Void in
            println(data)
        })

        
    }

    func confirmJavascript(){
        theWebView?.evaluateJavaScript("document.getElementsByClassName('btn-blue')[0].innerHTML = 'Save'", completionHandler:{ (data, error) -> Void in
             println(data)
        })
        println("HIT")
    
    }
    
    
    func evaluateView(){
        switch(whatToGet){
            case "confirm":
            confirmJavascript()
        default:
            break
        }
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

