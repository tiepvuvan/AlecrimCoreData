//
//  AlarmEditViewController.swift
//  ACD Alarm
//
//  Created by Vanderlei Martinelli on 2016-08-12.
//  Copyright © 2016 Alecrim. All rights reserved.
//

import UIKit

import CoreData
import AlecrimCoreData

class AlarmEditViewController: UIViewController {
    
    // MARK: -
    
    internal var alarm: Alarm?
    
    // MARK: -
    
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let alarm = self.alarm {
            self.navigationItem.title = "Edit Alarm"
            self.datePicker.date = alarm.date
        }
        else {
            self.navigationItem.title = "Add Alarm"
            self.datePicker.date = Date()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier! {
        case "CancelUnwindSegue":
            break
            
        case "SaveUnwindSegue":
            if let alarm = self.alarm {
                self.fillAlarm(alarm: alarm)
            }
            else {
                self.fillAlarm(alarm: AppDelegate.shared.viewContext.alarms.create())
            }
            
            AppDelegate.shared.saveViewContext()
            
        default:
            break
        }
    }
    
}

extension AlarmEditViewController {
    
    private func fillAlarm(alarm: Alarm) {
        if alarm.isInserted {
            alarm.identifier = UUID().uuidString
        }
        
        alarm.type = alarm.managedObjectContext!.alarmTypes.first({ $0.identifier == "home" })!
        alarm.label = "Alarm"
        alarm.isActive = true
        
        alarm.date = self.datePicker.date
        
    }
    
}
