//
//  ScheduleChartJoin.swift
//  GroceryBuddy
//
//  Created by Andy Chai on 12/4/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import SwiftUI
import Charts

class ScheduleChartController: UIViewController {
    var barChartView: BarChartView!
    
    var num_recipes: [Int]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        barChartView = BarChartView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 110))
        
        setChart()
        barChartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        let intArray = num_recipes.count + 1
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: (1...intArray).map(String.init))
        barChartView.xAxis.labelCount = num_recipes.count
        barChartView.xAxis.granularityEnabled = true
        barChartView.xAxis.granularity = 1
        
        barChartView.backgroundColor = .white
        view.backgroundColor = .lightGray
        view.addSubview(barChartView)
    }

    func setChart() {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<num_recipes.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(num_recipes![i]))
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Number of Recipes")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
    }
}



