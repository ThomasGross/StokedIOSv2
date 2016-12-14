//
//  DateExtension.swift
//  Stoked
//
//  Created by Thomas Rasmussen on 25/11/2016.
//  Copyright © 2016 Thomas Rasmussen. All rights reserved.
//

import Foundation

// extension that converts a dateformat to specific weekday
extension Date {

    func getDayOfWeek(today: String) -> String? {
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.date(from: today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            let myComponents = myCalendar.components(.weekday, from: todayDate)
            let weekDay = myComponents.weekday
            if weekDay == 1 {
                return "SUN"
            } else if weekDay == 2 {
                return "MON"
            } else if weekDay == 3 {
                return "TUE"
            } else if weekDay == 4 {
                return "WED"
            } else if weekDay == 5 {
                return "THU"
            } else if weekDay == 6 {
                return "FRI"
            } else if weekDay == 7 {
                return "SAT"
            } else {
                return ""
            }
            
        }
        else {
            return ""
        }
    }

}
