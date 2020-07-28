//
//  DepthTrendView.swift
//  kline
//
//  Created by zhangj on 2020/7/21.
//  Copyright © 2020 zhangj. All rights reserved.
//

import Foundation

//@property(retain, nonatomic) NSMutableArray *lineArray; // @synthesize lineArray=_lineArray;
//@property(retain, nonatomic) CAShapeLayer *outPointLayer; // @synthesize outPointLayer=_outPointLayer;
//@property(retain, nonatomic) CAShapeLayer *inPointLayer; // @synthesize inPointLayer=_inPointLayer;
//@property(retain, nonatomic) CAShapeLayer *sellFillLayer; // @synthesize sellFillLayer=_sellFillLayer;
//@property(retain, nonatomic) CAShapeLayer *buyFillLayer; // @synthesize buyFillLayer=_buyFillLayer;
//@property(retain, nonatomic) CAShapeLayer *sellStrokeLayer; // @synthesize sellStrokeLayer=_sellStrokeLayer;
//@property(retain, nonatomic) CAShapeLayer *buyStrokeLayer; // @synthesize buyStrokeLayer=_buyStrokeLayer;
//@property(retain, nonatomic) NSArray *sellArray; // @synthesize sellArray=_sellArray;
//@property(retain, nonatomic) NSArray *buyArray; // @synthesize buyArray=_buyArray;
//@property(retain, nonatomic) UILabel *longTouchVolumeLabel; // @synthesize longTouchVolumeLabel=_longTouchVolumeLabel;
//@property(retain, nonatomic) UILabel *longTouchPriceLabel; // @synthesize longTouchPriceLabel=_longTouchPriceLabel;
//@property(nonatomic) double longTouchX; // @synthesize longTouchX=_longTouchX;
//@property(retain, nonatomic) UIView *sellRectView; // @synthesize sellRectView=_sellRectView;
//@property(retain, nonatomic) UIView *buyRectView; // @synthesize buyRectView=_buyRectView;
//@property(retain, nonatomic) UILabel *sellLabel; // @synthesize sellLabel=_sellLabel;
//@property(retain, nonatomic) UILabel *buyLabel; // @synthesize buyLabel=_buyLabel;
//@property(retain, nonatomic) UILabel *volumeDownMiddleLabel; // @synthesize volumeDownMiddleLabel=_volumeDownMiddleLabel;
//@property(retain, nonatomic) UILabel *volumeDownLabel; // @synthesize volumeDownLabel=_volumeDownLabel;
//@property(retain, nonatomic) UILabel *volumeMiddleLabel; // @synthesize volumeMiddleLabel=_volumeMiddleLabel;
//@property(retain, nonatomic) UILabel *volumeTopMiddleLabel; // @synthesize volumeTopMiddleLabel=_volumeTopMiddleLabel;
//@property(retain, nonatomic) UILabel *volumeTopLabel; // @synthesize volumeTopLabel=_volumeTopLabel;
//@property(retain, nonatomic) UILabel *priceRightLabel; // @synthesize priceRightLabel=_priceRightLabel;
//@property(retain, nonatomic) UILabel *priceRightMiddleLabel; // @synthesize priceRightMiddleLabel=_priceRightMiddleLabel;
//@property(retain, nonatomic) UILabel *priceMiddleLabel; // @synthesize priceMiddleLabel=_priceMiddleLabel;
//@property(retain, nonatomic) UILabel *priceLeftMiddleLabel; // @synthesize priceLeftMiddleLabel=_priceLeftMiddleLabel;
//@property(retain, nonatomic) UILabel *priceLeftLabel; // @synthesize priceLeftLabel=_priceLeftLabel;
//@property(nonatomic) long long pricePrecision; // @synthesize pricePrecision=_pricePrecision;
//- (void).cxx_destruct;
//- (void)tapAction:(id)arg1;
//- (void)longPress:(id)arg1;
//- (void)showTrend;
//- (void)layoutSubviews;
//- (_Bool)bHaveData;
//- (void)hideLine;
//- (void)setBuy:(id)arg1 sell:(id)arg2;
//- (void)initGradientLayer;
//- (id)initWithFrame:(struct CGRect)arg1;
