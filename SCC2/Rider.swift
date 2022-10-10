//
//  Rider.swift
//  SCC2
//
//  Created by Mahfuza Rahman on 9/23/22.
//

import UIKit
import Charts
import CoreMotion

class Rider: UIViewController {
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
    var accDataEntriesX = [ChartDataEntry]()
    var accDataEntriesY = [ChartDataEntry]()
    var accDataEntriesZ = [ChartDataEntry]()
    
    var gyroDataEntriesX = [ChartDataEntry]()
    var gyroDataEntriesY = [ChartDataEntry]()
    var gyroDataEntriesZ = [ChartDataEntry]()
    
    var magDataEntriesX = [ChartDataEntry]()
    var magDataEntriesY = [ChartDataEntry]()
    var magDataEntriesZ = [ChartDataEntry]()
    
    var motion = CMMotionManager()
    let queue = OperationQueue()
    
    var xValue: Double = 8

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "RIDER"
        setupViews()
        setupInitialDataEntries()
        setupChartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // enables the realtime visualization of the graphs
        motion.gyroUpdateInterval = 0.1
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didUpdatedChartView), userInfo: nil, repeats: true)
    }
    
    @objc func didUpdatedChartView() {
        // didUpdatedAccChartView()
        didUpdatedGyroChartView()
      //  didUpdatedMagChartView()
        xValue += 1
    }
    
    func didUpdatedAccChartView() {
        // create new entries for the x, y, and z axes
        let newDataEntryX = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryY = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryZ = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        
        // update the chart with data for each axis
        updateAccChartView(with: newDataEntryX, dataEntries: &accDataEntriesX, dataSet: 0)
        updateAccChartView(with: newDataEntryY, dataEntries: &accDataEntriesY, dataSet: 1)
        updateAccChartView(with: newDataEntryZ, dataEntries: &accDataEntriesZ, dataSet: 2)
    }
    
    func didUpdatedGyroChartView() {
        // create new entries for the x, y, and z axes
        // !!!! INITIALLY GOING TO BE RANDOM VALUES UNLESS TESTED ON IOS DEVICE !!!!
        var newDataEntryX = ChartDataEntry(x: xValue,
                                           y: Double.random(in: 0...50))
        var newDataEntryY = ChartDataEntry(x: xValue,
                                           y: Double.random(in: 0...50))
        var newDataEntryZ = ChartDataEntry(x: xValue,
                                           y: Double.random(in: 0...50))
        
        motion.startGyroUpdates(to: self.queue){ (data: CMGyroData?, error: Error?) in
            if let trueData = data {
                newDataEntryX = ChartDataEntry(x: self.xValue,
                                               y: trueData.rotationRate.x)
                newDataEntryY = ChartDataEntry(x: self.xValue,
                                               y: trueData.rotationRate.y)
                newDataEntryZ = ChartDataEntry(x: self.xValue,
                                               y: trueData.rotationRate.z)
            }
        }
        
        // update the gyroscope chart with data for each axis
        updateGyroChartView(with: newDataEntryX, dataEntries: &gyroDataEntriesX, dataSet: 0)
        updateGyroChartView(with: newDataEntryY, dataEntries: &gyroDataEntriesY, dataSet: 1)
        updateGyroChartView(with: newDataEntryZ, dataEntries: &gyroDataEntriesZ, dataSet: 2)
    }
    
    func didUpdatedMagChartView() {
        // create new entries for the x, y, and z axes
        let newDataEntryX = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryY = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        let newDataEntryZ = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        
        // update the chart with data for each axis
        updateMagChartView(with: newDataEntryX, dataEntries: &magDataEntriesX, dataSet: 0)
        updateMagChartView(with: newDataEntryY, dataEntries: &magDataEntriesY, dataSet: 1)
        updateMagChartView(with: newDataEntryZ, dataEntries: &magDataEntriesZ, dataSet: 2)
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
        setupInitialAccDataEntries()
        setupInitialGyroDataEntries()
        setupInitialMagDataEntries()
    }
    
    func setupInitialAccDataEntries() {
        // set up data for x-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            accDataEntriesX.append(dataEntry)
        }
        // set up data for y-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            accDataEntriesY.append(dataEntry)
        }
        // set up data for z-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            accDataEntriesZ.append(dataEntry)
        }
        
    }
    
    func setupInitialGyroDataEntries() {
        // set up data for x-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            gyroDataEntriesX.append(dataEntry)
        }
        // set up data for y-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            gyroDataEntriesY.append(dataEntry)
        }
        // set up data for z-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            gyroDataEntriesZ.append(dataEntry)
        }
    }
    
    func setupInitialMagDataEntries() {
        // set up data for x-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            magDataEntriesX.append(dataEntry)
        }
        // set up data for y-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            magDataEntriesY.append(dataEntry)
        }
        // set up data for z-axis
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            magDataEntriesZ.append(dataEntry)
        }
        
    }
    
    func setupChartData(){
        setupAccChartData()
        setupGyroChartData()
        setupMagChartData()
    }
    
    func setupAccChartData() {
        // x-axis dataset
        let chartDataSet = LineChartDataSet(entries: accDataEntriesX, label: "x")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        // y-axis dataset
        let chartDataSet2 = LineChartDataSet(entries: accDataEntriesY, label: "y")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(NSUIColor.purple)
        chartDataSet2.mode = .linear

        // z-axis dataset
        let chartDataSet3 = LineChartDataSet(entries: accDataEntriesZ, label: "z")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(NSUIColor.orange)
        chartDataSet3.mode = .linear
        
        // create a large dataset of all three datasets
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2, chartDataSet3])
        
        // set up accelerometer graph view
        accGraphView.data = chartData
        accGraphView.xAxis.labelPosition = .bottom
        
        // set up gyroscope graph view
//        gyroGraphView.data = chartData
//        gyroGraphView.xAxis.labelPosition = .bottom
//
//        // set up magnetometer graph view
//        magGraphView.data = chartData
//        magGraphView.xAxis.labelPosition = .bottom
        
    }
    
    func setupGyroChartData() {
        // x-axis dataset
        let chartDataSet = LineChartDataSet(entries: gyroDataEntriesX, label: "x")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        // y-axis dataset
        let chartDataSet2 = LineChartDataSet(entries: gyroDataEntriesY, label: "y")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(NSUIColor.purple)
        chartDataSet2.mode = .linear

        // z-axis dataset
        let chartDataSet3 = LineChartDataSet(entries: gyroDataEntriesZ, label: "z")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(NSUIColor.orange)
        chartDataSet3.mode = .linear
        
        // create a large dataset of all three datasets
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2, chartDataSet3])

        // set up gyroscope graph view
        gyroGraphView.data = chartData
        gyroGraphView.xAxis.labelPosition = .bottom

    }
    
    func setupMagChartData() {
        // x-axis dataset
        let chartDataSet = LineChartDataSet(entries: magDataEntriesX, label: "x")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        // y-axis dataset
        let chartDataSet2 = LineChartDataSet(entries: magDataEntriesY, label: "y")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(NSUIColor.purple)
        chartDataSet2.mode = .linear

        // z-axis dataset
        let chartDataSet3 = LineChartDataSet(entries: magDataEntriesZ, label: "z")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(NSUIColor.orange)
        chartDataSet3.mode = .linear
        
        // create a large dataset of all three datasets
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2, chartDataSet3])
        
        // set up magnetometer graph view
        magGraphView.data = chartData
        magGraphView.xAxis.labelPosition = .bottom
        
    }
    
    func updateAccChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry], dataSet: Int) {
        // remove front entry
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            accGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
//            gyroGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
//            magGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
        }
        
        // add most recent entry
        dataEntries.append(newDataEntry)
        accGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
//        gyroGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
//        magGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
//
        accGraphView.notifyDataSetChanged()
        accGraphView.moveViewToX(newDataEntry.x)
        
//        gyroGraphView.notifyDataSetChanged()
//        gyroGraphView.moveViewToX(newDataEntry.x)
//
//        magGraphView.notifyDataSetChanged()
//        magGraphView.moveViewToX(newDataEntry.x)
    }
    
    func updateGyroChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry], dataSet: Int) {
        // remove front entry
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            gyroGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
        }
        
        // add most recent entry
        dataEntries.append(newDataEntry)
        gyroGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
       
        gyroGraphView.notifyDataSetChanged()
        gyroGraphView.moveViewToX(newDataEntry.x)
    }
    
    func updateMagChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry], dataSet: Int) {
        // remove front entry
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            magGraphView.data?.removeEntry(oldEntry, dataSetIndex: dataSet)
        }
        
        // add most recent entry
        dataEntries.append(newDataEntry)
        magGraphView.data?.appendEntry(newDataEntry, toDataSet: dataSet)
       
        magGraphView.notifyDataSetChanged()
        magGraphView.moveViewToX(newDataEntry.x)
    }

}
