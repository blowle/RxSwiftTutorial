//
//  ColorfullBallVC.swift
//  RxSwiftStudy
//
//  Created by Dev on 2021/03/15.
//

import UIKit

/*
 * We will create simple app that will connect ball color with position in view
 * and also we will connect view's background color with the ball color.
 
 */

class ColorfullBall: UIViewController {
    
    var circleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        // Add circle view
        circleView = UIView(frame: CGRect(origin: view.center, size: CGSize(width: 100, height: 100)))
        circleView.layer.cornerRadius = circleView.frame.width / 2.0
        circleView.center = view.center
        circleView.backgroundColor = .green
        
        view.addSubview(circleView)
        
        // Add gesture recognizer
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func circleMoved(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }
    
}
