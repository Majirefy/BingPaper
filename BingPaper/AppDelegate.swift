//
//  AppDelegate.swift
//  BingPaper
//
//  Created by Peng Jingwen on 2015-03-13.
//  Copyright (c) 2015 Peng Jingwen. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    @IBOutlet weak var popover: NSPopover!

    
    private let statusbarview: StatusBarView;
    
    override init(){
        
        let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1);

        self.statusbarview = StatusBarView(imageName: "icon", item: statusItem);
        statusItem.view = statusbarview;

        super.init()
    }
    
    override func awakeFromNib(){
    
        let edge = NSMinYEdge
        let menu = self.statusbarview
        let rect = menu.frame
        
        menu.onMouseDown = {
            if (menu.isSelected){
                self.popover?.showRelativeToRect(rect, ofView: self.statusbarview, preferredEdge: edge);
                return
            }
            self.popover?.close()
        }

    }

}

