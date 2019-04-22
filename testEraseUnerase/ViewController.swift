//
//  ViewController.swift
//  testEraseUnerase
//
//  Created by imedev4 on 18/04/2019.
//  Copyright © 2019 5W2H. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate{
    
    var container : UIView!
    var backgrounsImage : UIImageView!
    var TopImageView : UIImageView!
    var isErasing:Bool = true
    var currentPoint : CGPoint!
    var previusPoint : CGPoint!
    var context:CGContext!
    var topUIView:UIView!
    var rect:CGRect!
    var topImage:UIImage!
    var path = UIBezierPath()
    
    var beginX:CGFloat!
    var beginY:CGFloat!
    
    var lastRotation:CGFloat!//CGPoint!
    var rotationTransform:CGFloat! = 0.0
    
    
    var panGesture : UIPanGestureRecognizer?
    var rotationGesture : UIRotationGestureRecognizer!
    var pinchGesture : UIPinchGestureRecognizer!
    var isPinching:Bool = true
    
    var initialTransform : CGAffineTransform?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        container = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(container)
        
        
         backgrounsImage = UIImageView(frame: CGRect(x:0 , y: 0, width: view.frame.width, height: view.frame.height))
        backgrounsImage.image = UIImage(named: "4k")
        container.addSubview(backgrounsImage)
        
        topUIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        topUIView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        container.addSubview(topUIView)
        
        TopImageView = UIImageView(frame: CGRect(x:0 , y: 0, width: 300, height: 300))
        TopImageView.image = UIImage(named: "rose")
        TopImageView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        topUIView.addSubview(TopImageView)
        //container.addSubview(TopImageView)
        
        
        topImage = UIImage(named: "rose")
        
        
//        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
//        button.backgroundColor = UIColor.white
//        button.addTarget(self, action: #selector(ViewController.EraseOrUnerase(sender:)), for: .touchUpInside)
//        button.setTitle("Erase/Unerase", for: .normal)
//        self.container.addSubview(button)
        
        TopImageView.isUserInteractionEnabled = true
        container.isUserInteractionEnabled = true
        
        //initilize the gesture and the targer
        pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(ViewController.scale(sender:)))
        pinchGesture.delegate = self
        self.TopImageView.addGestureRecognizer(pinchGesture)
        
        //set the pan gesture to move
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.pan(sender:)))
        panGesture?.delegate = self
        panGesture?.minimumNumberOfTouches = 1
        panGesture?.maximumNumberOfTouches = 2
        self.TopImageView.addGestureRecognizer(panGesture!)
        
        //set the rotate gesture to rotate
        rotationGesture = UIRotationGestureRecognizer.init(target: self, action: #selector(ViewController.rotate(sender:)))
        rotationGesture?.delegate = self
        self.TopImageView.addGestureRecognizer(rotationGesture)
    }
    
    
    @objc func EraseOrUnerase(sender:UIButton){
        print("press if erasing or not")
        isErasing = !isErasing
        //let check =
        print(isErasing)
        
    }
    
    
   // TODO: touchesBegan
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touch began now ")
        }
    
    
   // TODO: touchesMoved
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touch is moving now ")
        }
    
    
    
   // TODO: touchesEnded
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        }
    
    
    //MARK: Set the Pan Function to move
    @objc func pan(sender : Any){
        //touchPointArray.removeAll()
        //if startCrooping == true  || isBackgroundMood == true { // &&
         //   isZooming = false
            if let sender = sender as? UIPanGestureRecognizer {
                //the main view
                // ContainerForBackgroundAndForegroundImage.isUserInteractionEnabled = true

                var newCenter = sender.translation(in: self.view)
                if(sender.state == .began){
                    print("now we are using pan")
                    beginX = TopImageView.center.x //topUIView
                    beginY = TopImageView.center.y //topUIView
                }
                newCenter = CGPoint.init(x: beginX + newCenter.x, y: beginY + newCenter.y)
                TopImageView.center = newCenter
                //sender.setTranslation(CGPoint.zero, in: self.view)


                //move the transfer view or the crop view
//                let getCropViewFramInViewCoordinate = cropView.convert(cropView.bounds, to: self.view)
//                let _ = calculateMaskLayer(maskLayer, cropRect: getCropViewFramInViewCoordinate)
                
//                let state: UIGestureRecognizer.State? = sender.state
//
//                if state == .began || state == .changed {
//                    let translation: CGPoint? = sender.translation(in: sender.view)
//                    sender.view?.transform = (sender.view?.transform.translatedBy(x: (translation?.x)!, y: (translation?.y)!))!
//                    sender.setTranslation(CGPoint.zero, in: sender.view)
//                }
                
            }
        
    }
    
    
    
    
    
    
    //MARK: Set the Rotate Function
    @objc func rotate(sender : Any){
        //touchPointArray.removeAll()
        //isZooming = true
        //if isTopMood == true {
            if let sender = sender as? UIRotationGestureRecognizer, let imageView = TopImageView { //TopImageUIImageView //self.EraseView //TopImageView
                if sender.state == .ended{
                    rotationTransform = sender.rotation
                    lastRotation = 0.0
                    return
                }
                let rotation : CGFloat = 0.0 - (lastRotation - sender.rotation)
                let currentTransform = imageView.transform
                let newTransform = currentTransform.rotated(by: rotation)
                imageView.transform = newTransform
                lastRotation = sender.rotation
                //                rotationTransform = sender.rotation
                
            }
       
    }
    
    
    
    // MARK: Set the ZoomIn and Out Function to move
    @objc func scale(sender : Any){
        //touchPointArray.removeAll()
         let sender = sender as? UIPinchGestureRecognizer
        print("pinching now started")
//        if let view = sender!.view {
//
//            view.transform = view.transform.scaledBy(x: sender!.scale, y: sender!.scale)
//            sender!.scale = 1
//        }
        //if startCrooping == true || isBackgroundMood == true{
          //  let sender = sender as? UIPinchGestureRecognizer
            if sender!.state == .began {
                //isPinching = true
                print("pinching now started")

                let currentScale = self.TopImageView.frame.size.width / self.TopImageView.bounds.size.width //ContainerForBackgroundAndForegroundImage
                var newScale = currentScale*sender!.scale
                print("The new scale ::: \(newScale)")
                if newScale > 1 {
//                    self.isZooming = true
//                    isPinching = true
                }
               // touchPointArray.removeAll()
            }
            else if sender?.state == .changed{
                print("pinching now changing")
                //point to the exact pinch point
                guard let view = sender?.view else {return} //view
                let pinchCenter = CGPoint(x: sender!.location(in: view).x - view.bounds.midX,
                                          y: sender!.location(in: view).y - view.bounds.midY)
                let transform = view.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: sender!.scale, y: sender!.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                let currentScale = self.TopImageView.frame.size.width / self.TopImageView.bounds.size.width //topUIView
                var newScale = currentScale*sender!.scale

                let currentScaleForBrishSize = self.TopImageView.frame.size.width / self.TopImageView.bounds.size.width
                var newScaleForBrishSize = currentScaleForBrishSize*sender!.scale




      // scale
                if newScale < 1 {
                    print("pinching now new scale less than 1")
                    self.TopImageView.transform = transform //topUIView //ContainerForBackgroundAndForegroundImage
                    newScale = 1.0
                    //let transform = CGAffineTransform(scaleX: newScale, y: newScale)
                    sender!.scale = 1.0
                }else {
                    print("pinching now larger than 1")

                    TopImageView.transform = transform//topUIView//ContainerForBackgroundAndForegroundImage
                    //self.TopImageView.transform = transform
                    //view.transform = transform
                    sender!.scale = 1.0

                }


            } else if sender!.state == .ended {
                print("pinching now end")
                sender!.scale = 1.0

            }
        }
    
    }


