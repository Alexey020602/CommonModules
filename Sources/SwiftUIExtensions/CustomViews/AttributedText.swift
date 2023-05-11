//
//  AttributedText.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 30.03.2023.
//

import SwiftUI
import FoundationExtensions

public struct AttributedText: View {
    public let stringWithAttributes:StringWithAttributes
    public var body: some View {
        link(underline(color(kern(strikethroughStyle(tracking(
                Text(stringWithAttributes.string)
        ))))))
    }
    
    func font(_ text:Text) -> Text{
        guard let font = stringWithAttributes.attributes[.font] as? UIFont else {return text}
        return text.font(.init(font))
    }
    
    /*
    func underline2(_ text:Text) -> Text
    {
        if let underlineStyle = stringWithAttributes.attributes[.underlineStyle] as? NSNumber,
                 underlineStyle != 0
        {
            if let underlineColor = stringWithAttributes.attributes[.underlineColor] as? UIColor
            {
                return text.underline(true, color: Color(underlineColor))
            } else
            {
                return text.underline(true)
            }
        }
        else
        {
            return text
        }
    }
    */
    
    func underline(_ text:Text) -> Text{
        guard let style = stringWithAttributes.attributes[.underlineStyle] as? NSNumber,
        style != 0 else{return text}
        
        guard let color = stringWithAttributes.attributes[.underlineColor] as? UIColor else{
            return text.underline(true)
        }
        return text.underline(true, color: .init(color))
    }
    
    func color(_ text:Text) -> Text{
        guard let color = stringWithAttributes.attributes[.foregroundColor] as? UIColor else{return text}
        return text.foregroundColor(.init(color))
    }
    
    func kern(_ text:Text) -> Text{
        guard let kern = stringWithAttributes.attributes[.kern] as? CGFloat else {return text}
        return text.kerning(kern)
    }
    
    func strikethroughStyle(_ text:Text) -> Text{
        
        guard let style = stringWithAttributes.attributes[.strikethroughStyle] as? NSNumber,
            style != 0 else{ return text}
        
        guard let strikethroughColor = (stringWithAttributes.attributes[.strikethroughColor] as? UIColor)  else {
            return text.strikethrough(true)
        }
        
        return text.strikethrough(true, color: Color(strikethroughColor))
    }
    
    @available(iOS 14.0,*)
    func tracking(_ text:Text) -> Text{
        guard let tracking = stringWithAttributes.attributes[.tracking]as? CGFloat else{return text}
        return text.tracking(tracking)
    }
    
    @ViewBuilder func link(_ text:Text) -> some View{
        if let url = stringWithAttributes.attributes[.link] as? URL{
            Link(destination: url) {
                text
            }
        }else{
            text
        }
    }
}
