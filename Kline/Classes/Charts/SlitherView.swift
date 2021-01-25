//
//  SlitherView.swift
//  kline
//
//  Created by zhang j on 2019/6/14.
//  Copyright © 2019 zhangj. All rights reserved.
//

import UIKit

open class SlitherView: UIView {

    // MARK: - View
    
    private var mainNumberView: SlitherNumberView!
    private var volumeNumberView: SlitherNumberView!
    private var assistantNumberView: SlitherNumberView!
    
    private var scrollView: UIScrollView!
    
    private var mainChart: ChartView!
    private var volumeChart: ChartView!
    private var assistantChart: ChartView!
    
    private var timeShowView: TimeShowView!
    private var longPressShowView: LongPressShowView!
    private var latestPriceView: KLineLatestPriceView!
    private var gotoLatestButton: UIButton!
    private var logoImageView: UIImageView!
    
    /// Full Screen
    var isFullView: Bool = false
    var leftPercent: Double = 0
    
    private var mainViewChartType: ChartType {
        return dataSource?.mainChartType ?? .main
    }
    
    private var volumeViewChartType: ChartType {
        return dataSource?.volumeChartType ?? .volume
    }
    
    private var assistantViewChartType: ChartType {
        return dataSource?.assistantChartType ?? .assistant_wr
    }
    
    public var latestPriceTextAttributes: [NSAttributedString.Key: Any] = [.font: CustomFonts.DIN.medium.font(ofSize: 9),
                                                                           .backgroundColor: ColorManager.shared.kColorContentBackground.withAlphaComponent(0.9),
                                                                           .foregroundColor: ColorManager.shared.klineIndexSettingTextColor] {
        didSet {
            latestPriceView.textAttributes = latestPriceTextAttributes
        }
    }
    
    // MARK: - Data
    
    public weak var dataSource: KlineViewDataSource?
    public weak var delegate: SlitherViewDelegate?
    
    /// 右边空白宽度
    var rightSpacing: CGFloat {
        return frame.width / 5.0
    }
    
    var contentXOffset: CGFloat = 0
    var contentShowIndex: Int = 0

    /// x - x Offset
    var lineInterval: CGFloat = 9
    var maxLineWidth: CGFloat = 7
    
    var lastPinchScale: CGFloat = 1.0
    var longPressedPoint: CGPoint = CGPoint.zero
    
    /// 记录上次显示起始位置的timestamp
    var startDate: Int?
    
    var style: ChartStyle?
    
    deinit {
        print("SlitherView deinit")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public init(frame: CGRect, style: ChartStyle? = nil) {
        super.init(frame: frame)
        self.style = style
        setup()
    }
    
    func updateKlinePosition() {
        contentXOffset = scrollView.contentOffset.x
        
        contentShowIndex = max(0, Int(contentXOffset / lineInterval))
    
        let startIndex = contentShowIndex
        let endIndex = min(Int((mainChart.bounds.width / lineInterval) + CGFloat(startIndex)), dataSource!.pointCount)
        setTheLimitPrice(start: startIndex, end: endIndex)
        
        let candleChartFrame = mainChart.frame
        mainChart.frame = CGRect(x: contentXOffset, y: candleChartFrame.minY, width: candleChartFrame.width, height: candleChartFrame.height)
        mainChart.updatePoints()
        
        if !assistantChart.isHidden {
            let assistantChartFrame = assistantChart.frame
            assistantChart.frame = CGRect(x: contentXOffset, y: assistantChartFrame.minY, width: assistantChartFrame.width, height: assistantChartFrame.height)
            assistantChart.updatePoints()
        }
        
        if !volumeChart.isHidden {
            let volumeChartFrame = volumeChart.frame
            volumeChart.frame = CGRect(x: contentXOffset, y: volumeChartFrame.minY, width: volumeChartFrame.width, height: volumeChartFrame.height)
            volumeChart.updatePoints()
        }
        
        let showHistory = (contentXOffset + scrollView.bounds.width + 1.0) < scrollView.contentSize.width
        setTimeShow(start: contentShowIndex, end: endIndex, showHistory: showHistory)
        showNewestPriceMessage()
        showLastPrice(contentShowIndex: contentShowIndex)
        
        if longPressShowView.pressedType == .long {
            showLongPressed(point: longPressedPoint)
        } else if longPressShowView.pressedType == .short {
            touchPoint(longPressedPoint)
        }
    }
    
    func show() {
        
    }
    
    func reduceKline() {
        if maxLineWidth > Constants.minLineWidth {
            maxLineWidth = maxLineWidth - 1.0
            zoomKline()
        }
    }
    
    func amplifyKline() {
        if maxLineWidth < Constants.maxLineWidth {
            maxLineWidth = maxLineWidth + 1.0
            zoomKline()
        }
    }
    
    func zoomKline() {
        mainChart.zoomKline(width: maxLineWidth)
        volumeChart.zoomKline(width: maxLineWidth)
        assistantChart.zoomKline(width: maxLineWidth)
        changeScaleUpdate()
    }
    
    func changeScaleUpdate() {
        // 保持左侧不动，需要重设contentOffset
        dataSource?.change(maxWidth: maxLineWidth)
        
        contentShowIndex = Int(scrollView.contentOffset.x / lineInterval)

        let contentOffsetX = scrollView.contentOffset.x
        var startIndex = Int(contentOffsetX / lineInterval)
        let endIndex = Int(Double(mainChart.bounds.width) / Double(lineInterval)) + startIndex
        
        if dataSource!.pointCount < endIndex {
            startIndex = max(0, Int(CGFloat(dataSource!.pointCount) - mainChart.bounds.width / lineInterval))
        }
        
        lineInterval = maxLineWidth + Constants.lineOffset

        let pointCount = dataSource!.pointCount
        let contentWidth = lineInterval * CGFloat(pointCount)
        scrollView.contentSize = CGSize(width: contentWidth + rightSpacing, height: 0)
        
        contentXOffset = lineInterval * CGFloat(startIndex)
        
        scrollView.contentOffset = CGPoint(x: contentXOffset, y: 0)
    
        updateKlinePosition()
        
    }
    
    public func reloadData() {
        guard let `dataSource` = dataSource else {
            return
        }
                
        let width = CGFloat(dataSource.pointCount) * lineInterval + rightSpacing
        scrollView.contentSize = CGSize(width: width, height: 0.0)
        contentShowIndex = Int(scrollView.contentOffset.x / lineInterval)
        
        var offsetX = max(scrollView.contentSize.width - scrollView.frame.width, 0.0)
        
        /// 刷新数据时保持位置
        if let date = startDate {
            if let index = dataSource.index(of: date) {
                offsetX = lineInterval * CGFloat(index)
            }
        }
        
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0.0)
        
        updateKlinePosition()
    }
    
    public func resetData() {
        startDate = nil
        longPressShowView.hide()
        updateAllViews()
    }
    
    public func clearData() {
        scrollView.contentSize = CGSize(width: scrollView.bounds.width, height: 0.0)
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        contentShowIndex = 0
        updateKlinePosition()
    }
    
    func requestKline() {
        dataSource?.requestKline()
    }
    
    
    /// - Parameter showHistory: set startDate
    func setTimeShow(start: Int, end: Int, showHistory: Bool) {
        guard let `dataSource` = dataSource else {
            return
        }
        let a = Int(mainChart.bounds.width / lineInterval / 5.0)
        let indexes = [start, start + a, start + 2 * a, start + 3 * a, start + 4 * a, end]
        let times = dataSource.showTimes(for: indexes)
        if showHistory {
            if let firstShowTime = times.first {
                startDate = firstShowTime
            }
        } else {
            startDate = nil
        }
        var strings: [String] = []
        for time in times {
            strings.append(KlineDateCommon.string(timestamp: time, period: dataSource.currentPeriod))
        }
        
        timeShowView.update(times: strings)
    }
}

// MARK: - UIScrollViewDelegate
extension SlitherView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateKlinePosition()
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        longPressShowView.hide()
        delegate?.slitherViewWillBeginDragging(self)
        delegate?.hideAllPopup()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        updateKlinePosition()
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateKlinePosition()
    }
}

// MARK: - Handle Gesture
extension SlitherView {
    @objc func onPinch(recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began:
            lastPinchScale = 1.0
        case .changed:
            let scale = recognizer.scale
            if abs(scale - lastPinchScale) > 0.05 {
                if scale <= lastPinchScale {
                    reduceKline()
                } else {
                    amplifyKline()
                }
                lastPinchScale = scale
            }
        default:
            break
        }
    }
    
    @objc func onLongPress(recognizer: UILongPressGestureRecognizer) {
        delegate?.hideAllPopup()
        
        let point = recognizer.location(in: self)

        showLongPressed(point: point)
    }
    
    @objc func onTap(recognizer: UITapGestureRecognizer) {
        switch longPressShowView.pressedType {
        case .long:
            longPressShowView.hide()
        case .none, .short:
            delegate?.hideAllPopup()
            var point = recognizer.location(in: self)
            if point.x + lineInterval > mainChart.frame.width {
                point.x = mainChart.frame.width - lineInterval
            }
            touchPoint(point)
        }
    }
    
    func touchPoint(_ point: CGPoint) {
        guard let `dataSource` = dataSource else {
            return
        }
        guard dataSource.pointCount > 0 else {
            return
        }
        
        // 超出区域点击不显示
        if point.y < mainChart.frame.origin.y + Constants.mainChartTopSpace
        || point.y > mainChart.frame.maxY - Constants.mainChartBottomSpace {
            longPressShowView.hide()
            return
        }
        
        longPressedPoint = point
        let lineData = mainChart.getCandle(for: longPressedPoint)
        showTouch(lineData: lineData)
        
        if let klineModel = dataSource.getData(from: lineData.nDataIndex) as? CandleLinePriceData {
            
            /// 计算选中点的价格
            let d = (mainChart.maxPrice.doubleValue - mainChart.minPrice.doubleValue) / Double(mainChart.bounds.height - Constants.mainChartTopSpace - Constants.mainChartBottomSpace)
            let p = mainChart.minPrice.doubleValue + Double((mainChart.frame.maxY - point.y)) * d
            longPressShowView.touchShow(point: CGPoint(x: lineData.x, y: Double(point.y - Constants.mainChartTopOffset - Constants.mainChartTopSpace)), period: period, price: NSNumber(value: p), timeCenterY: timeShowView.center.y, lineWidth: maxLineWidth, kLineModel: klineModel, pricePrecision: dataSource.pricePrecision, amountPrecision: dataSource.amountPrecision)
        }
    }
    
    func showTouch(lineData: LineData) {
        guard let `dataSource` = dataSource else { return }
        
        let tips = dataSource.getCurrentTips(by: dataSource.mainChartType, arrayIndex: lineData.nDataIndex)
        mainNumberView.messages = tips
        
        if !volumeChart.isHidden {
            let tips = dataSource.getCurrentTips(by: dataSource.volumeChartType, arrayIndex: lineData.nDataIndex)
            volumeNumberView.messages = tips
        }
        
        if !assistantChart.isHidden {
            let tips = dataSource.getCurrentTips(by: dataSource.assistantChartType, arrayIndex: lineData.nDataIndex)
            assistantNumberView.messages = tips
        }
    }
    
    func showLongPressed(point: CGPoint) {
        guard let `dataSource` = dataSource else {
            return
        }
        guard dataSource.pointCount > 0 else {
            return
        }
        longPressedPoint.y = point.y
        if point.x + lineInterval > mainChart.frame.width {
            longPressedPoint.x = mainChart.frame.width - lineInterval
        } else if point.x < lineInterval {
            longPressedPoint.x = lineInterval * 0.5
        } else {
            longPressedPoint.x = point.x
        }
        let lineData = mainChart.getCandle(for: longPressedPoint)
        showTouch(lineData: lineData)
        
        if let klineModel = dataSource.getData(from: lineData.nDataIndex) as? CandleLinePriceData {
            longPressShowView.longPressShow(point: CGPoint(x: lineData.x, y: lineData.y), period: period, timeCenterY: timeShowView.center.y, lineWidth: maxLineWidth, kLineModel: klineModel, pricePrecision: dataSource.pricePrecision, amountPrecision: dataSource.amountPrecision)
        }
        
    }
}

// MARK: - Action
extension SlitherView {
    @objc func goToLatest() {
        let offsetX = max(scrollView.contentSize.width - mainChart.bounds.width, 0.0)
        scrollView.contentOffset = CGPoint(x: offsetX, y: 0.0)
        updateKlinePosition()
    }
}

// MARK: - Setup
extension SlitherView {
    
    func setup() {
        CustomFonts.loadFonts()
        setupView()
        setupGesture()
        resetData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name("LoadKLineData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateRefresh), name: NSNotification.Name("ReLoadKLineData"), object: nil)
    }
    
    
    /// 测试数据用
    @objc func refresh() {
        resetData()
    }
    
    @objc func updateRefresh() {
        reloadData()
    }
    
    func setupView() {
        isOpaque = true
        
        mainNumberView = SlitherNumberView(type: .main, style: style)
        volumeNumberView = SlitherNumberView(type: .volume, style: style)
        assistantNumberView = SlitherNumberView(type: .assistant, style: style)
        addSubview(mainNumberView)
        addSubview(volumeNumberView)
        addSubview(assistantNumberView)
        
        logoImageView = UIImageView(image: UIImage(named: "k_line_logo"))
        addSubview(logoImageView)
        
        scrollView = UIScrollView(frame: bounds)
        scrollView.backgroundColor = .clear
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.delegate = self
        scrollView.decelerationRate = .fast
        addSubview(scrollView)
        
        mainChart = ChartView(type: .candle)
        volumeChart = ChartView(type: .volume)
        assistantChart = ChartView(type: .assistant)
        scrollView.addSubview(mainChart)
        scrollView.addSubview(volumeChart)
        scrollView.addSubview(assistantChart)
        
        mainChart.dataSource = self
        volumeChart.dataSource = self
        assistantChart.dataSource = self
        
        timeShowView = TimeShowView()
        latestPriceView = KLineLatestPriceView()
        gotoLatestButton = UIButton(type: .custom)
        gotoLatestButton.setTitleColor(ColorManager.shared.kColorSecondaryText, for: .normal)
        gotoLatestButton.titleLabel?.font = CustomFonts.DIN.medium.font(ofSize: 9)
        gotoLatestButton.backgroundColor = ColorManager.shared.klineIndexBackgroundGradientColorStart
        gotoLatestButton.layer.borderColor = ColorManager.shared.klineLatestPriceLabelBorderColor.cgColor
        gotoLatestButton.layer.borderWidth = 1.0
        gotoLatestButton.layer.cornerRadius = 10.0
        gotoLatestButton.setImage(UIImage(named: "kline_price_icon"), for: .normal)
        gotoLatestButton.addTarget(self, action: #selector(goToLatest), for: .touchUpInside)
        gotoLatestButton.isHidden = true
        longPressShowView = LongPressShowView()
        longPressShowView.isHidden = true
        addSubview(timeShowView)
        addSubview(latestPriceView)
        addSubview(gotoLatestButton)
        addSubview(longPressShowView)
        longPressShowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        logoImageView.snp.makeConstraints {
            $0.left.equalTo(mainNumberView).offset(10)
            $0.bottom.equalTo(mainNumberView).offset(-10)
        }
    }
    
    func setupGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(onPinch(recognizer:)))
        addGestureRecognizer(pinchGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTap(recognizer:)))
        addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(recognizer:)))
        longPressGesture.minimumPressDuration = 0.25
        addGestureRecognizer(longPressGesture)
    }
        
    public func updateAllViews() {
        resetMaxLineWidth()
        
        lineInterval = maxLineWidth + 2.0
        
        let viewWidth: CGFloat = bounds.width
        
        volumeNumberView.isHidden = volumeViewChartType == .assistant_hide
        volumeChart.isHidden = volumeViewChartType == .assistant_hide
        assistantNumberView.isHidden = assistantViewChartType == .assistant_hide
        assistantChart.isHidden = assistantViewChartType == .assistant_hide
                
        if isFullView {
            if assistantViewChartType == .assistant_hide {
                
            } else {
                if volumeViewChartType == .assistant_hide {
                    assistantNumberView.frame = CGRect(x: 0.0, y: bounds.height - Constants.assistantViewHeight, width: bounds.width, height: Constants.assistantViewHeight)
                } else {
                    assistantNumberView.frame = CGRect(x: 0.0, y: bounds.height - Constants.assistantViewHeight, width: bounds.width, height: Constants.assistantViewHeight)
                }
                timeShowView.frame = CGRect(x: 0.0, y: assistantNumberView.frame.maxY, width: viewWidth, height: Constants.timeViewHeight)
            }
        } else {
            timeShowView.frame = CGRect(x: 0.0, y: bounds.height - Constants.timeViewHeight, width: viewWidth, height: Constants.timeViewHeight)
            
            if assistantViewChartType == .assistant_hide && volumeViewChartType == .assistant_hide {
                mainNumberView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: timeShowView.frame.minY)
            } else {
                if assistantViewChartType == .assistant_hide && volumeViewChartType != .assistant_hide {
                    volumeNumberView.frame = CGRect(x: 0.0, y: bounds.height - Constants.timeViewHeight - Constants.assistantViewHeight, width: viewWidth, height: Constants.assistantViewHeight)
                    mainNumberView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: volumeNumberView.frame.minY)
                } else if assistantViewChartType != .assistant_hide && volumeViewChartType == .assistant_hide {
                    assistantNumberView.frame = CGRect(x: 0.0, y: bounds.height - Constants.timeViewHeight - Constants.assistantViewHeight, width: viewWidth, height: Constants.assistantViewHeight)
                    mainNumberView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: assistantNumberView.frame.minY)
                } else {
                    assistantNumberView.frame = CGRect(x: 0.0, y: bounds.height - Constants.timeViewHeight - Constants.assistantViewHeight, width: viewWidth, height: Constants.assistantViewHeight)
                    volumeNumberView.frame = CGRect(x: 0.0, y: assistantNumberView.frame.minY - Constants.assistantViewHeight, width: viewWidth, height: Constants.assistantViewHeight)
                    mainNumberView.frame = CGRect(x: 0.0, y: 0.0, width: viewWidth, height: volumeNumberView.frame.minY)
                }
            }
        }
        
        latestPriceView.frame = mainNumberView.frame
        mainChart.frame = CGRect(x: 0.0, y: mainNumberView.frame.minY + Constants.mainChartTopOffset, width: viewWidth, height: mainNumberView.frame.height - Constants.mainChartTopOffset)
        volumeChart.frame = CGRect(x: 0.0, y: volumeNumberView.frame.minY + Constants.messageViewHeight, width: viewWidth, height: Constants.assistantViewHeight - Constants.messageViewHeight)
        assistantChart.frame = CGRect(x: 0.0, y: assistantNumberView.frame.minY + Constants.messageViewHeight, width: viewWidth, height: Constants.assistantViewHeight - Constants.messageViewHeight)
        
        mainChart.reloadSubViews()
        
        if !volumeChart.isHidden {
            volumeChart.reloadSubViews()
        }
        
        if !assistantChart.isHidden {
            assistantChart.reloadSubViews()
        }
        reloadData()
        
    }
    
    func resetMaxLineWidth() {
//        if let maxWidth = dataSource?.maxWidth {
//            self.maxLineWidth = maxWidth
//        }
        
        self.maxLineWidth = Constants.defaultCandleLineWidth
    }
    
    func showNewestPriceMessage() {
        /// 长按显示时，需要显示对应的指标值
        
        let pressedType = longPressShowView.pressedType
        
        switch pressedType {
        case .none:
            if let dataSource = dataSource {
                let tips = dataSource.getNewCurrentViewByType(dataSource.mainChartType)
                mainNumberView.messages = tips
                
                if !volumeChart.isHidden {
                    let tips = dataSource.getNewCurrentViewByType(dataSource.volumeChartType)
                    volumeNumberView.messages = tips
                }
                
                if !assistantChart.isHidden {
                    let tips = dataSource.getNewCurrentViewByType(dataSource.assistantChartType)
                    assistantNumberView.messages = tips
                }
            }
        case .short:
            break
        case .long:
            break
        }
    }
    
    
    /// 显示最新价格指示线
    /// - Parameter contentShowIndex
    func showLastPrice(contentShowIndex: Int) {
        
        guard let `dataSource` = dataSource else {
            return
        }
        
        if let candleData = dataSource.backLastData(for: mainViewChartType, index: 0) as? CandleLinePriceData {
            /// latest price text
            let currentPrice = KLineNumberFormatter.format(candleData.closePrice, precision: dataSource.pricePrecision)
                //KLineTextFormatter.format(price: candleData.closePrice, precision: dataSource.pricePrecision)
            
            /// limit latest price to mainChart.minPrice --- mainChart.maxPrice
            let closePrice = max(mainChart.minPrice.doubleValue, min(mainChart.maxPrice.doubleValue, candleData.closePrice.doubleValue))
            
            var dValue = mainChart.maxPrice.doubleValue - mainChart.minPrice.doubleValue
            if dValue <= 0.0 {
                dValue = 1.0
            }
            
            /// 计算当前价格的y值
            let pointY = SlitherPriceCommon.getY(from: mainChart, dValue: dValue, current: closePrice, isMainView: true) + Double(Constants.mainChartTopOffset)
            // TODO: LeftWidth
            let rightNumbers = dataSource.pointCount - contentShowIndex
            
            /// 最新价格的点
            let pointX = ((Double(lineInterval) - 2.0) * 0.5 + Double(rightNumbers - 1) * Double(lineInterval))
            
            let showLatestButton = latestPriceView.show(price: currentPrice, point: CGPoint(x: pointX, y: pointY), showPoint: period == .timeline)
            if showLatestButton {
                gotoLatestButton.setTitle(currentPrice, for: .normal)
                gotoLatestButton.isHidden = false
                gotoLatestButton.sizeToFit()
                let imageSize = gotoLatestButton.image(for: .normal)!.size
                gotoLatestButton.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: imageSize.width - 5, bottom: 0.0, right: imageSize.width + 5)
                let textLabelSize = gotoLatestButton.titleLabel!.bounds
                gotoLatestButton.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: textLabelSize.width + 3, bottom: 0.0, right: -textLabelSize.width - 3)
                let width = Double(gotoLatestButton.frame.width) + 17.0
                let buttonX = Double(bounds.width) / 5.0 * 4.0 - width * 0.5
                gotoLatestButton.frame = CGRect(x: buttonX, y: pointY - 10.0, width: width, height: 20.0)
            } else {
                gotoLatestButton.isHidden = true
            }
        } else {
            latestPriceView.isHidden = true
            gotoLatestButton.isHidden = true
        }
    }
}

extension SlitherView: ChartViewDataSource {
    var currentMaxWidth: CGFloat {
        return maxLineWidth
    }
    
    var period: PeriodType {
        return dataSource?.currentPeriod ?? .min
    }
    
    func numberOfLines(in chartView: ChartView) -> Int {
        return dataSource?.numberOfAssistantLines(for: getChartType(from: chartView)) ?? 0
    }
    
    func kLine(for chartView: ChartView, atIndex: Int) -> KLine {
        guard let `dataSource` = dataSource else {
            return KLine(type: .solid)
        }
        
        let chartType = getChartType(from: chartView)
        let kLine = dataSource.assistantChartViewLine(from: atIndex, chartType: chartType)
        return kLine
    }
    
    func updatePoints(of chartView: ChartView, kLine: KLine, atIndex: Int) {
        guard let `dataSource` = dataSource else {
            return
        }
        
        lineInterval = maxLineWidth + 2.0

        var startIndex = max(0, Int(scrollView.contentOffset.x / CGFloat(lineInterval)))
        
        let width = chartView.bounds.width + scrollView.contentOffset.x
        var endIndex = Int(width / lineInterval)
        if endIndex > dataSource.pointCount - 1 {
            endIndex = dataSource.pointCount - 1
        }
        
        let isMainView = chartView == mainChart
        
        var dValue = chartView.maxPrice.doubleValue - chartView.minPrice.doubleValue
        if dValue <= 0.0 {
            dValue = 1.0
        }
        
        /// 用来计算分时线是昨天还是当天的
        var lastData = CandleLinePriceData()
        /// control point offset
        var cpOffsetCount: Int = 0
        lastData.time = Int(Date().timeIntervalSince1970)
        if kLine is AreaLine {
            if let data = dataSource.backLastData(for: getChartType(from: chartView), index: atIndex) as? CandleLinePriceData {
                lastData = data
            }
        }
        
        /// 往前后多取数据，画到屏幕边缘
        if kLine is SolidLine || kLine is AreaLine {
            cpOffsetCount = startIndex - max(min(startIndex-2, startIndex-1), 0)
            startIndex = startIndex - cpOffsetCount
            endIndex = min(endIndex + 1, dataSource.pointCount - 1)
        }
        
        var datas: [KLineData] = []
        let priceDatas: [KLineModel] = dataSource.backArray(for: getChartType(from: chartView), index: atIndex, start: startIndex, end: endIndex)
        
        for (n, priceData) in priceDatas.enumerated() {
            let x = (Double(lineInterval) - 2.0) * 0.5 + (Double(n - cpOffsetCount) * Double(lineInterval))
            switch kLine {
            case is SolidLine:
                if let data = priceData as? LinePriceData {
                    let lineData = SlitherPriceCommon.getSolidData(data: data, chartView: chartView, dValue: dValue, x: x, isMainView: isMainView)
                    datas.append(lineData)
                }
            case is CandleLine:
                if let data = priceData as? CandleLinePriceData {
                    let candleData = SlitherPriceCommon.getCandleData(data: data, chartView: chartView, dValue: dValue, x: x, isMainView: isMainView, index: n + startIndex)
                    datas.append(candleData)
                }
            case is ColumnarLine:
                if let data = priceData as? ColumnarPriceData {
                    let columnarData = SlitherPriceCommon.getColumnarData(data: data, chartView: chartView, dValue: dValue, x: x, isMainView: isMainView)
                    datas.append(columnarData)
                }
            case is AreaLine:
                if let data = priceData as? CandleLinePriceData {
                    let areaData = SlitherPriceCommon.getAreaData(data: data, chartView: chartView, dValue: dValue, x: x, isMainView: isMainView, index: n + startIndex, lastData: lastData)
                    datas.append(areaData)
                }
            default:
                break
            }
        }
        
        kLine.points = datas
    }
    
    func getChartType(from chartView: ChartView) -> ChartType {
        if chartView == mainChart {
            return mainViewChartType
        } else if chartView == volumeChart {
            return volumeViewChartType
        } else {
            return assistantViewChartType
        }
    }
}

extension SlitherView {
    func setTheLimitPrice(start: Int, end: Int) {
        
        guard let `dataSource` = dataSource else {
            return
        }
        
        dataSource.getTheLimitPrice(for: mainViewChartType, start: start, end: end) { (max, min) in
            mainChart.maxPrice = max
            mainChart.minPrice = min
            mainNumberView.changeNumber(max: max, min: min, chartType: getChartType(from: mainChart), pricePrecision: dataSource.pricePrecision, amountPrecision: dataSource.amountPrecision)
        }
        
        if !volumeChart.isHidden {
            dataSource.getTheLimitPrice(for: volumeViewChartType, start: start, end: end) { (max, min) in
                volumeChart.maxPrice = max
                volumeChart.minPrice = min
                volumeNumberView.changeNumber(max: max, min: min, chartType: getChartType(from: volumeChart), pricePrecision: dataSource.pricePrecision, amountPrecision: dataSource.amountPrecision)
            }
        }
        
        if !assistantChart.isHidden {
            dataSource.getTheLimitPrice(for: assistantViewChartType, start: start, end: end) { (max, min) in
                assistantChart.maxPrice = max
                assistantChart.minPrice = min
                assistantNumberView.changeNumber(max: max, min: min, chartType: getChartType(from: assistantChart), pricePrecision: dataSource.pricePrecision, amountPrecision: dataSource.amountPrecision)
            }
        }
    }
}
