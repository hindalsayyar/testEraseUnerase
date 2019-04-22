//
//  ViewController.swift
//  testEraseUnerase
//
//  Created by imedev4 on 18/04/2019.
//  Copyright © 2019 5W2H. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate{
    
    var container : UIView!
    var topScrollerView:UIScrollView!
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
    
    var lastRotation : CGFloat = 0.0
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
        
        
        
        
        topScrollerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        topScrollerView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        //container.addSubview(topUIView)
        topScrollerView.delegate = self
        view.addSubview(topScrollerView)
        
        topScrollerView.minimumZoomScale = 0.1
        topScrollerView.maximumZoomScale = 500.0
        topScrollerView.isScrollEnabled = false
        //topScrollerView.bouncesZoom = true
        topScrollerView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        
        
        topUIView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300)) //width: view.frame.width, height: view.frame.height)
        //topUIView.clipsToBounds = true
        //topUIView.backgroundColor = UIColor.blue.withAlphaComponent(0.4)
        //container.addSubview(topUIView)
        topScrollerView.addSubview(topUIView)
       
        
        TopImageView = UIImageView(frame: CGRect(x:0 , y: 0, width: 300, height: 300))
        TopImageView.image = UIImage(named: "rose")
        TopImageView.backgroundColor = UIColor.red.withAlphaComponent(0.4)
        topUIView.addSubview(TopImageView)
        //container.addSubview(TopImageView)
        
        
        topImage = UIImage(named: "rose")
        
        
         topScrollerView.contentSize = topImage.size //.init(width: 2000, height: 2000)
        
        
        let button = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 100))
        button.backgroundColor = UIColor.white
        button.addTarget(self, action: #selector(ViewController.EraseOrUnerase(sender:)), for: .touchUpInside)
        button.setTitle("Erase/Unerase", for: .normal)
        self.container.addSubview(button)
        
        TopImageView.isUserInteractionEnabled = true
        container.isUserInteractionEnabled = true
        
        //initilize the gesture and the targer
        pinchGesture = UIPinchGestureRecognizer.init(target: self, action: #selector(ViewController.scale(sender:)))
        pinchGesture.delegate = self
        //self.TopImageView.addGestureRecognizer(pinchGesture)
        //self.topScrollerView.addGestureRecognizer(pinchGesture)
        
        //set the pan gesture to move
        panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(ViewController.pan(sender:)))
        panGesture?.delegate = self
        panGesture?.minimumNumberOfTouches = 1
        panGesture?.maximumNumberOfTouches = 2
        //self.TopImageView.addGestureRecognizer(panGesture!)
        self.topScrollerView.addGestureRecognizer(panGesture!)
        
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
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.TopImageView//TopImageView
            //self.topUIView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        print("scroll View Did Zoom")
        
        let testViewSize = TopImageView.bounds.size  //self.topUIView
        let scrollViewSize = topScrollerView.bounds.size
        
        let verticalPadding = testViewSize.height < scrollViewSize.height ? (scrollViewSize.height - testViewSize.height) / 2 : 0
        let horizontalPadding = testViewSize.width < scrollViewSize.width ? (scrollViewSize.width - testViewSize.width) / 2 : 0
        
        topScrollerView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer == pinchGesture && otherGestureRecognizer == topScrollerView.pinchGestureRecognizer
        

    }
    
    
    
    
    
    
    
    
    
    
   // TODO: touchesBegan
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touch began now ")
//            let touchCount = event?.touches(for: self.topScrollerView)?.count
//            let imageViewCount = event?.touches(for: self.TopImageView)?.count
//            print("There is 2 fingers: in begin\(touchCount)")
//            print("There is 2 fingers: in begin\(imageViewCount)")
//
//            if isPinching == false {
//                print("not pinching now ,,,,, check your code")
//                if touches.count < 2 {
//                    if let touch = touches.first as UITouch?{
//                        let touchPoint = touch.location(in: self.TopImageView)//self.foregroundImage
//                       // if startCrooping == true { TopImageView
//                            previusPoint = touchPoint
//                            print("touch begin to : \(touchPoint)")
//                      //  }
//                    }
//                }
//
//            }
        }
    
    
   // TODO: touchesMoved
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            print("touch is moving now ")
//            if isPinching == false {
//           // swiped = true
//            let touchCount = event?.touches(for: self.topScrollerView)?.count
//            print("There is 2 fingers: in moves\(String(describing: touchCount))")
//            if let touch = touches.first as UITouch?{
//
//                let touchPoint = touch.location(in: self.TopImageView)//foregroundImage //self.view
//                currentPoint = touchPoint
//              //  if startCrooping == true {
//                   // let points = [lastTouch,currentTouch]
//                    // touchPointArray.append(points as! [CGPoint])
//                    // print("How many touches we have :::\(touchPointArray.count)")
//                    // print("check the result of the array \(touchPointArray)")
//                    print("touch moved to : \(touchPoint)")
//                   // if touchCount != nil && touchCount! == 1{
//                        self.path.move(to: touchPoint)
//                        self.path.addLine(to: touchPoint)
//                        self.addNewPathToImage()
//                  //  }
//               // }
//
//                previusPoint = currentPoint
//                }
//            }
        }
    
    
    
   // TODO: touchesEnded
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//            //if startCrooping == true {
//            if isPinching == false {
//            let touchCount = event?.touches(for: self.topScrollerView)?.count
//            print("There is 2 fingers: in ends\(touchCount)")
//            if touches.count < 2{
//                if let touch = touches.first as UITouch?{
//                    let touchPoint = touch.location(in:self.TopImageView ) //self.foregroundImage
//                    print("touch ended at : \(touchPoint)")
//                  //  if startCrooping == true {
//                       // if touchCount != nil && touchCount! == 1{
//                            path.addLine(to: touchPoint)
//                            addNewPathToImage()
//                      //  }
//                        path.close()
//                        path.removeAllPoints()
//                    }
//                }
//            }
    
        }
    
    
    
    //MARK: Set the Pan Function to move
    @objc func pan(sender : Any){
            if let sender = sender as? UIPanGestureRecognizer {

                var newCenter = sender.translation(in: self.view)
                if(sender.state == .began){
                    print("now we are using pan")
                    beginX = topUIView.center.x //topUIView //TopImageView
                    beginY = topUIView.center.y //topUIView //TopImageView
                }
                newCenter = CGPoint.init(x: beginX + newCenter.x, y: beginY + newCenter.y)
                topUIView.center = newCenter

                
            }
        
    }
    
    
    
    
    
    
    //MARK: Set the Rotate Function
    @objc func rotate(sender : Any){
            if let sender = sender as? UIRotationGestureRecognizer, let imageView = topUIView{ //TopImageUIImageView //self.EraseView //TopImageView //TopImageView
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
                
            }
       
    }
    
    
    
    // MARK: Set the ZoomIn and Out Function to move
    @objc func scale(sender : Any){
        //touchPointArray.removeAll()
         let sender = sender as? UIPinchGestureRecognizer
        print("pinching now started")
            if sender!.state == .began {
                //isPinching = true
                print("pinching now started")

                let currentScale = self.TopImageView.frame.size.width / self.TopImageView.bounds.size.width //ContainerForBackgroundAndForegroundImage
                var newScale = currentScale*sender!.scale
                print("The new scale ::: \(newScale)")
                if newScale > 1 {
                }
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
                    sender!.scale = 1.0

                }


            } else if sender!.state == .ended {
                print("pinching now end")
                sender!.scale = 1.0

            }
        }
    
    }


