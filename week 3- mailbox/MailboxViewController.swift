//
//  MailboxViewController.swift
//  week 3- mailbox
//
//  Created by Lauren Tindal on 10/26/16.
//  Copyright © 2016 Lauren Tindal. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var messageTray: UIImageView!
    
    @IBOutlet weak var laterIcon: UIImageView!
    @IBOutlet weak var checkIcon: UIImageView!
    @IBOutlet weak var laterView: UIImageView!
    @IBOutlet weak var archiveView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    @IBOutlet weak var messageFeed: UIImageView!
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var laterSection: UIImageView!
    @IBOutlet weak var archiveSection: UIImageView!
    @IBOutlet weak var inboxSection: UIView!
    
    var trayOriginalCenter: CGPoint!
    var traySwipeOffset: CGFloat!
    var traySwipeFromRight: CGPoint!
    var traySwipeFromLeft: CGPoint!
    var laterIconLeft: CGPoint!
    var checkIconLeft: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //assign values for moving the tray
        trayOriginalCenter = messageTray.center
        traySwipeOffset = 0
        traySwipeFromLeft = CGPoint(x: trayOriginalCenter.x + traySwipeOffset, y: trayOriginalCenter.y)
        traySwipeFromRight = CGPoint(x: trayOriginalCenter.x - traySwipeOffset, y: trayOriginalCenter.y)
        
        //assign values for icons moving
        laterIconLeft = laterIcon.center
        checkIconLeft = checkIcon.center
        
        //assign alpha for pop views
        listView.alpha = 0
        rescheduleView.alpha = 0
        archiveSection.isHidden = true
        laterSection.isHidden = true
        
        //this makes the view scroll
        scrollView.contentSize = CGSize(width: 320, height: 1294)
            }
    
    
    @IBAction func didPressSegment(_ sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            print("first selected");
            laterSection.alpha = 1;
            laterSection.isHidden = false
            archiveSection.isHidden = true
        case 1:
            print("second selected")
            laterSection.isHidden = true
            archiveSection.isHidden = true
        case 2:
            print("third selected")
            archiveSection.isHidden = false
            laterSection.isHidden = true
        default:
            break;
        }
    }

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            
            //this is defining a variable for the center of the tray
            trayOriginalCenter = messageTray.center
            
            
        } else if sender.state == .changed {
            
            //PAN FROM RIGHT, MOVING MESSAGE LEFT
            //as the user pans, change the center of the tray according to the translation
            messageTray.center = CGPoint(x: trayOriginalCenter.x + translation.x, y: trayOriginalCenter.y)
            
            //when the user first pans < 60 px, background is grey and has icon in a fixed location
            if messageTray.frame.origin.x < 0 {
                laterView.backgroundColor = UIColor.lightGray
                laterIcon.image = UIImage(named: "later_icon")
                laterIcon.alpha = 1
                checkIcon.alpha = 0
            }
            
            //when the user pans > 60 px, the icon moves with the pan
            if messageTray.frame.origin.x < -60  {
                laterIcon.frame.origin = CGPoint(x: laterIconLeft.x + translation.x+60, y: laterIconLeft.y-10)
                laterIcon.alpha = 1
                checkIcon.alpha = 0
            }
            
            //when the user pans past 60 px but under 260, background is yellow
            if messageTray.frame.origin.x < -60 && messageTray.frame.origin.x > -260 {
                laterView.backgroundColor = UIColor.yellow
                laterIcon.image = UIImage(named: "later_icon")
                laterIcon.alpha = 1
                checkIcon.alpha = 0

            }
            
            //when the user pans past 260 px, background is brown and icon changes to list
            if messageTray.frame.origin.x < -260 {
                laterView.backgroundColor = UIColor.brown
                laterIcon.image = UIImage(named: "list_icon")
                laterIcon.alpha = 1
                checkIcon.alpha = 0

            }
            
             //PAN FROM LEFT, MOVING MESSAGE RIGHT
            //as user pans > 60 px background again is grey
                if messageTray.frame.origin.x > 0 && messageTray.frame.origin.x < 60{
                    laterView.backgroundColor = UIColor.lightGray
                    laterIcon.alpha = 0
                    checkIcon.alpha = 1
                }
            
            //when the user pans > 60 px, the icon moves with the pan
            if messageTray.frame.origin.x > 60  {
                checkIcon.frame.origin = CGPoint(x: checkIconLeft.x + translation.x-60, y: checkIconLeft.y-7)
                checkIcon.alpha = 1
            }
            
            //when user pans past 60 px, background is green with icon
            if messageTray.frame.origin.x > 60 && messageTray.frame.origin.x < 260 {
                laterView.backgroundColor = UIColor.green
                checkIcon.image = UIImage(named: "archive_icon")
                laterIcon.alpha = 0
                checkIcon.alpha = 1
            }
            
            //when a user pans past 260 px, background is red with x icon
            if messageTray.frame.origin.x > 260 {
                laterView.backgroundColor = UIColor.red
                checkIcon.image = UIImage(named: "delete_icon")
                laterIcon.alpha = 0
                checkIcon.alpha = 1
            }
            

            }
            
    else if sender.state == .ended {
            
            if messageTray.frame.origin.x < -60 && messageTray.frame.origin.x > -260 {
                //if the user is moving the block horizontally from the right AND they have reached the yellow level, pop the reschedule view
                UIView.animate(withDuration: 0.3) {
                    self.messageTray.center = self.trayOriginalCenter
                    self.rescheduleView.alpha = 1
                    self.messageTray.isUserInteractionEnabled = false
                    self.rescheduleView.isUserInteractionEnabled = true
                }
            }
                else if messageTray.frame.origin.x < -260 {
                    //if the user is moving the block horizontally to the right AND they have reached the brown level, pop the list view
                
                    UIView.animate(withDuration: 0.3) {
                        self.messageTray.center = self.traySwipeFromRight
                        self.listView.alpha = 1
                        self.messageTray.isUserInteractionEnabled = false
                        self.listView.isUserInteractionEnabled = true
                    }
        
            } else if messageTray.frame.origin.x > 260 {
                
                self.messageTray.center = self.trayOriginalCenter
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - 86
                }) { (Bool) in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + 86
                }
            } else if messageTray.frame.origin.x > 60 && messageTray.frame.origin.x < 260 {
                
                self.messageTray.center = self.trayOriginalCenter
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - 86
                }) { (Bool) in
                    self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + 86
                }
                
            }
            } else {
                //if the user isn't moving the block, put it back to its original location
                UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: [], animations: {
                    self.messageTray.center = self.trayOriginalCenter
                }, completion: nil)

            }
            
        }
    
    
    @IBAction func didTapListView(_ sender: UITapGestureRecognizer) {
        
        //when the user taps the list view, dismiss it and return to list of emails
            listView.alpha = 0
        
        //ensure that message returns to original state and animates as if it is listed
        UIView.animate(withDuration: 0.3, animations: {
            self.messageTray.center = self.trayOriginalCenter
            self.messageTray.isUserInteractionEnabled = true
            self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - 86
            }) { (Bool) in
                self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + 86
        }
        
    }
    
    @IBAction func didTapRescheduleView(_ sender: UITapGestureRecognizer) {
        
        //when the user taps the resch view, dismiss it and return to list of emails
        rescheduleView.alpha = 0
        
        //ensure that message returns to original state and animates as if it is rescheduled
        UIView.animate(withDuration: 0.3, animations: {
            self.messageTray.center = self.trayOriginalCenter
            self.messageTray.isUserInteractionEnabled = true
            self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y - 86
        }) { (Bool) in
            self.messageFeed.frame.origin.y = self.messageFeed.frame.origin.y + 86
        }}
    

}


