//
//  ViewController.swift
//  better_alarm
//
//  Created by James Shih on 5/6/16.
//  Copyright © 2016 Yu-Liang Shih. All rights reserved.
//


import UIKit
import AVFoundation

var strDate : String = ""
var now : String = ""
var counter :Int = 0

var On : Bool = false


var caseState = 0


var sec:Double = 0

let systemSoundID: SystemSoundID = 1057

let alarmSound: SystemSoundID = 1304

var qnum:Int = Int() //question number

let questions = ["2 X 6 + 9 - 15"," 0.2 X 46 + 8"," 17 X 64","77 - 19 + 67 X 47 / 2"]

let answers = ["6","17.2","1088","1632.5"]

var answerStr:String=""

class ViewController: UIViewController{
    
    @IBOutlet weak var createTitle: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var buttonDis: UIButton!
    
    @IBOutlet weak var countDis: UILabel!
    @IBOutlet weak var answer: UITextField!
    
    @IBOutlet weak var photo: UIImageView!
    
    @IBOutlet weak var hidePhotoDis: UIButton!
    @IBAction func hidePhoto(sender: UIButton) {
        hidePhotoDis.hidden = true
            photo.hidden = true
    }
    
    @IBAction func button(sender: UIButton) {
        AudioServicesPlaySystemSound (systemSoundID)
        
        if(caseState == 0){
            On = true
            dateLabel.text = "New Alarm: \(datePickerChanged(datePicker))"
            print(dateLabel.text)
            
        }else if(caseState == 1 && counter>0){
            if(answerStr == answers[qnum]){
                caseState = 2
            }
            
        }
        
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.hidden = true
        NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("updateTime"), userInfo: nil, repeats: true)
    }
    
    
    func datePickerChanged(datePicker:UIDatePicker)->String {
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle  //time
        strDate = dateFormatter.stringFromDate(datePicker.date)
        //print(strDate)
        return strDate
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func updateTime() {
        switch caseState {
            
        case 0:
            answerStr=""
            answer.text! = answerStr
            qnum = Int(arc4random_uniform(3) + 1) //generate random  number from 0 - 3
            countDis.hidden = true
            createTitle.hidden = false
            dateLabel.hidden = true
            datePicker.hidden = false
            answer.hidden = true
            buttonDis.setTitle("Create",forState: .Normal)
            counter = 600
            //sec = 0.1
            now = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: NSDateFormatterStyle.NoStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            
            if(On == true){
                createTitle.hidden = true
                dateLabel.hidden = false
                datePicker.hidden = true
                buttonDis.hidden = true
                if(now == strDate){
                    dateLabel.text = "\(questions[qnum]) = "
                    caseState = 1
                    
                }
            }
            
            break
            
        case 1:
            buttonDis.hidden = false
            answer.hidden = false
            On = false
            buttonDis.setTitle("Submit",forState: .Normal)
            countDis.hidden = false
            countDis.text = "\(counter/10)"
            AudioServicesPlaySystemSound (alarmSound)
            answerStr = answer.text!
            if(counter > 0){
                
                counter--   //60 seconds count down
                print("\(counter/10)")
                
            }else if (counter <= 0){
                print("Second up")
                caseState = 3
                
            }
            
            break
            
        case 2:
            hidePhotoDis.hidden = false
            photo.hidden=false
            self.photo.image = UIImage(named:"reward") //reward image
            caseState = 0
            
            
            break;
            
        case 3:
            hidePhotoDis.hidden = false
            photo.hidden=false
            self.photo.image = UIImage(named:"punish") //punishment image
            caseState = 0
            
            break;
            
            
        default:
            break
            
        }
        
    }
    
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
            view.endEditing(true)
            super.touchesBegan(touches, withEvent: event)
        }
    
    
    
    
}







