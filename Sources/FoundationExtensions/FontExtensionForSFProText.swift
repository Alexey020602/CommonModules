//
//  FontExtensionForSFProText.swift
//  SocUslugi
//
//  Created by Alexey on 17.11.2022.
//

import SwiftUI

extension Font {

/// Create a font with the large title text style.
    public static var largeTitle: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)
    }

/// Create a font with the title text style.
    public static var title: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .title1).pointSize)
    }

/// Create a font with the headline text style.
    public static var headline: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .headline).pointSize)
    }

/// Create a font with the subheadline text style.
    public static var subheadline: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .subheadline).pointSize)
    }

/// Create a font with the body text style.
    public static var body: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .body).pointSize)
    }

/// Create a font with the callout text style.
    public static var callout: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize)
    }

/// Create a font with the footnote text style.
    public static var footnote: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
    }

/// Create a font with the caption text style.
    public static var caption: Font {
        return Font.custom("SF-Pro-Text-Regular", size: UIFont.preferredFont(forTextStyle: .caption1).pointSize)
    }

    public static func system(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default) -> Font {
        var font = "SF-Pro-Text-Regular"
        switch weight {
        case .bold: font = "SF-Pro-Text-Bold"
        case .heavy: font = "SF-Pro-Text-Heavy"
        case .light: font = "SF-Pro-Text-Light"
        case .medium: font = "SF-Pro-Text-Medium"
        case .semibold: font = "SF-Pro-Text-Semibold"
        case .thin: font = "SF-Pro-Text-Thin"
        case .ultraLight: font = "SF-Pro-Text-Ultralight"
        case .black: font = "SF-Pro-Text-Black"
        default: break
        }
        return Font.custom(font, size: size)
    }
}
