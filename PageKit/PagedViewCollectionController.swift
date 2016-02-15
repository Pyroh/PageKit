//
//  PagedViewController.swift
//  Mandala Tests
//
//  Created by Pierre TACCHI on 10/02/16.
//  Copyright © 2016 Pyrolyse. All rights reserved.
//

import Cocoa
/**
 Self explenatory
 */
internal func called(fct: String = __FUNCTION__) {
    print("\(NSDate()): \(fct) called.")
}

@available(OSX 10.10, *)
@IBDesignable public class PagedViewCollectionController: NSTabViewController {
    /**
     Animations for view transitions in a paged view collection controller.
     
     - None:          A transition with no animation.
     - Crossfade:     A transition animation that fades the new view in and simultaneously fades the old view out.
     - SlideUp:       A transition animation that slides the old view up while the new view comes into view from the bottom. In other words, both views slide up.
     - SlideDown:     A transition animation that slides the old view down while the new view slides into view from the top. In other words, both views slide down.
     - SlideLeft:     A transition animation that slides the old view to the left while the new view slides into view from the right. In other words, both views slide to the left.
     - SlideRight:    A transition animation that slides the old view to the right while the new view slides into view from the left. In other words, both views slide to the right.
     - SlideForward:  A transition animation that reflects the user interface layout direction (`userInterfaceLayoutDirection`) in a “forward” manner, as follows:
        - For left-to-right user interface layout direction, the `SlideLeft` animation.
        - For right-to-left user interface layout direction, the `SlideRight` animation.
     - SlideBackward: A transition animation that reflects the user interface layout direction (`userInterfaceLayoutDirection`) in a “backward” manner, as follows:
        - For left-to-right user interface layout direction, the `SlideRight` animation.
        - For right-to-left user interface layout direction, the `SlideLeft` animation.
     */
    public enum Transition {
        case None
        case Crossfade
        case SlideUp
        case SlideDown
        case SlideLeft
        case SlideRight
        case SlideForward
        case SlideBackward
        
        private func option() -> NSViewControllerTransitionOptions {
            switch self {
            case .None:
                return .None
            case .Crossfade:
                return .Crossfade
            case .SlideUp:
                return .SlideUp
            case .SlideDown:
                return .SlideDown
            case .SlideLeft:
                return .SlideLeft
            case .SlideRight:
                return .SlideRight
            case .SlideForward:
                return .SlideForward
            case .SlideBackward:
                return .SlideBackward
            }
        }
    }
    
    private enum Direction {
        case Forward
        case Backward
        case Home
    }
    
    @IBOutlet public weak var delegate: PagedViewCollectionControllerDelegate?
        /// The navigation delegate which tells the paged collection controller how to deal with its page navigation view.
        /// 
        /// This delegate have the highest priority. That means that any of the object property related to the page navigation controller will be overrided by the values found in the delegate. If the delegate doen't provide any usable value the paged view controller will then use its own properties.
    @IBOutlet public weak var navigationDelegate: PagedViewCollectionNavigationDelegate? {
        didSet { manageNavigationViewController() }
    }
    
        /// Tell the controller if it should animate transiton to next page.
        /// - remark: The default value is `SlideForward`
    public var forwardTransition: Transition = .SlideForward
        /// Tell the controller if it should animate transiton to previous page.
        /// - remark: The default value is `SlideBackward`
    public var backwardTransition: Transition = .SlideBackward
        /// Tell the controller if it should animate transiton back to the first page.
        /// - remark: The default value is `Crossfade`
    public var homeTransition: Transition = .Crossfade
        /// If `true` the default page navigation controller will be used. No page navigation controller will be used otherwise.
        /// - remark: The default value is `false`
    @IBInspectable public var usePageNavigationController: Bool = false {
        didSet { manageNavigationViewController() }
    }
        /// If displayed set the position of the page navigation view.
        /// - remark: The default value is `Top`
    public var navigationViewPosition: PageNavigationViewController.Position = .Top
        /// The page navigation controller that will be embeded in each page view.
        ///
        /// This property has a higher priority than the `navigationID` one. Whatever you set here will be used regardless any other properties except the navigation delegate.
        /// - note: Setting this property will embed a page navigation controller regardless the value of `usePageNavigationController`.
    public var navigationController: PageNavigationViewController? {
        didSet { manageNavigationViewController() }
    }
        /// The navigation controller's storyboard ID.
        ///
        /// Use this property in order to load the page navigation controller you want to ambed in each page view. If `navigationController` is set this property will be ignored.
        /// - note: Setting this property will embed a page navigation controller regardless the value of `usePageNavigationController`.
    @IBInspectable public var navigationId: String? {
        didSet { manageNavigationViewController() }
    }
        /// The name of the storyboard containing the navigation controller.
        /// 
        /// If `nil` the page navigation controller will try to be loaded from the receiver's storyboard.
    @IBInspectable public var navigationStorybardId: String? {
        didSet { manageNavigationViewController() }
    }
        /// `true` if the current page has a next page. `false` otherwise.
    public dynamic var canGoForward: Bool {
        return selectedTabViewItemIndex < tabViewItems.count - 1
    }
        /// `true` if the current page has a previous page. `false` otherwise.
    public dynamic var canGoBackward: Bool {
        return selectedTabViewItemIndex > 0
    }
        /// `true` if the current page is not the home page. `false` otherwise.
    public dynamic var canGoHome: Bool {
        return canGoBackward
    }
        /// The current page index.
    public dynamic var currentPageIndex: Int {
        return selectedTabViewItemIndex
    }
        /// Return the number of pages.
    public dynamic var pageCount: Int {
        return tabViewItems.count
    }
    
    private var userInteraction: Bool = false
    private var useNavigation: Bool = false
    private var actualNavigationController: PageNavigationViewController?
    private var stackView: NSStackView?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        tabView.delegate = self
        tabStyle = .Unspecified
        tabView.tabViewType = .NoTabsNoBorder
        userInteraction = transitionOptions.contains(.AllowUserInteraction)
        installStackView()
        manageNavigationViewController()
        if canPropagateSelectedChildViewControllerTitle, let title = tabView.selectedTabViewItem?.viewController?.title {
            tabView.window?.title = title
        }
    }
    
    public override func swipeWithEvent(event: NSEvent) {
        print(event)
    }
    
    public override func tabView(tabView: NSTabView, didSelectTabViewItem tabViewItem: NSTabViewItem?) {
        super.tabView(tabView, didSelectTabViewItem: tabViewItem)
        if canPropagateSelectedChildViewControllerTitle, let title = tabViewItem?.viewController?.title {
            tabView.window?.title = title
        }
    }
    
    /**
     Display next page if there's any.
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goForward(sender: AnyObject?) {
        if canGoForward {
            forward()
        }
    }
    
    /**
     Display previous page if there's any
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goBackward(sender: AnyObject?) {
        if canGoBackward {
            backward()
        }
    }
    
    /**
     Return to home page.
     
     - parameter sender: The object that iniated the action.
     */
    @IBAction public final func goHome(sender: AnyObject?) {
        home()
    }
    
    
    
    private func forward() {
        guard canGoForward else { return }
        let nextIndex = selectedTabViewItemIndex + 1
        let currentController = tabViewItems[selectedTabViewItemIndex].viewController!
        let nextController = tabViewItems[nextIndex].viewController!
        delegate?.pagedController?(self, willTransitionForwardToIndex: nextIndex, from: currentController, to: nextController)
        setTransition(.Forward)
        selectedTabViewItemIndex += 1
        delegate?.pagedController?(self, didTransitionForwardToIndex: nextIndex, from: currentController, to: nextController)
    }
    
    private func backward() {
        guard canGoBackward else { return }
        let nextIndex = selectedTabViewItemIndex - 1
        let currentController = tabViewItems[selectedTabViewItemIndex].viewController!
        let nextController = tabViewItems[nextIndex].viewController!
        delegate?.pagedController?(self, willTransitionBackwardToIndex: nextIndex, from: currentController, to: nextController)
        setTransition(.Backward)
        selectedTabViewItemIndex -= 1
        delegate?.pagedController?(self, didTransitionBackwardToIndex: nextIndex, from: currentController, to: nextController)
    }
    
    private func home() {
        delegate?.pagedControllerWillReturnHome?(self)
        setTransition(.Home)
        selectedTabViewItemIndex = 0
        delegate?.pagedControllerDidReturnHome?(self)
    }
    
    private func setTransition(dir: Direction) {
        switch dir {
        case .Forward:
            transitionOptions = forwardTransition.option()
        case .Backward:
            transitionOptions = backwardTransition.option()
        case .Home:
            transitionOptions = homeTransition.option()
        }
        if userInteraction { transitionOptions.unionInPlace(.AllowUserInteraction) }
    }
    
    private func installStackView() {
        let superView = tabView.superview
        tabView.removeFromSuperview()
        stackView = NSStackView(views: [tabView])
        stackView?.orientation = .Vertical
        stackView?.spacing = 0.0
        
        superView?.addSubview(stackView!)
        if #available(OSX 10.11, *) {
            stackView?.topAnchor.constraintEqualToAnchor(superView?.topAnchor).active = true
            stackView?.bottomAnchor.constraintEqualToAnchor(superView?.bottomAnchor).active = true
            stackView?.leadingAnchor.constraintEqualToAnchor(superView?.leadingAnchor).active = true
            stackView?.trailingAnchor.constraintEqualToAnchor(superView?.trailingAnchor).active = true
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func manageNavigationViewController() {
        if let delegate = navigationDelegate {
            if let controller = delegate.navigationControllerForPagedController?(self) {
                loadNavigationViewController(controller)
                return
            }
        }
        if let controller = navigationController {
            loadNavigationViewController(controller)
            return
        }
        if let id = navigationId {
            let navsb: NSStoryboard? = navigationStorybardId.flatMap({NSStoryboard(name: $0, bundle: nil)}) ?? storyboard
            if let controller = navsb?.instantiateControllerWithIdentifier(id) as? PageNavigationViewController {
                loadNavigationViewController(controller)
                return
            }
        }
        if usePageNavigationController, let controller = PageNavigationViewController(nibName: nil, bundle: NSBundle(identifier: "com.pyrolyse.PageKit")) {
            loadNavigationViewController(controller)
            return
        }
        unloadNavigationViewController()
    }
    
    private func loadNavigationViewController(controller: PageNavigationViewController) {
        actualNavigationController = controller
        controller.pagedController = self
        controller.loadView()
        let navigationView = controller.view
        
        switch navigationViewPosition {
        case .Top:
            stackView?.insertView(navigationView, atIndex: 0, inGravity: .Top)
        case .Bottom:
            stackView?.addView(navigationView, inGravity: .Bottom)
        }
    }
    
    private func unloadNavigationViewController() {
        called()
        guard let ctrl = actualNavigationController else { return }
        stackView?.removeView(ctrl.view)
        actualNavigationController = nil
    }
    
    public override class func keyPathsForValuesAffectingValueForKey(key: String) -> Set<String> {
        switch key {
        case "canGoForward", "canGoBackward", "currentPageIndex", "canGoHome":
            return Set(["selectedTabViewItemIndex"])
        case "pageCount":
            return Set(["tabViewItems"])
        default:
            return super.keyPathsForValuesAffectingValueForKey(key)
        }
    }
}
