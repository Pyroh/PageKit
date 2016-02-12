//
//  PagedViewCollectionControllerDelegate.swift
//  Mandala Tests
//
//  Created by Pierre TACCHI on 10/02/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import Cocoa

@available(OSX 10.10, *)
@objc public protocol PagedViewCollectionControllerDelegate {
    /**
     Informs the delegate that the controller will transition forward to page of index `index`.
     
     - parameter controller:            The paged view collection controller that will change page.
     - parameter index:                 The page's index the controller will transition to.
     - parameter sourceController:      The currently selected view controller.
     - parameter destinationController: The next to be selected view controller.
     */
    optional func pagedController(controller: PagedViewCollectionController,
        willTransitionForwardToIndex index: Int,
        from sourceController: NSViewController,
        to destinationController: NSViewController)
    
    /**
     Informs the delegate that the controller will transition backward to page of index `index`.
     
     - parameter controller:            The paged view collection controller that will change page.
     - parameter index:                 The page's index the controller will transition to.
     - parameter sourceController:      The currently selected view controller.
     - parameter destinationController: The next to be selected view controller.
     */
    optional func pagedController(controller: PagedViewCollectionController,
        willTransitionBackwardToIndex index: Int,
        from sourceController: NSViewController,
        to destinationController: NSViewController)
    
    /**
     Invoked after the controller did transiton forward to page of index `index`.
     
     - parameter controller:            The paged view collection controller that changed page.
     - parameter index:                 The page's index the controller did transition to.
     - parameter sourceController:      The previously selected view controller.
     - parameter destinationController: The currently selected view controller.
     */
    optional func pagedController(controller: PagedViewCollectionController,
        didTransitionForwardToIndex index: Int,
        from sourceController: NSViewController,
        to destinationController: NSViewController)
    
    /**
     Invoked after the controller did transiton backward to page of index `index`.
     
     - parameter controller:            The paged view collection controller that changed page.
     - parameter index:                 The page's index the controller did transition to.
     - parameter sourceController:      The previously selected view controller.
     - parameter destinationController: The currently selected view controller.
     */
    optional func pagedController(controller: PagedViewCollectionController,
        didTransitionBackwardToIndex index: Int,
        from sourceController: NSViewController,
        to destinationController: NSViewController)
    
    /**
     Invoked before the controller will transition to first page.
     
     - parameter controller: The paged view collection controller that will go to the home page.
     */
    optional func pagedControllerWillReturnHome(controller: PagedViewCollectionController)
    
    /**
     Invoked before the controller will transition to first page.
     
     - parameter controller: The paged view collection controller that went to the home page.
     */
    optional func pagedControllerDidReturnHome(controller: PagedViewCollectionController)
}