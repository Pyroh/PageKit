//
//  NavigationViewController.swift
//  Mandala Tests
//
//  Created by Pierre TACCHI on 10/02/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
public class PageNavigationViewController: NSViewController {
    public enum Position {
        case Top
        case Bottom
    }
        /// `true` if the current page has a next page. `false` otherwise.
    public dynamic var canGoForward: Bool = true
        /// `true` if the current page has a previous page. `false` otherwise.
    public dynamic var canGoBackward: Bool = true
        /// `true` if the current page is not the home page. `false` otherwise.
    public dynamic var canGoHome: Bool = true
        /// The current page index.
    public dynamic var currentPageIndex: Int = 0
        /// Return the number of pages.
    public dynamic var pageCount: Int = 0
    
    internal dynamic weak var pagedController: PagedViewCollectionController!
    
    public override func viewDidLoad() {
        bind("canGoForward", toObject: pagedController, withKeyPath: "canGoForward", options: nil)
        bind("canGoBackward", toObject: pagedController, withKeyPath: "canGoBackward", options: nil)
        bind("canGoHome", toObject: pagedController, withKeyPath: "canGoHome", options: nil)
        bind("currentPageIndex", toObject: pagedController, withKeyPath: "currentPageIndex", options: nil)
        bind("pageCount", toObject: pagedController, withKeyPath: "pageCount", options: nil)
    }
    
    deinit {
        unbind("canGoForward")
        unbind("canGoBackward")
        unbind("canGoHome")
        unbind("currentPageIndex")
        unbind("pageCount")
    }
    
    /**
     Display next page if there's any.
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goForward(sender: AnyObject?) {
        pagedController.goForward(sender)
    }
    
    /**
     Display previous page if there's any
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goBackward(sender: AnyObject?) {
        pagedController.goBackward(sender)
    }
    
    /**
     Return to home page.
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goHome(sender: AnyObject?) {
        pagedController.goHome(sender)
    }
}
