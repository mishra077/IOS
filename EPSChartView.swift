//
//  ESPChartView.swift
//  StockSearch2
//
//  Created by Manish on 5/1/22.
//

import Foundation
import SwiftUI
import Highcharts

struct EPSChartView: UIViewRepresentable{
    
    @Binding var XaxisData: [String]
    @Binding var ActualData: [Double]
    @Binding var EstimateData: [Double]
//    var chartView: HIChartView!
    
    func makeUIView(context: Context) -> some HIChartView {
        
        let chartView = HIChartView(frame: CGRect(x: 0, y: 0, width:420, height:300))
        chartView.plugins = ["series-label"]
        
        let options = HIOptions()
        
        let chart = HIChart()
        chart.type = "spline"
        options.chart = chart
        
        let title = HITitle()
        title.text = "Historical EPS SUrprises"
        options.title = title
        
//        let subtitle = HISubtitle()
//        subtitle.text = "Source: WorldClimate.com"
//        options.subtitle = subtitle
        
        let xAxis = HIXAxis()
//        xAxis.categories = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        xAxis.categories = self.XaxisData
        xAxis.labels = HILabels()
        xAxis.labels.rotation = -45
        options.xAxis = [xAxis] // ["period </br> Surprise: surprise value] type: [String]
        
        let yAxis = HIYAxis()
        yAxis.title = HITitle()
        yAxis.title.text = "Quaterly EPS"
        options.yAxis = [yAxis]
        
        let plotOptions = HIPlotOptions()
        plotOptions.spline = HISpline()
        plotOptions.spline.marker = HIMarker()
        plotOptions.spline.marker.radius = 4
        plotOptions.spline.marker.lineColor = "#666666"
        plotOptions.spline.marker.lineWidth = 1
        options.plotOptions = plotOptions
        
//        let dataLabels = HIDataLabels()
//        dataLabels.enabled = true
//        plotOptions.line.dataLabels = [dataLabels]
        
//        plotOptions.line.enableMouseTracking = false
//        options.plotOptions = plotOptions
//        print(self.EstimateData)
//        print("######")
//        print(self.ActualData)
//        let tokyo = HILine()
//        tokyo.name = "Tokyo"
//        tokyo.data = [7.0, 6.9, 9.5, 14.5, 18.4, 21.5, 25.2, 26.5, 23.3, 18.3, 13.9, 9.6]
//
//        let london = HILine()
//        london.name = "London"
//        london.data = [3.9, 4.2, 5.7, 8.5, 11.9, 15.2, 17.0, 16.6, 14.2, 10.3, 6.6, 4.8]
        
        let Actual = HISpline()
        Actual.name = "Actual"
        Actual.marker = HIMarker()
        Actual.marker.symbol = "circle"
        Actual.data = self.ActualData // type: [Double]
        
        let Estimate = HISpline()
        Estimate.name = "Estimate"
        Estimate.marker = HIMarker()
        Estimate.marker.symbol = "square"
        Estimate.data = self.EstimateData //type: [Double]
        
        options.series = [Actual , Estimate]
        
        chartView.options = options
        
        return chartView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
