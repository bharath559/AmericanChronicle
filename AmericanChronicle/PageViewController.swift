//
//  PageViewController.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/8/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bottomBarBG: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func shareButtonTapped(sender: AnyObject) {
    }

    override func viewDidLayoutSubviews() {
        if let imageWidth = imageView.image?.size.width where imageWidth > 0 {
            scrollView.zoomScale = scrollView.frame.size.width / imageWidth
        } else {
            scrollView.zoomScale = 1.0
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

//    optional func scrollViewDidScroll(scrollView: UIScrollView) // any offset changes

//    @availability(iOS, introduced=3.2)
//    optional func scrollViewDidZoom(scrollView: UIScrollView) // any zoom scale changes
//

//    // called on start of dragging (may require some time and or distance to move)
//    optional func scrollViewWillBeginDragging(scrollView: UIScrollView)

//    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
//    @availability(iOS, introduced=5.0)
//    optional func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)

//    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
//    optional func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)

//
//    optional func scrollViewWillBeginDecelerating(scrollView: UIScrollView) // called on finger up as we are moving

//    optional func scrollViewDidEndDecelerating(scrollView: UIScrollView) // called when scroll view grinds to a halt
//
//    optional func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) // called when setContentOffset/scrollRectVisible:animated: finishes. not called if not animating
//
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }

//    @availability(iOS, introduced=3.2)
//    optional func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView!) // called before the scroll view begins zooming its content

//    optional func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) // scale between minimum and maximum. called after any 'bounce' animations
//
//    optional func scrollViewShouldScrollToTop(scrollView: UIScrollView) -> Bool // return a yes if you want to scroll to the top. if not defined, assumes YES
//    optional func scrollViewDidScrollToTop(scrollView: UIScrollView) // called when scrolling animation finished. may be called immediately if already at top
}