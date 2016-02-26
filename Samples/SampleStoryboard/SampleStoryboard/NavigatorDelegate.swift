//
//  NavigatorDelegate.swift
//  SampleStoryboard
//
//  Created by Pierre TACCHI on 15/02/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import PageKit

public class NavigatorDelegate: NSObject, PagedViewCollectionNavigationDelegate {
    public func pagedControllerUsesPageNavigationController(controller: PagedViewCollectionController) -> Bool {
        return true
    }
}
