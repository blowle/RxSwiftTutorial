//
//  ColorfullBallVC.swift
//  RxSwiftStudy
//
//  Created by Dev on 2021/03/15.
//

import UIKit
import RxSwift
import RxCocoa
import ChameleonFramework

/*
 * We will create simple app that will connect ball color with position in view
 * and also we will connect view's background color with the ball color.
 
 */

class ColorfullBall: UIViewController {
    
    var circleViewModel: CircleViewModel = CircleViewModel()
    var circleView: UIView!
    let disposeBag = DisposeBag()
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
        
        // Bind the center point of the CircleView to the centerObservable
        circleView
            .rx.observe(CGPoint.self, "center")
            .bind(to: circleViewModel.centerVariable)
            .disposed(by: disposeBag)
        
        // Subscribe to backgroundColor to get new colors from the ViewModel
        circleViewModel.backgroundColorObservable.subscribe(onNext: {
          [weak self] backgroundColor in
            UIView.animate(withDuration: 0.1) {
                self?.circleView.backgroundColor = backgroundColor
//              Try to get complementary color for given background color
                let viewBackgroundColor = UIColor(complementaryFlatColorOf: backgroundColor)
//              If it is different that the color
                if viewBackgroundColor != backgroundColor {
//                  Assign it as a background color of the view
//                  We only want diffrent color to be able to see that circle in a view
                    self?.view.backgroundColor = viewBackgroundColor
                }
            }
        })
        .disposed(by: disposeBag)

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

class CircleViewModel {
    
    var centerVariable = BehaviorRelay<CGPoint?>(value: .zero) // Create one variable that will be change and observed.
    var backgroundColorObservable: Observable<UIColor>! // Create observable that will change backgroundColor based on center
    
    
    init() {
        setup()
    }
    
    
    func setup() {
        // When we get new center, emit new UIColor
        backgroundColorObservable = centerVariable.asObservable().map { center in
            guard let center = center else { return UIColor.flatten(.black)() }
                
            let red: CGFloat = ((center.x + center.y).truncatingRemainder(dividingBy: 255.0)) / 255.0
            let green: CGFloat = 0.0
            let blue: CGFloat = 0.0
            
            return UIColor.flatten(UIColor(red: red, green: green, blue: blue, alpha: 1.0))()
        }
    }
}
