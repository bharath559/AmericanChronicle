//
//  Month.swift
//  AmericanChronicle
//
//  Created by Ryan Peterson on 8/13/15.
//  Copyright (c) 2015 ryanipete. All rights reserved.
//

enum Month: Int {
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case October
    case November
    case December
    
    static func stringForRawValue(rawValue: Int) -> String {
        let month = Month(rawValue: rawValue) ?? .January
        switch month {
        case .January:
            return "January"
        case .February:
            return "February"
        case .March:
            return "March"
        case .April:
            return "April"
        case .May:
            return "May"
        case .June:
            return "June"
        case .July:
            return "July"
        case .August:
            return "August"
        case .September:
            return "September"
        case .October:
            return "October"
        case .November:
            return "November"
        case .December:
            return "December"
        }
    }
}
