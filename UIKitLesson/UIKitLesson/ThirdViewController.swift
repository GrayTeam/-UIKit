//
//  ThirdViewController.swift
//  UIKitLesson
//
//  Created by Alexander on 08.11.2019.
//  Copyright © 2019 DK. All rights reserved.
//

import UIKit

class ThirdViewControler: UIViewController {

    let circle: GradientView = {
        let view = GradientView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        view.colors = [.yellow, .red]
//        view.colors = [.blue, .systemBlue, .green, .yellow, .orange, .red]
        view.layer.cornerRadius = 50
        view.isUserInteractionEnabled = false
        return view
            }()

    override func loadView() {
        let gradientView = GradientView()
        gradientView.colors = [.cyan, .red]
        view = gradientView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Third VC"
        view.backgroundColor = .white
        view.addSubview(circle)
        circle.isHidden = true
    
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(viewTapped(sender:)))
        
        let downSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC(sender:)))
        
        downSwipeGestureRecognizer.direction = .down
        panGestureRecognizer.require(toFail: downSwipeGestureRecognizer)
        view.addGestureRecognizer(downSwipeGestureRecognizer)
        view.addGestureRecognizer(panGestureRecognizer)

        
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    

    @objc
    func dismissVC(sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc
    func viewTapped(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let position = sender.location(in: view)
            circle.center = position
            circle.isHidden = false
//            circle.isUserInteractionEnabled = false
            let colorBot = view.getColourFromPoint(point: position, side: circle.frame.height / 2 + 1)
            let colorTop = view.getColourFromPoint(point: position, side: -circle.frame.height / 2 - 1)
            
            circle.colors = [colorTop,colorBot]
            
        }
    }
    
    
    
    
}


extension UIView {
    func getColourFromPoint(point:CGPoint, side: CGFloat) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo.RawValue(CGImageAlphaInfo.premultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGContext(data: &pixelData, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo)
        context!.translateBy(x: -point.x , y: -point.y + side);
        self.layer.render(in: context!)
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}
