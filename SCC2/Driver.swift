//
//  Driver.swift
//  SCC2
//
//  Created by Mahfuza Rahman on 9/23/22.
//

import UIKit
import Charts

class Driver: UIViewController {
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // generates each graph
    let accGraphView = LineChartView()
    let gyroGraphView = LineChartView()
    let magGraphView = LineChartView()
    
    // creates the dataset for each graph
    var dataEntriesX = [ChartDataEntry]()
    var dataEntriesY = [ChartDataEntry]()
    var dataEntriesZ = [ChartDataEntry]()
    
    var xValue: Double = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DRIVER"
        setupViews()
        setupInitialDataEntries()
        setupChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // enables the realtime visualization of the graphs
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didUpdatedChartView), userInfo: nil, repeats: true)
    }
    
    @objc func didUpdatedChartView() {
        // create new entries for the x, y, and z axes
        let newDataEntryX = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryY = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryZ = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        
        // update the chart with data for each axis
        updateChartView(with: newDataEntryX, dataEntries: &dataEntriesX, dataSet: 0)
        updateChartView(with: newDataEntryY, dataEntries: &dataEntriesY, dataSet: 1)
        updateChartView(with: newDataEntryZ, dataEntries: &dataEntriesZ, dataSet: 2)
        xValue += 1
    }
    
    func setupViews() {
        // set up accelerometer graph
        view.addSubview(accGraphView)
        accGraphView.translatesAutoresizingMaskIntoConstraints = false
        accGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        accGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        accGraphView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        // set up gyroscope graph
        view.addSubview(gyroGraphView)
        gyroGraphView.translatesAutoresizingMaskIntoConstraints = false
        gyroGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gyroGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 360).isActive = true
        gyroGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        gyroGraphView.heightAnchor.constraint(equalToConstant: 150).isActive = true

        // set up gyroscope graph
        view.addSubview(magGraphView)
        magGraphView.translatesAutoresizingMaskIntoConstraints = false
        magGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        magGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 510).isActive = true
        magGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        magGraphView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
    }
    
    func setupInitialDataEntries() {
        // set up data for x-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntriesX.append(dataEntry)
        }
        // set up data for y-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntriesY.append(dataEntry)
        }
        // set up data for z-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntriesZ.append(dataEntry)
        }
        
    }
    
    func setupChartData() {
        // x-axis dataset
        let chartDataSet = LineChartDataSet(entries: dataEntriesX, label: "x")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        // y-axis dataset
        let chartDataSet2 = LineChartDataSet(entries: dataEntriesY, label: "y")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(NSUIColor.purple)
        chartDataSet2.mode = .linear

        // z-axis dataset
        let chartDataSet3 = LineChartDataSet(entries: dataEntriesZ, label: "z")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(NSUIColor.orange)
        chartDataSet3.mode = .linear
        
        // create a large dataset of all three datasets
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2, chartDataSet3])
        
        // set up accelerometer graph view
        accGraphView.data = chartData
        accGraphView.xAxis.labelPosition = .bottom
        
        // set up gyroscope graph view
        gyroGraphView.data = chartData
        gyroGraphView.xAxis.labelPosition = .bottom

        // set up magnetometer graph view
        magGraphView.data = chartData
        magGraphView.xAxis.labelPosition = .bottom
        
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry], dataSet: Int) {
        // remove front entry
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            accGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
            gyroGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
            magGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
        }
        
        // add most recent entry
        dataEntries.append(newDataEntry)
        accGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
        gyroGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
        magGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
        
        accGraphView.notifyDataSetChanged()
        accGraphView.moveViewToX(newDataEntry.x)
        
        gyroGraphView.notifyDataSetChanged()
        gyroGraphView.moveViewToX(newDataEntry.x)

        magGraphView.notifyDataSetChanged()
        magGraphView.moveViewToX(newDataEntry.x)
    }

}
