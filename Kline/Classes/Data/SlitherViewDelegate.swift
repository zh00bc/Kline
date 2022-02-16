//
//  SlitherViewDelegate.swift
//  kline
//
//  Created by zhang j on 2019/6/15.
//  Copyright © 2019 zhangj. All rights reserved.
//

public protocol SlitherViewDelegate: AnyObject {
    func slitherViewWillBeginDragging(_ slitherView: SlitherView)
    func slitherView(_ slitherView: SlitherView, didSelectAt index: Int)
    func hideAllPopup()
}
