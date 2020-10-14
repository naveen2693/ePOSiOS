//
//  BottomSheetViewController.swift
//  PinePG
//
//  Created by Matra Sharma on 16/09/20.
//  Copyright © 2020 Pinelabs. All rights reserved.
//

import UIKit



extension BottomSheetViewController {
    enum State {
        case partial
        case full
    }
    
//    private enum Constant {
//        var fullViewYPosition: CGFloat { return UIScreen.main.bounds.height - requiredMaxHeight }
//        var partialViewYPosition: CGFloat { return UIScreen.main.bounds.height - 60 }
//    }
}


class BottomSheetViewController: UIViewController {
    weak var optionDelegate: DropDownOptionsSelectedDelegate?
    var requiredMaxHeight: CGFloat = 350
    var dismissDone: Bool = false
    
    var fullViewYPosition : CGFloat {
        return UIScreen.main.bounds.height - requiredMaxHeight
    }
    
    var partialViewYPosition : CGFloat {
        return UIScreen.main.bounds.height - 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        gesture.cancelsTouchesInView = false
        view.addGestureRecognizer(gesture)
        view.clipsToBounds = true
        roundViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.4, animations: {
            self.moveView(state: .full)
        })
    }
    
    
    private func moveView(state: State) {
        let yPosition = state == .partial ? partialViewYPosition : fullViewYPosition
        view.frame = CGRect(x: 0, y: yPosition, width: view.frame.width, height: view.frame.height)
        if yPosition == partialViewYPosition && !dismissDone {
            dismissSheet()
        }
    }
    
    private func moveView(panGestureRecognizer recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= fullViewYPosition) && (minY + translation.y <= partialViewYPosition) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        moveView(panGestureRecognizer: recognizer)
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {
                let state: State = recognizer.velocity(in: self.view).y >= 0 ? .partial : .full
                self.moveView(state: state)
            }, completion: nil)
        }
    }
    
    func roundViews() {
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    func addOverlayTo(controller : UIViewController) {
        let overlayView = UIView.init(frame: controller.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.tag = 11111;
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        overlayView.addGestureRecognizer(tap)
        
        controller.view.addSubview(overlayView)
        controller.view.bringSubviewToFront(overlayView)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        dismissSheet()
    }
    
    func dismissSheet() {
        dismissDone = true
//        let notification = Notification.Name(notification_bottomSheetDismissed)
//        NotificationCenter.default.post(name: notification, object: nil)
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.moveView(state: .partial)
        }, completion: { [weak self] finished in
            if let parent = self?.parent {
                if let bgView = parent.view.viewWithTag(11111) {
                    bgView.removeFromSuperview()
                }
            }
            self?.view.removeFromSuperview()
            self?.removeFromParent()
            self?.willMove(toParent: nil)
        })
        
    }
    
}



