//
//  CalendarViewController.swift
//  PocketMeals
//
//  Created by Leila Adaza on 8/2/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import KDCalendar
import EventKit

class CalendarViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var calendar: CalendarView!
    
    let formatter = DateFormatter()
    var date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        
        self.calendar.layer.cornerRadius = 3
        self.calendar.layer.borderWidth = 1
        self.calendar.layer.borderColor = UIColor.clear.cgColor
        
        self.navigationController?.isNavigationBarHidden = true
        
        self.titleLabel.layer.cornerRadius = 5
        self.titleLabel.layer.borderWidth = 1
        self.titleLabel.layer.borderColor = UIColor.clear.cgColor
        
        CalendarView.Style.cellShape                = .round
        CalendarView.Style.cellColorDefault         = UIColor.clear
        CalendarView.Style.cellColorToday           = UIColorFromRGB(rgbValue: 0xdec5e3)
        CalendarView.Style.cellSelectedBorderColor  = UIColorFromRGB(rgbValue: 0xffa69e)
        CalendarView.Style.cellEventColor           = UIColorFromRGB(rgbValue: 0xffa69e)
        CalendarView.Style.headerTextColor          = UIColor.white
        CalendarView.Style.cellTextColorDefault     = UIColor.white
        CalendarView.Style.cellTextColorToday       = UIColor(red:0.31, green:0.44, blue:0.47, alpha:1.00)

        CalendarView.Style.firstWeekday             = .monday

        calendar.direction = .horizontal
        calendar.multipleSelectionEnable = false
        calendar.marksWeekends = true

        calendar.backgroundColor = UIColorFromRGB(rgbValue: 0x989572)
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let today = Date()
        self.calendar.setDisplayDate(today, animated: false)
        // self.datePicker.setDate(today, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension CalendarViewController: CalendarViewDelegate, CalendarViewDataSource {

    @IBAction func unwindBack(_ segue: UIStoryboardSegue) {

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }

        switch identifier {

        case "addRecipe":
            guard let date = sender as? Date else { return }
            if segue.destination is DailyMealsViewController {
                let vc = segue.destination as! DailyMealsViewController
                vc.date = date
            }

        default:
            print("unexpected segue identifier")
        }
    }

    func calendar(_ calendar: CalendarView, didScrollToMonth date: Date) {
        // self.datePicker.setDate(date, animated: true)
    }

    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        print("Did Select: \(date) with \(events.count) events")
    }

    func calendar(_ calendar: CalendarView, canSelectDate date: Date) -> Bool {
        performSegue(withIdentifier: "addRecipe", sender: date)
        return true
    }

    func calendar(_ calendar: CalendarView, didDeselectDate date: Date) {

    }

    func calendar(_ calendar: CalendarView, didLongPressDate date: Date) {

    }

    func startDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.month = -1
        let today = Date()
        let oneMonthAgo = self.calendar.calendar.date(byAdding: dateComponents, to: today)
        return oneMonthAgo!
    }

    func endDate() -> Date {
        var dateComponents = DateComponents()
        dateComponents.year = 1
        
        let today = Date()
        
        let oneYearFromNow = self.calendar.calendar.date(byAdding: dateComponents, to: today)!
        
        return oneYearFromNow
    }
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func goToPreviousMonth(_ sender: UIButton) {
        self.calendar.goToPreviousMonth()
    }
    
    @IBAction func goToNextMonth(_ sender: UIButton) {
        self.calendar.goToNextMonth()
    }
}

extension Date {
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
}

