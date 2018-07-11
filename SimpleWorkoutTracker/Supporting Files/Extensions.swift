//
//  Extensions.swift
//  SimpleWorkoutTracker
//
//  Created by Kevin Chou on 2018-06-11.
//  Copyright © 2018 Kevin Chou. All rights reserved.
//

import Foundation

extension Double {
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.1f", self)
    }
}

extension Date {
    var longString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter.string(from: self)
    }
}
