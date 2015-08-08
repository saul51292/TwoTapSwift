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
    
    @IBOutlet weak var dealImage: UIImageView!
    var whatToGet:String!
    @IBOutlet weak var buttonView: UIView!
    var customCSS:String!
    var theWebView : WKWebView = WKWebView()
    var ttPath:String!
    var localhostString = "localhost"
    var myView = PassThroughView(frame: CGRectMake(0,0,100,100))
    @IBOutlet weak var clickThroughLabel: UILabel!
    @IBOutlet weak var clickThroughView: PassThroughView!
    var testView = UIView(frame:CGRectMake(0,0,100,100))
    var doneOnce = false

    override func viewDidLoad() {
        super.viewDidLoad()
        localhostString = "192.168.1.17"
       println("WHAT TO GET \(whatToGet)")
        switch(whatToGet){
            case "deal":
               customCSS = "http:/\(localhostString):2500/stylesheets/integration_twotap_ios.css"
            case "wallet":
                customCSS = "http://\(localhostString):2500/stylesheets/integration_twotap_ios_wallet.css"
            case "confirm":
                customCSS = "http://\(localhostString):2500/stylesheets/integration_twotap_ios_confirm.css"
            
        default:
            println("Error")
        }
        
          ttPath = "http://\(localhostString):2500/integration_iframe?custom_css_url=\(customCSS)&product=http://www.nastygal.com/sale/the-jetset-diaries-eternal-whispers-embroidered-dress"
        navigationController?.navigationBar.hidden = true
        theWebView = WKWebView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height/6.0, self.view.frame.width, self.view.frame.height), configuration: WKWebViewConfiguration())
        theWebView.navigationDelegate = self
        if let url = NSURL(string: ttPath) {
            let req = NSURLRequest(URL: url)
            println(theWebView.frame)
            theWebView.loadRequest(req)
            self.view.addSubview(theWebView)
            theWebView.opaque = false
            createBlur()
            NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: "getTitle", userInfo: nil, repeats: true)
            theWebView.hidden = true
        }

        // Do any additional setup after loading the view.
    }
    
    func createBlur(){
        var darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        var blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = self.view.bounds
        self.view.insertSubview(blurView, belowSubview: buttonView)
        self.view.insertSubview(dealImage, belowSubview: blurView)

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func setFrameForOrder(){
        if(!CGAffineTransformIsIdentity(self.theWebView.transform)){
            UIView.animateWithDuration(0.1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.theWebView.transform = CGAffineTransformIdentity
            }, completion: nil)
        }
    }
    
    func setFrameForInfoForm(){
        if(CGAffineTransformIsIdentity(self.theWebView.transform)){
           UIView.animateWithDuration(0.1, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.theWebView.transform = CGAffineTransformMakeTranslation(0, (-UIScreen.mainScreen().bounds.height/6.0+20))
            }, completion: nil)
        }
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkShippingAddress(){
        self.theWebView.evaluateJavaScript("document.getElementsByClassName('shipping-info')[0].getElementsByTagName('p')[0].childNodes[0].innerHTML;", completionHandler: { (object, error) -> Void in
            var myString:String = (object as? String)!
            if (myString != "<b>undefined</b>" ){
                self.replaceShippingAddress()
            }
        })

    }
    
    func replaceShippingAddress(){
        
        self.theWebView.evaluateJavaScript("var wholeAddress = document.getElementsByClassName('shipping-info')[0].getElementsByTagName('span')[0];wholeAddress.innerHTML=wholeAddress.innerHTML.replace('United States of America','');var lastChar = wholeAddress.innerHTML.substr(wholeAddress.innerHTML.length - 13);var findString = '';for (var x = 0; x < lastChar.length; x++){ var c = lastChar.charAt(x);if(c <='9' && c >='0' || c== '-') {findString+=c;}};if(findString.length >=10){wholeAddress.innerHTML=wholeAddress.innerHTML.replace(findString,'');wholeAddress.innerHTML = wholeAddress.innerHTML.replace('<br>',',');wholeAddress.innerHTML = wholeAddress.innerHTML.replace('<br>',',');;var array = wholeAddress.innerHTML.split(',');wholeAddress.innerHTML=wholeAddress.innerHTML.replace(array[0],'');wholeAddress.innerHTML=wholeAddress.innerHTML.replace(array[2],'');wholeAddress.innerHTML=wholeAddress.innerHTML.replace(',','');wholeAddress.innerHTML=wholeAddress.innerHTML.replace(',','');};", completionHandler: { (object, error) -> Void in
            println(object)
        })
    }
    
    @IBAction func backButtonClicked(sender: AnyObject) {
        self.theWebView.evaluateJavaScript("backPressed()", completionHandler: { (object, error) -> Void in
            println("back")
        })
    }
    
    func getTitle(){
        
        println(self.theWebView.URL!)
        var urlString = "\(self.theWebView.URL!)"
        switch(urlString){
            case "https://checkout.twotap.com/#/order":
                println("order")
                theWebView.hidden = false
                replaceShippingAddress()
                setFrameForOrder()
            case "https://checkout.twotap.com/#/order/payment":
                setFrameForInfoForm()
            
            case "https://checkout.twotap.com/#/order/shipping":
                setFrameForInfoForm()
            
        default:
            break

        }

    }
    
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

class PassThroughView: UIView {
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        for subview in subviews as! [UIView] {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
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

