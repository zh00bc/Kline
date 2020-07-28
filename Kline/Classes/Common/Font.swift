//
//  Font.swift
//  GzipSwift
//
//  Created by zhangj on 2020/7/27.
//

import Foundation

class CustomFonts: NSObject {
    enum DIN: CaseIterable {
        case regular
        case medium
        case bold

        var name: String {
            switch self {
            case .regular: return "DINPro-Regular"
            case .medium: return "DINPro-Medium"
            case .bold: return "DINPro-Bold"
            }
        }

        func font(ofSize fontSize: CGFloat) -> UIFont {
            return UIFont(name: name, size: fontSize) ?? UIFont()
        }
    }

    static var loadFonts: () -> Void = {
        let fontNames = DIN.allCases.map { $0.name }
        for fontName in fontNames {
            loadFont(withName: fontName)
        }
        return {}
    }()

    private static func loadFont(withName fontName: String) {
        guard
            let bundleURL = Bundle(for: CustomFonts.self).url(forResource: "Kline", withExtension: "bundle"),
            let bundle = Bundle(url: bundleURL),
            let fontURL = bundle.url(forResource: fontName, withExtension: "otf") else {
                return
        }
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            debugPrint("Error registering font: maybe it was already registered. :%@", error.debugDescription)
        }
    }
}
