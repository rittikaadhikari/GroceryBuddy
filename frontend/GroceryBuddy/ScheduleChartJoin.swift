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
    
    var months: [String]!

    override func viewDidLoad()
    {
        super.viewDidLoad()
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        barChartView = BarChartView(frame: CGRect(x: 0, y: 100, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 110))
        
        setChart()
        barChartView.backgroundColor = .white
        view.backgroundColor = .lightGray
        view.addSubview(barChartView)
    }

    func setChart()
    {

        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        let test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count
       {
            let dataEntry = BarChartDataEntry(x: Double(test[i]), y: Double(unitsSold[i]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChartView.data = chartData
    }
}



