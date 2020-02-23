//
//  CompareViewController.swift
//  Labb1MelkerLiljaVG
//
//  Created by Melker Lilja on 2020-02-22.
//  Copyright © 2020 Melker Lilja. All rights reserved.
//

import UIKit
import Charts

class CompareViewController: UIViewController {
    
    @IBOutlet weak var chartView: BarChartView!
    
    var favCity1: String = ""
    var favCity2: String = ""
    var favTemp1: Double = 0
    var favTemp2: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChartUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        barChartUpdate()
    }
    
    func barChartUpdate () {
        chartView.translatesAutoresizingMaskIntoConstraints = false
        var firstCity = [BarChartDataEntry]()
        var secondCity = [BarChartDataEntry]()
        
        let entry = BarChartDataEntry(x: 1.0, y: favTemp1)
        firstCity.append(entry)
        
        let entry2 = BarChartDataEntry(x: 2.0, y: favTemp2)
        secondCity.append(entry2)
        
        let set1 = BarChartDataSet(entries: firstCity, label: favCity1)
        let set2 = BarChartDataSet(entries: secondCity, label: favCity2)
        let favCity1color = UIColor.yellow
        set1.colors = [favCity1color]
        let favCity2color = UIColor.orange
        set2.colors = [favCity2color]
        let data = BarChartData(dataSets: [set1, set2])
        let barWidth = 0.008
        let barSpace = 0.004
        let groupSpace = 0.02
        let groupCount = 1
        data.barWidth = barWidth
        let gg = data.groupWidth(groupSpace: groupSpace, barSpace: barSpace)

        chartView.data = data
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = gg * Double(groupCount)

        set1.drawValuesEnabled = false
        set2.drawValuesEnabled = false
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = true
        chartView.drawBordersEnabled = true
        chartView.chartDescription?.text = "Difference in temperature"
        chartView.chartDescription?.font = UIFont.systemFont(ofSize: 15.0)
        chartView.xAxis.centerAxisLabelsEnabled = true
        chartView.xAxis.granularityEnabled = true
        chartView.xAxis.drawLimitLinesBehindDataEnabled = false
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false

        data.groupBars(fromX: 0, groupSpace: groupSpace, barSpace: barSpace)
        chartView.drawGridBackgroundEnabled = false
        chartView.legend.enabled = true
        chartView.legend.font = UIFont.systemFont(ofSize: 15.0)
        chartView.notifyDataSetChanged()
    }
}

final class MonthNameFormater: NSObject, IAxisValueFormatter {
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        return Calendar.current.shortMonthSymbols[Int(value)]
    }
}
