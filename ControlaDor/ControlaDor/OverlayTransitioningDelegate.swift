import UIKit

class OverlayTransitioningDelegate : NSObject, UIViewControllerTransitioningDelegate {
  
  func presentationControllerForPresentedViewController(presented: UIViewController,
                        presentingViewController presenting: UIViewController,
                        sourceViewController source: UIViewController) -> UIPresentationController? {
    
    return OverlayPresentationController(presentedViewController: presented,
                                         presentingViewController: presenting)
  }
  
  func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController)-> UIViewControllerAnimatedTransitioning? {

    return BouncyViewControllerAnimator()
  }
  
}
