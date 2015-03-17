//
//  MenuViewController.swift
//  BingPaper
//
//  Created by Peng Jingwen on 2015-03-13.
//  Copyright (c) 2015 Peng Jingwen. All rights reserved.
//

import Cocoa

class MenuViewController: NSViewController {

    var isAutoChangeOn: Bool = true;
    var isDockIconOn: Bool = true;
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.sharedApplication().terminate(nil)
    }
    
    @IBAction func today(sender: NSButton) {
        self.fetchAndChangeWallpaper()
    }
    
    @IBAction func toggleAutoChange(sender: NSButton) {
        if sender.state == 1 {
            self.isAutoChangeOn = true;
            
        } else {
            self.isAutoChangeOn = false;
        }
    }
    
    @IBAction func toggleDockIcon(sender: NSButton) {
        
        if sender.state == 1 {
            self.isDockIconOn = true
            NSApp.setActivationPolicy(NSApplicationActivationPolicy.Regular)
            
        } else {
            self.isDockIconOn = false
            NSApp.setActivationPolicy(NSApplicationActivationPolicy.Accessory)
        }
    }
    
    func fetchAndChangeWallpaper(){
        
        var netRequest = NSMutableURLRequest()
        netRequest.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
        netRequest.timeoutInterval = 5
        netRequest.HTTPMethod = "GET"
        netRequest.URL = NSURL(string: "http://www.bing.com/HpImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN")
        var reponseData = NSURLConnection.sendSynchronousRequest(netRequest, returningResponse: nil, error: nil)
        
        if let dataValue = reponseData {
            var err: NSError?
            var dataObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(
                dataValue,
                options: NSJSONReadingOptions.allZeros,
                error: &err
            );
            
            if err == nil {
                
                if let jsonObject: AnyObject = dataObject?.valueForKey("images") {
                    
                    var imageNetRequest = NSMutableURLRequest()
                    imageNetRequest.cachePolicy = NSURLRequestCachePolicy.UseProtocolCachePolicy
                    imageNetRequest.timeoutInterval = 5
                    imageNetRequest.HTTPMethod = "GET"
                    imageNetRequest.URL = NSURL(string: jsonObject[0].valueForKey("url")! as String)
                    
                    var imageResponData = NSURLConnection.sendSynchronousRequest(imageNetRequest, returningResponse: nil, error: nil)
                    
                    var path = NSHomeDirectory() + "/Library/Caches/org.prettyx.mac.BingPaper/current_wallpaper"
                    
                    imageResponData?.writeToFile(path, atomically: true)
                    
                    NSWorkspace.sharedWorkspace().setDesktopImageURL(
                        NSURL(fileURLWithPath: path)!,
                        forScreen: NSScreen.screens()?.last as NSScreen,
                        options: nil,
                        error: nil
                    )
                }
            }
        }

    }
}
