//
//  ViewController.swift
//  RiskyClick
//
//  Created by twodayslate on 10/7/14.
//  Copyright (c) 2014 twodayslate. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.
        
        println("starting")
        
        super.viewDidLoad()
        
        self.view = OverView(viewController: self)
        
        println("done")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


}

class OverView : UIView {
    var webView: WKWebView?
    var submitButton : UIButton?
    var getButtonBig : UIButton?
    var getNewButton : UIButton?
    var viewController : ViewController?
    
    init(viewController myViewController:ViewController) {
        super.init(frame: UIScreen.mainScreen().bounds)
        //let viewController = myViewController
        self.viewController = myViewController
        
        
        self.autoresizesSubviews = true
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        
        
        
        self.webView = WKWebView(frame: self.frame)
        self.webView?.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        self.addSubview(webView!)
        //self.loadURL("localhost");
        
        
        let submitButton = UIButton.buttonWithType(UIButtonType.ContactAdd) as UIButton
        submitButton.frame = CGRectMake(self.bounds.width - 50, self.bounds.height-50, 50, 50)
        submitButton.addTarget(self, action: "submitbuttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        submitButton.backgroundColor = UIColor.blackColor()
        submitButton.tintColor = UIColor.whiteColor()
        submitButton.autoresizingMask = UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        self.addSubview(submitButton)
        
        let getButtonBig = UIButton.buttonWithType(UIButtonType.System) as UIButton
        getButtonBig.frame = CGRectMake(self.bounds.width/2 - 150, self.bounds.height/2 - 100, 300, 100)
        getButtonBig.setTitle("Get Risky!", forState: UIControlState.Normal)
        getButtonBig.backgroundColor = UIColor.blackColor()
        getButtonBig.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        getButtonBig.addTarget(self, action: "getBigAction:", forControlEvents: UIControlEvents.TouchUpInside)
        getButtonBig.titleLabel?.font = UIFont.systemFontOfSize(32.0)
        getButtonBig.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleTopMargin
        
        self.addSubview(getButtonBig)
        
        
        
        
        println("request loaded")
    }

    required init(coder aDecoder: NSCoder) {
        super.init()
    }
    
    func getURL() -> String {
        
        var urlString = "http://zac.gorak.us/riskyclick/get.php" // Your Normal URL String
        var url = NSURL.URLWithString(urlString)// Creating URL
        var request = NSURLRequest(URL: url)// Creating Http Request
        var err: NSError?
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &err)?
        var ans = ""
        
        if err != nil {
            println(err)
        } else {
            var jsonResult : Dictionary = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &err) as Dictionary<String, AnyObject>
            
            if let error = err {
                println("error occurred: \(error.localizedDescription)")
            }
            
            var result: String? = jsonResult["url"] as AnyObject? as? String
            ans = result!
            
        }
        
        if ans == "" {
            ans = "http://twitter.com/twodayslate"
        }
        
        
        println(ans)
        
        
        return ans
    }
    
    class func sendURL(url: String) -> String {
        
        var urlString = "http://zac.gorak.us/riskyclick/submit.php?url=" + url  // Your Normal URL String
        println("url = " + urlString)
        var url = NSURL.URLWithString(urlString)// Creating URL
        var request = NSURLRequest(URL: url)// Creating Http Request
        var err: NSError?
        var response: AutoreleasingUnsafeMutablePointer<NSURLResponse?> = nil
        var dataVal: NSData? =  NSURLConnection.sendSynchronousRequest(request, returningResponse: response, error: &err)?
        var ans = ""
        
        if err != nil {
            println(err)
        } else {
            var jsonResult : Dictionary = NSJSONSerialization.JSONObjectWithData(dataVal!, options: NSJSONReadingOptions.MutableContainers, error: &err) as Dictionary<String, AnyObject>
            
            if let error = err {
                println("error occurred: \(error.localizedDescription)")
            }
            
            println("result = " + jsonResult.description)
            
            var result: String? = jsonResult["valid"] as AnyObject? as? String
            ans = result!
            
        }
        
        if ans == "" {
            ans = "0"
        }
        
        
        println(ans)
        
        
        return ans
    }

    
    func submitbuttonAction(sender:UIButton!) {
        println("pressed");
        
        var alert = UIAlertController(title: "Add a link!", message: "It'll be someone else's risky click!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "http://"
        })
        
        alert.addAction(UIAlertAction(title: "Send", style: UIAlertActionStyle.Default, handler:{ alertAction in
            let textField : UITextField = alert.textFields![0] as UITextField
            println("sending " + textField.text)
            OverView.sendURL(textField.text)
            //alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        //println(viewController)
        
        viewController?.presentViewController(alert, animated: true, completion: nil)
        //.presentViewController(alert, animated: true, completion: nil)
    }
    
    func getBigAction(sender:UIButton!) {
        println("pressed BIG button");
        
        //println(self.getURL())
        
        let urld = NSURL(string: self.getURL())
        let req = NSURLRequest(URL: urld)
        
        self.webView?.loadRequest(req)
        
        sender.removeFromSuperview()
        
        let getNewButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
        getNewButton.frame = CGRectMake(0, self.bounds.height - 50, 50, 50)
        getNewButton.setTitle("new", forState: UIControlState.Normal)
        getNewButton.backgroundColor = UIColor.blackColor()
        getNewButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        getNewButton.addTarget(self, action: "getAction:", forControlEvents: UIControlEvents.TouchUpInside)
        getNewButton.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        self.addSubview(getNewButton)
    }
    
    func getAction(sender:UIButton!) {
        println("pressed small button");
        
        //println(self.getURL())
        
        let urld = NSURL(string: self.getURL())
        let req = NSURLRequest(URL: urld)
        
        self.webView?.loadRequest(req)
    }
    
    
    
    
    
}

