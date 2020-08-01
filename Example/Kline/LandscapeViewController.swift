//
//  LandscapeViewController.swift
//  Kline_Example
//
//  Created by zhangj on 2020/7/31.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import Kline
import RxSwift

class LandscapeViewController: UIViewController {
    
    var slitherView: SlitherView!
    
    let dataSource = MarketDataSource()
    
    let disposeBag = DisposeBag()
    
    var periodSegment: UISegmentedControl!
    var assistantSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi*0.5)
        view.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width)
        
        assistantSegment.selectedSegmentIndex = 0
        periodSegment.selectedSegmentIndex = 0
        
        Observable.combineLatest(assistantSegment.rx.selectedSegmentIndex,
                                 periodSegment.rx.selectedSegmentIndex).subscribe(onNext: { [weak self] (sIndex, pIndex) in
            guard let `self` = self else { return }
            let symbol = self.assistantSegment.titleForSegment(at: sIndex)!
            let period = self.periodSegment.titleForSegment(at: pIndex)!
            
            switch symbol {
            case "MACD":
                self.dataSource.assistantChartType = .assistant_macd
            case "KDJ":
                self.dataSource.assistantChartType = .assistant_kdj
            case "RSI":
                self.dataSource.assistantChartType = .assistant_rsi
            case "WR":
                self.dataSource.assistantChartType = .assistant_wr
            case "Hide":
                self.dataSource.assistantChartType = .assistant_hide
            default:
                break
            }
            
            switch period {
            case "1min":
                self.dataSource.period = .min
            case "4hour":
                self.dataSource.period = .hour4
            case "1day":
                self.dataSource.period = .day
            case "1week":
                self.dataSource.period = .week
            case "1mon":
                self.dataSource.period = .month
            default:
                break
            }
            self.slitherView.updateAllViews()

        }).disposed(by: disposeBag)
    }
    
    func setupViews() {
        let top = UIApplication.shared.keyWindow?.safeAreaInsets
        let height = UIScreen.main.bounds.width - 40 - 30
        let width = UIScreen.main.bounds.height - 34 - 44
        slitherView = SlitherView(frame: CGRect(x: 89, y: 49, width: width, height: height))
        view.addSubview(slitherView)
        
        dataSource.delegate = self
        slitherView.dataSource = dataSource
        dataSource.period = .min
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
           self?.dataSource.request(symbol: "btcusdt", period: "1min")
           self?.dataSource.watch(symbol: "btcusdt", period: "1min")
        }
            
        periodSegment = UISegmentedControl(items: ["1min", "1week", "1day"])
        periodSegment.frame = CGRect(x: 89, y: 0, width: 240, height: 40)
        periodSegment.tintColor = .white
        view.addSubview(periodSegment)
        
        assistantSegment = UISegmentedControl(items: ["MACD", "KDJ", "Hide"])
        assistantSegment.frame = CGRect(x: 350, y: 0, width: 220, height: 40)
        view.addSubview(assistantSegment)
        
        
    }
}

extension LandscapeViewController: KlineViewDataSourceDelegate {
    func refresh() {
        
    }
    
    func updateKline(reset: Bool) {
        if reset {
            slitherView.resetData()
        } else {
            slitherView.reloadData()
        }
    }
}
