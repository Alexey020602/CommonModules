//
//  ColorsExtensions.swift
//  SocUslugi
//
//  Created by Alexey on 07.12.2022.
//

import UIKit
import SwiftUI

public extension UIColor{
    static var appBlue:UIColor{
        UIColor(red: 52/255, green: 120/255, blue: 246/255, alpha: 1)
    }
    static var appBlack:UIColor{
        UIColor(red: 2/255, green: 2/255, blue: 4/255, alpha: 1)
    }
    static var appLightGray:UIColor{
        UIColor(red: 242/255, green: 241/255, blue: 246/255, alpha: 1)
    }
    static var appGray:UIColor{
        UIColor(red: 213/255, green: 212/255, blue: 217/255, alpha: 1)
    }
    static var appDarkGray:UIColor{
        UIColor(red: 140/255, green: 139/255, blue: 144/255, alpha: 1)
    }
    
    static var lightBlue:UIColor{
        UIColor(red: 237/255, green: 246/255, blue: 255/255, alpha: 1)
    }
}


public extension Color{
    static var appBlue:Color{
        Color(red: 52/255, green: 120/255, blue: 246/255)
    }
    static var appBlack:Color{
        Color(red: 2/255, green: 2/255, blue: 4/255)
    }
    static var appLightGray:Color{
        Color(red: 242/255, green: 241/255, blue: 246/255)
    }
    static var appGray:Color{
        Color(red: 213/255, green: 212/255, blue: 217/255)
    }
    static var appDarkGray:Color{
        Color(red: 140/255, green: 139/255, blue: 144/255)
    }
    
    static var lightBlue:Color{
        Color(red: 237/255, green: 246/255, blue: 255/255)
    }
}

public extension Color{
    /*static func colorRgbInt(_ red:Int, _ green:Int, _ blue:Int) -> Color{
        return Color(red: Double(red/255), green: Double(green/255), blue: Double(blue/255))
    }*/
    init(_ red:Int, _ green:Int, _ blue:Int){
        self.init(red: Double(red)/255.0, green: Double(green)/255.0, blue: Double(blue)/255.0)
    }
}
