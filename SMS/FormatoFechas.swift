//
//  FormatoFechas.swift
//  SMS
//
//  Created by Arturo Sanhueza on 04-07-17.
//  Copyright © 2017 Arturo Sanhueza. All rights reserved.
//

import UIKit

extension DateFormatter {
   
    
    func formatoHoraMinutoString(fecha:NSDate) -> String {
        
        self.dateFormat = "HH:mm"
        return self.string(from: fecha.addingTimeInterval(60*60*2) as Date)
    }

    func formatoDiaMesString(fecha:NSDate) -> String {
        
        self.dateFormat = "dd MMMM"
        fecha.addingTimeInterval(-978296400)

        return self.string(from: fecha as Date)
    }

    func formatoDiaMesCortoString(fecha:NSDate) -> String {
        
        self.dateFormat = "dd MMM"
        fecha.addingTimeInterval(-978296400)
        
        return self.string(from: fecha as Date)
    }
    func formatoAnoMesDiaDate(string:String) -> Date {
        
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: string)
        return date!
    }
    
    func formatoAnoMesDiaString(fecha:NSDate) -> String {
        
        self.dateFormat = "yyyy-MM-dd"
        fecha.addingTimeInterval(-978296400)
    
        return self.string(from: fecha as Date)
    }



}
