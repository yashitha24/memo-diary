//
//  Extensions.swift
//  Team3_Betaapp
//
//  Created by Yashitha Vilasagarapu on 10/30/23.
//

import Foundation
import SwiftUI

extension Color {
    func components() -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return (red, green, blue, alpha)
    }
}


extension UIColor {
    static func from(color: Color) -> UIColor {
        let components = color.components()
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: components.alpha)
    }
}


extension Date
{
    func toString(dateFormat format: String ) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
        
    }

}


extension VoiceViewModel {
    func covertSecToMinAndHour(seconds : Int) -> String{
        
        let (_,m,s) = (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
        let sec : String = s < 10 ? "0\(s)" : "\(s)"
        return "\(m):\(sec)"
        
    }
}
