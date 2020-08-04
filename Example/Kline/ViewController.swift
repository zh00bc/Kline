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
import Localize_Swift

class ViewController: UIViewController {
    @IBOutlet weak var periodSegment: UISegmentedControl!
    @IBOutlet weak var mainChartSegment: UISegmentedControl!
    @IBOutlet weak var assistantChartSegment: UISegmentedControl!
    @IBOutlet weak var symbolSegment: UISegmentedControl!
    
    let activity = UIActivityIndicatorView(style: .whiteLarge)
    
    let dataSource = MarketDataSource()
    
    let disposeBag = DisposeBag()
    
    var topic = ""
    
    var slitherView: SlitherView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Localize.setCurrentLanguage("ko")
        
        slitherView = SlitherView(frame: CGRect(x: 0, y: 300, width: UIScreen.main.bounds.width, height: 520))
        slitherView.delegate = self
        view.addSubview(slitherView)
        
        activity.hidesWhenStopped = true
        view.addSubview(activity)
        activity.snp.makeConstraints {
            $0.center.equalTo(slitherView)
        }
        
        dataSource.delegate = self
        slitherView.dataSource = dataSource
        
        Observable.combineLatest(symbolSegment.rx.selectedSegmentIndex, assistantChartSegment.rx.selectedSegmentIndex, periodSegment.rx.selectedSegmentIndex).subscribe(onNext: { [weak self] (bIndex, sIndex, pIndex) in
            guard let `self` = self else { return }
            let symbol = self.symbolSegment.titleForSegment(at: bIndex)!
            let assistant = self.assistantChartSegment.titleForSegment(at: sIndex)!
            var period = self.periodSegment.titleForSegment(at: pIndex)!
            self.dataSource.unWatch(topic: self.topic)
            
            switch period {
            case "1min":
                self.dataSource.change(period: .min)
            case "4hour":
                self.dataSource.change(period: .hour4)
            case "timeline":
                self.dataSource.change(period: .timeline)
                period = "1min"
            case "1week":
                self.dataSource.change(period: .week)
            case "1mon":
                self.dataSource.change(period: .month)
            default:
                break
            }
            
            self.topic = "market.\(symbol).kline.\(period)"
            self.dataSource.request(symbol: symbol, period: period)
            self.dataSource.watch(symbol: symbol, period: period)
            
            switch assistant {
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
            
            self.activity.startAnimating()
            self.slitherView.resetData()
            self.slitherView.updateAllViews()

        }).disposed(by: disposeBag)
        
//        mainChartSegment.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] (index) in
//            guard let `self` = self else { return }
//            let title = self.mainChartSegment.titleForSegment(at: index)
//            if title == "BOLL" {
//                self.dataSource.mainChartType = .main_boll
//            } else if title == "MA" {
//                self.dataSource.mainChartType = .main_ma
//            } else {
//                self.dataSource.mainChartType = .main
//            }
//            self.slitherView.reloadData()
//        }).disposed(by: disposeBag)
//
//        assistantChartSegment.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] (index) in
//            guard let `self` = self else { return }
//            let title = self.assistantChartSegment.titleForSegment(at: index)
//
//            switch title {
//            case "MACD":
//                self.dataSource.assistantChartType = .assistant_macd
//            case "KDJ":
//                self.dataSource.assistantChartType = .assistant_kdj
//            case "RSI":
//                self.dataSource.assistantChartType = .assistant_rsi
//            case "WR":
//                self.dataSource.assistantChartType = .assistant_wr
//            case "Hide":
//                self.dataSource.assistantChartType = .assistant_hide
//            default:
//                break
//            }
//            self.slitherView.updateAllViews()
//        }).disposed(by: disposeBag)
    }
    
    @IBAction func landScape(_ sender: Any) {
        let vc = LandscapeViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

extension ViewController: KlineViewDataSourceDelegate {
    func refresh() {
    
    }
    
    func updateKline(reset: Bool) {
        if reset {
            activity.stopAnimating()
            slitherView.resetData()
        } else {
            slitherView.reloadData()
        }
    }
}

extension ViewController: SlitherViewDelegate {
    func slitherViewWillBeginDragging(_ slitherView: SlitherView) {
        
    }
    
    func slitherView(_ slitherView: SlitherView, didSelectAt index: Int) {
        
    }
    
    func hideAllPopup() {
        activity.stopAnimating()
    }
}
