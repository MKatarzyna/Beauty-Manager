//
//  ChartData.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 18/06/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import Foundation
import UIKit
import SwiftCharts

class ChartData: UIViewController {
    private var chart: Chart?
    
    @IBOutlet weak var chartBaseView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let chartConfig = BarsChartConfig(
            valsAxisConfig: ChartAxisConfig(from: 50, to: 57, by: 1)
        )
        let frame = CGRect(x: 10, y: 70, width: 300, height: 500)
        let chart = BarsChart(
            frame: frame,
            chartConfig: chartConfig,
            xTitle: "Day",
            yTitle: "Weight [kg]",
            bars: [
                ("Mon", 55.5),
                ("Tue", 55.7),
                ("Wed", 55.9),
                ("Thu", 55.6),
                ("Fri", 55.3),
                ("Sat", 55.0),
                ("Sun", 54.8)
            ],
            color: UIColor(red: 45.00/255.0, green: 71.00/255.0, blue: 146.00/255.0, alpha: 1.0),
//            color: UIColor.red,
            barWidth: 30,
            animDuration: 0.5
        )
        //UIcolor.red
//        chart.view.frame = self.chartBaseView.bounds
        chart.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.chartBaseView.addSubview(chart.view)
        self.chart = chart
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
