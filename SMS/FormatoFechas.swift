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
        return self.string(from: fecha.addingTimeInterval(60*60*3) as Date)
    }

    func formatoDiaMesString(fecha:NSDate) -> String {
        
        self.dateFormat = "dd MMMM"
        fecha.addingTimeInterval(60*60*3)

        return self.string(from: fecha as Date)
    }

    func formatoDiaMesCortoString(fecha:NSDate) -> String {
        
        self.dateFormat = "dd MMM"
        fecha.addingTimeInterval(60*60*3)
        
        return self.string(from: fecha as Date)
    }
    func formatoAnoMesDiaDate(string:String) -> Date {
        
        self.dateFormat = "yyyy-MM-dd"
        let date = self.date(from: string)
        return date!
    }
    
    func formatoAnoMesDiaString(fecha:NSDate) -> String {
        
        self.dateFormat = "yyyy-MM-dd"
        fecha.addingTimeInterval(60*60*3)
    
        return self.string(from: fecha as Date)
    }

    func formatoDiaMesAnoLargoString(fecha:NSDate) -> String {
        
        self.locale = Locale(identifier: "es_CL")
        self.dateStyle = .full
        self.dateFormat = "dd 'de' MMMM 'de' yyyy"
        fecha.addingTimeInterval(60*60*3)
        
        return self.string(from: fecha as Date)
    }
    
    func formatoDiaMesLargoString(fecha:NSDate) -> String {
        
        self.locale = Locale(identifier: "es_CL")
        self.dateStyle = .full
        self.monthSymbols  = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
        self.weekdaySymbols = ["Lunes","Martes","Miércoles","Jueves","Viernes","Sábado","Domingo"]


        self.dateFormat = "EEEE, MMMM dd"
        fecha.addingTimeInterval(60*60*3)
        return self.string(from: fecha as Date)
    }


}
