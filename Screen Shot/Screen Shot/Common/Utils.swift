//
//  Utils.swift
//  Screen Shot
//
//  Created by Nguyen Duc Phi on 9/25/16.
//  Copyright © 2016 Nguyen Duc Phi. All rights reserved.
//

import UIKit

func dateToTimeStringWith(date: Date) -> String{
    let dateformatter       = DateFormatter()
    dateformatter.dateFormat = "hh:mm"
    return dateformatter.string(from: date)
}

func dateToDateStringWith(date: Date) -> String{
    let dateformatter       = DateFormatter()
    dateformatter.dateFormat = "EEEE, MMMM dd"
    dateformatter.locale = Locale.current
    return dateformatter.string(from: date)
}
