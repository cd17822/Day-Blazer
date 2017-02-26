//
//  Globals.swift
//  hackbu17ipapp
//
//  Created by Charles DiGiovanna on 2/26/17.
//  Copyright © 2017 Charles DiGiovanna. All rights reserved.
//

import Foundation
import UIKit

let ENV = "" // THIS WILL BE FILLED IN WITH THE URL TYLER GIVES ME

var USER: User? = nil

func showError(on vc: UIViewController, overrideAndShow: Bool = false, message: String = "Could not connect to server.") {
//    if ERROR_MESSAGE_SHOWN && !overrideAndShow && !TESTING {
//        return
//    }else {
//        ERROR_MESSAGE_SHOWN = true
//    }
    
    print("ERROR:", message)
    return // SHOULDNT BE HERE
    let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    alertController.view.tintColor = UIColor.red
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertController.addAction(defaultAction)
    
    vc.present(alertController, animated: true, completion: nil)
}

extension UIColor {
    var pastelBlue: UIColor {
        return UIColor(red:0.82, green:0.95, blue:0.99, alpha:1.00)
    }
}

let colors = [
    UIColor(red:0.82, green:0.95, blue:0.99, alpha:1.00),
    UIColor(red:1.00, green:0.49, blue:0.59, alpha:1.00),
    UIColor(red:1.00, green:0.65, blue:0.51, alpha:1.00),
    UIColor(red:0.65, green:0.91, blue:0.43, alpha:1.00),
    UIColor(red:0.49, green:0.74, blue:0.99, alpha:1.00),
    UIColor(red:0.85, green:0.72, blue:0.99, alpha:1.00)]

extension Date {
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        return formatter
    }()
    var iso8601: String {
        return Date.iso8601Formatter.string(from: self)
    }
}
extension String {
    var dateFromISO8601: Date? {
        return Date.iso8601Formatter.date(from: self)
    }
}
