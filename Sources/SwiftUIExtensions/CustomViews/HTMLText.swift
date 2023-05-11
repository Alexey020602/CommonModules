//
//  HTMLText.swift
//  SwiftUIExtensions
//
//  Created by Alexey on 30.03.2023.
//

import SwiftUI
import Foundation
import FoundationExtensions

public struct HTMLText: View {
    public let stringsWithAttributes:[StringWithAttributes]
    public init(html:String){
        if let data = html.data(using: .utf16),
            let attributedString = try? NSAttributedString(
                data: data,
                options: [.documentType:NSAttributedString.DocumentType.html,
                          .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil){
            debugPrint("\(attributedString.string)")
            stringsWithAttributes = attributedString.stringWithAttributes
        }else{
            stringsWithAttributes = []
        }
    }
    public var body: some View {
        VStack(alignment: .leading){
            ForEach(stringsWithAttributes) { attribute in
                AttributedText(stringWithAttributes: attribute)
            }
        }
    }
}




