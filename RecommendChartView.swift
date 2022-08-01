

import Foundation
import SwiftUI
import Highcharts

// HIGHCHARTS IOS

struct RecommendaChartView: UIViewRepresentable {
    
    @Binding var StrongBuyList: [Int]
    @Binding var StronSelllList: [Int]
    @Binding var SelllList: [Int]
    @Binding var HoldList: [Int]
    @Binding var timeStamp: [String]
    @Binding var BuyList: [Int]
    
    func makeUIView(context: Context) -> some HIChartView {
        let chartView = HIChartView(frame: CGRect(x: -50, y: 0, width:420, height:500))
        
        let options = HIOptions()
        
        // CHART OPTIONS
        let chart = HIChart()
        chart.type = "column"
        options.chart = chart
        
        // CHART TITLE OPTIONS
        let title = HITitle()
        title.text = "Recommendation Trends"
        options.title = title
        
        // X-AXIS OPTIONS SET
        let xAxis = HIXAxis()
        xAxis.categories = timeStamp
        options.xAxis = [xAxis]
        
        //Y-AXIS OPTIONS SET
        let yAxis = HIYAxis()
        yAxis.min = 0
        yAxis.title = HITitle()
        yAxis.title.text = "#Analysis"
        yAxis.stackLabels = HIStackLabels()
        yAxis.stackLabels.enabled = true
        yAxis.stackLabels.style = HICSSObject()
        yAxis.stackLabels.style.fontWeight = "bold"
        yAxis.stackLabels.style.color = "gray"
        options.yAxis = [yAxis]
        
        
        // LEGEND -> FOR MAPPING THE TABLE WITH CATGORIES
        // SETTING LEGEND OPTIONS
        
        let legend = HILegend()
        legend.align = "left"
//        legend.x = -30
        legend.verticalAlign = "bottom"
        legend.width = "100%"
//        legend.y = 25
        legend.floating = false // TO KEEP IT AT THE BOTTOM OF THE CHART
        legend.backgroundColor = HIColor(name: "white")
        legend.borderColor = HIColor(hexValue: "CCC")
        legend.borderWidth = 1
        legend.shadow = HICSSObject()
        legend.shadow.opacity = 0
        options.legend = legend
        
        let tooltip = HITooltip()
        tooltip.headerFormat = "<b>{point.x}</b><br/>"
        tooltip.pointFormat = "{series.name}: {point.y}<br/>Total: {point.stackTotal}"
        options.tooltip = tooltip
        
        let plotOptions = HIPlotOptions()
        plotOptions.series = HISeries()
        plotOptions.series.stacking = "normal"
        let dataLabels = HIDataLabels()
        dataLabels.enabled = true
        plotOptions.series.dataLabels = [dataLabels]
        options.plotOptions = plotOptions
        
        
        let StrongBuy = HIColumn()
        StrongBuy.name = "Strong Buy"
        StrongBuy.data = StrongBuyList
        StrongBuy.color = HIColor(hexValue: "38702A")
        
        let Buy = HIColumn()
        Buy.name = "Buy"
        Buy.data = BuyList
        Buy.color = HIColor(hexValue: "41DE30")
        
        
        let Hold = HIColumn()
        Hold.name = "Hold"
        Hold.data = HoldList
        Hold.color = HIColor(hexValue: "C49B14")
        
        let Sell = HIColumn()
        Sell.name = "Sell"
        Sell.data = SelllList
        Sell.color = HIColor(hexValue: "F66060")
        
        let StrongSell = HIColumn()
        StrongSell.name = "Strong Sell"
        StrongSell.data = StronSelllList
        StrongSell.color = HIColor(hexValue: "A60B0B")
        
//
//
//
//        let john = HIColumn()
//        john.name = "John"
//        john.data = [5, 3, 4, 7, 2]
//
//        let jane = HIColumn()
//        jane.name = "Jane"
//        jane.data = [2, 2, 3, 2, 1]
//
//        let joe = HIColumn()
//        joe.name = "Joe"
//        joe.data = [3, 4, 4, 2, 5]
        
        options.series = [StrongBuy, Buy, Hold, Sell, StrongSell]
        
        chartView.options = options
        return chartView
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}
