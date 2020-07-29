//
//  ViewController.swift
//  Kline
//
//  Created by zhangj on 07/25/2020.
//  Copyright (c) 2020 zhangj. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Kline

class ViewController: UIViewController {
    @IBOutlet weak var periodSegment: UISegmentedControl!
    @IBOutlet weak var mainChartSegment: UISegmentedControl!
    @IBOutlet weak var assistantChartSegment: UISegmentedControl!
    @IBOutlet weak var symbolSegment: UISegmentedControl!
    
    let activity = UIActivityIndicatorView(style: .gray)
    
    let dataSource = MarketDataSource()
    
    let disposeBag = DisposeBag()
    
    var topic = ""
    
    var slitherView: SlitherView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        slitherView = SlitherView(frame: CGRect(x: 0, y: 250, width: UIScreen.main.bounds.width, height: 485))
        view.addSubview(slitherView)
        
        dataSource.delegate = self
        slitherView.dataSource = dataSource
        
        Observable.combineLatest(symbolSegment.rx.selectedSegmentIndex, periodSegment.rx.selectedSegmentIndex).subscribe(onNext: { [weak self] (sIndex, pIndex) in
            guard let `self` = self else { return }
            let symbol = self.symbolSegment.titleForSegment(at: sIndex)!
            let period = self.periodSegment.titleForSegment(at: pIndex)!
            self.dataSource.unWatch(topic: self.topic)
            self.topic = "market.\(symbol).kline.\(period)"
            self.dataSource.request(symbol: symbol, period: period)
            self.dataSource.watch(symbol: symbol, period: period)
            
        }).disposed(by: disposeBag)
        
        mainChartSegment.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] (index) in
            guard let `self` = self else { return }
            let title = self.mainChartSegment.titleForSegment(at: index)
            if title == "BOLL" {
                self.dataSource.mainChartType = .main_boll
            } else if title == "MA" {
                self.dataSource.mainChartType = .main_ma
            } else {
                self.dataSource.mainChartType = .main
            }
            self.slitherView.reloadData()
        }).disposed(by: disposeBag)
        
        assistantChartSegment.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] (index) in
            guard let `self` = self else { return }
            let title = self.assistantChartSegment.titleForSegment(at: index)
            
            switch title {
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
            self.slitherView.updateAllViews()
        }).disposed(by: disposeBag)
    }
}

extension ViewController: KlineViewDataSourceDelegate {
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
