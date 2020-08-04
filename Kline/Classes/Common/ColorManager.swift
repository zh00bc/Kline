//
//  ColorManager.swift
//  kline
//
//  Created by zhang j on 2019/7/17.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

struct ColorManager {
    static let shared = ColorManager()
    
    let slitherNumberLineColor = UIColor(red: 0.133333, green: 0.2, blue: 0.286275, alpha: 1)
    
    let klineMainBackgroundGradientColor1 = UIColor(hex: "#10142E").cgColor
    let klineMainBackgroundGradientColor2 = UIColor(hex: "#1D2140").cgColor
    let klineMainBackgroundGradientColor3 = UIColor(red: 0.0705882, green: 0.129412, blue: 0.207843, alpha: 1).cgColor
    
    let klineVolumeBackgroundGradientColor1 = UIColor(hex: "#10142E").cgColor
    let klineVolumeBackgroundGradientColor2 = UIColor(hex: "#1D2140").cgColor
    
    let klineCnyRateColor = UIColor(hex: "#82869E")
    let klineMinMaxValueColor = UIColor(hex: "#CFD2E6")

    let kColorShadeButtonGreenEnd = UIColor(hex: "#44AA99")
    let kColorShadeButtonRedEnd = UIColor(hex: "#CC5566")
    
    let klineIndexBackgroundGradientColorStart = UIColor(red: 0.0313726, green: 0.0901961, blue: 0.141176, alpha: 1)
    let klineIndexBackgroundGradientColorEnd = UIColor(red: 0.0745098, green: 0.121569, blue: 0.188235, alpha: 1)
    
    let klineSegTextColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
    
    let klineLatestPriceLabelBorderColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
    
    let klineMinuteDropdownGradientColor1 = UIColor(hex: "#31F9B4", alpha: 0.2)
    let klineMinuteDropdownGradientColor2 = UIColor(hex: "#31F9B4", alpha: 0.05)
    let klineMinuteDropdownGradientColor34 = UIColor(hex: "#31F9B4", alpha: 0.01)
    
    let klineMinuteLineColor = UIColor(hex: "#44AA99")
    let klinePreDayMinuteColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
    let klineMinuteShadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    let klineMA1Color = UIColor(hex: "#BFA556")
    let klineMA2Color = UIColor(hex: "#17BFBA")
    let klineMA3Color = UIColor(hex: "#AA56BF")
    let klineMA4Color = UIColor(red: 1.0, green: 0.231373, blue: 0.235294, alpha: 1)
    let klineMA5Color = UIColor(red: 0.443137, green: 0.823529, blue: 0.027451, alpha: 1)
    let klineMA6Color = UIColor(hex: "#9BA1C7")
    
    let klineCrossCursorGradientColor1 = UIColor(red: 0.0588235, green: 0.101961, blue: 0.160784, alpha: 0.2)
    let klineCrossCursorGradientColor24 = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 0.101961)
    let klineCrossCursorGradientColor3 = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 0.2)
    let klineCrossCursorGradientColor5 = UIColor(red: 0.0784314, green: 0.141176, blue: 0.223529, alpha: 0.2)
    
    let klineCrossCursorPriceBackgroundColor = UIColor(red: 0.0313726, green: 0.0901961, blue: 0.141176, alpha: 0.8)
    let klineCrossCursorPriceTextColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
    let klineCrossCursorPriceBorderColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
    
    let klineIndexSettingTextColor = UIColor(red: 0.0941176, green: 0.509804, blue: 0.831373, alpha: 1)
    
    let klineBgColor = UIColor(red: 0.0627451, green: 0.121569, blue: 0.192157, alpha: 1)
    let klineMinuteVolumeColor = UIColor(hex: "#44AA99", alpha: 0.6)
    
    let klinePrimaryTextColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
    
    let kColorSecondaryText = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
    let kColorContentBackground = UIColor(red: 0.0745098, green: 0.121569, blue: 0.188235, alpha: 1)
}

//struct ColorManager {
//    static let shared = ColorManager()
//
//    let slitherNumberLineColor = UIColor(red: 0.133333, green: 0.2, blue: 0.286275, alpha: 1)
//
//    let klineMainBackgroundGradientColor1 = UIColor(red: 0.054902, green: 0.0901961, blue: 0.141176, alpha: 1).cgColor
//    let klineMainBackgroundGradientColor2 = UIColor(red: 0.0627451, green: 0.105882, blue: 0.164706, alpha: 1).cgColor
//    let klineMainBackgroundGradientColor3 = UIColor(red: 0.0705882, green: 0.129412, blue: 0.207843, alpha: 1).cgColor
//
//    let klineVolumeBackgroundGradientColor1 = UIColor(red: 0.0666667, green: 0.109804, blue: 0.168627, alpha: 1).cgColor
//    let klineVolumeBackgroundGradientColor2 = UIColor(red: 0.0784314, green: 0.141176, blue: 0.227451, alpha: 1).cgColor
//
//    let klineCnyRateColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
//
//    let kColorShadeButtonGreenEnd = UIColor(red: 0.0117647, green: 0.678431, blue: 0.560784, alpha: 1)
//    let kColorShadeButtonRedEnd = UIColor(red: 0.819608, green: 0.294118, blue: 0.392157, alpha: 1)
//
//    let klineIndexBackgroundGradientColorStart = UIColor(red: 0.0313726, green: 0.0901961, blue: 0.141176, alpha: 1)
//    let klineIndexBackgroundGradientColorEnd = UIColor(red: 0.0745098, green: 0.121569, blue: 0.188235, alpha: 1)
//
//    let klineSegTextColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
//
//    let klineLatestPriceLabelBorderColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
//
//    let klineMinuteDropdownGradientColor1 = UIColor(red: 0.0941176, green: 0.341176, blue: 0.831373, alpha: 0.14902)
//    let klineMinuteDropdownGradientColor2 = UIColor(red: 0.266667, green: 0.501961, blue: 0.972549, alpha: 0.14902)
//    let klineMinuteDropdownGradientColor34 = UIColor(red: 0.0745098, green: 0.121569, blue: 0.188235, alpha: 0)
//
//    let klineMinuteLineColor = UIColor(red: 0.0941176, green: 0.509804, blue: 0.831373, alpha: 1)
//    let klinePreDayMinuteColor = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
//    let klineMinuteShadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
//    let klineMA1Color = UIColor(red: 0.964706, green: 0.862745, blue: 0.576471, alpha: 1)
//    let klineMA2Color = UIColor(red: 0.380392, green: 0.819608, blue: 0.752941, alpha: 1)
//    let klineMA3Color = UIColor(red: 0.796078, green: 0.572549, blue: 0.996078, alpha: 1)
//    let klineMA4Color = UIColor(red: 1.0, green: 0.231373, blue: 0.235294, alpha: 1)
//    let klineMA5Color = UIColor(red: 0.443137, green: 0.823529, blue: 0.027451, alpha: 1)
//    let klineMA6Color = UIColor(red: 0.435294, green: 0.12549, blue: 1, alpha: 1)
//
//    let klineCrossCursorGradientColor1 = UIColor(red: 0.0588235, green: 0.101961, blue: 0.160784, alpha: 0.2)
//    let klineCrossCursorGradientColor24 = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 0.101961)
//    let klineCrossCursorGradientColor3 = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 0.2)
//    let klineCrossCursorGradientColor5 = UIColor(red: 0.0784314, green: 0.141176, blue: 0.223529, alpha: 0.2)
//
//    let klineCrossCursorPriceBackgroundColor = UIColor(red: 0.0313726, green: 0.0901961, blue: 0.141176, alpha: 0.8)
//    let klineCrossCursorPriceTextColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
//    let klineCrossCursorPriceBorderColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
//
//    let klineIndexSettingTextColor = UIColor(red: 0.0941176, green: 0.509804, blue: 0.831373, alpha: 1)
//
//    let klineBgColor = UIColor(red: 0.0627451, green: 0.121569, blue: 0.192157, alpha: 1)
//    let klineMinuteVolumeColor = UIColor(red: 0.0941176, green: 0.509804, blue: 0.831373, alpha: 0.501961)
//
//    let klinePrimaryTextColor = UIColor(red: 0.811765, green: 0.827451, blue: 0.913725, alpha: 1)
//
//    let kColorSecondaryText = UIColor(red: 0.427451, green: 0.529412, blue: 0.658824, alpha: 1)
//    let kColorContentBackground = UIColor(red: 0.0745098, green: 0.121569, blue: 0.188235, alpha: 1)
//}

