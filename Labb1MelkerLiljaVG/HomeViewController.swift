//
//  HomeViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-20.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var titleView: UIView!
    
    var animator: UIDynamicAnimator!
    var gravity: UIDynamicBehavior!
    var collision : UICollisionBehavior!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dynamics()
    }
    
    @IBAction func startBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 1.0, animations: {
        // Animera här
            self.startBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }) { (finished: Bool) in
        // Körs när animationen är färdig
        UIView.animate(withDuration: 1.0) {
            self.startBtn.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2)
            
        }
        }
    }
    
    func dynamics() {
        animator = UIDynamicAnimator(referenceView: titleView)
        gravity = UIGravityBehavior(items: [titleLabel])
        collision = UICollisionBehavior(items: [titleLabel])
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        animator.addBehavior(gravity)
    }
    
}
