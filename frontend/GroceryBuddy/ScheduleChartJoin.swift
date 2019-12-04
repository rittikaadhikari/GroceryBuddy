//
//  ScheduleChartJoin.swift
//  GroceryBuddy
//
//  Created by Andy Chai on 12/4/19.
//  Copyright © 2019 Shoji Moto. All rights reserved.
//

import SwiftUI
import Charts

class ScheduleChart: UIViewController {
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        weak var barChartView: BarChartView!
//        self.navigationItem.title = "Chart Schedule"
//
//        barChartView.noDataText = "Please provide data for the chart!"
//        self.view.backgroundColor = .white
//
//
//    }
//
    @IBOutlet weak var barChartView: BarChartView!
    
       override func viewDidLoad() {
           super.viewDidLoad()
    
           // Do any additional setup after loading the view.
           
           let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
           let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
           
        setChart(dataPoints: months, values: unitsSold)
        view.addSubview(barChartView)
           
       }
       
       func setChart(dataPoints: [String], values: [Double]) {
           
           var dataEntries: [ChartDataEntry] = []
           
           for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(x: values[i], y: Double(i))
               dataEntries.append(dataEntry)
           }
           
        let barChartDataSet = BarChartDataSet(entries: dataEntries, label: "Units Sold")
           let barChartData = BarChartData()
           barChartView.data = barChartData
           
           var colors: [UIColor] = []
           
           for i in 0..<dataPoints.count {
               let red = Double(arc4random_uniform(256))
               let green = Double(arc4random_uniform(256))
               let blue = Double(arc4random_uniform(256))
               
               let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
               colors.append(color)
           }
           barChartDataSet.colors = colors
    }
}



