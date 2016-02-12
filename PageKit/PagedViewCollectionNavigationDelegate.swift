//
//  PagedViewCollectionNavigationDelegate.swift
//  Mandala Tests
//
//  Created by Pierre TACCHI on 11/02/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import Foundation

@available(OSX 10.10, *)
@objc public protocol PagedViewCollectionNavigationDelegate {
    /**
     - TODO: documention
     */
    optional func pagedControllerUsesPageNavigationController(controller: PagedViewCollectionController) -> Bool
    
    /**
     Returns the storyboard ID of the page navigation controller for the paged controller.
     
     - parameter controller: The paged view collection controller that will embed the page navigation view.
     
     - returns: The storyboard ID of the page navigation controller.
     */
    optional func navigationControllerIDForPagedController(controller: PagedViewCollectionController) -> String
    
    /**
     Returns the name of the storyboard that contains the
     
     - parameter controller: The paged view collection controller that will embed the page navigation view.
     
     - returns: The name of the storyboard that contains the page navigation controller.
     */
    optional func navigationControllerStoryboardIDForPagedController(controller: PagedViewCollectionController) -> String
    
     /**
     Returns the page navigation controller.
     
     - parameter controller: The paged view collection controller that will embed the page navigation view.
     
     - returns: The page navigation controller.
     */
    optional func navigationControllerForPagedController(controller: PagedViewCollectionController) -> PageNavigationViewController
}