//
//  Driver.swift
//  SCC2
//
//  Created by Mahfuza Rahman on 9/23/22.
//

//import UIKit
//
//class Driver: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "DRIVER"
//
//        // Do any additional setup after loading the view.
//    }
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}

import UIKit
import Charts

class Driver: UIViewController {

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        title = "RIDER"
//        // Do any additional setup after loading the view.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    let accGraphView = LineChartView()
    let gyroGraphView = LineChartView()
    let magGraphView = LineChartView()
    
    var dataEntries = [ChartDataEntry]()
    
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
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(didUpdatedChartView), userInfo: nil, repeats: true)
    }
    
    @objc func didUpdatedChartView() {
        let newDataEntry = ChartDataEntry(x: xValue,
                                          y: Double.random(in: 0...50))
        updateChartView(with: newDataEntry, dataEntries: &dataEntries)
        xValue += 1
    }
    
    func setupViews() {
        // set up accelerometer graph
        view.addSubview(accGraphView)
        accGraphView.translatesAutoresizingMaskIntoConstraints = false
        accGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        accGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        accGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        accGraphView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // set up gyroscope graph
        view.addSubview(gyroGraphView)
        gyroGraphView.translatesAutoresizingMaskIntoConstraints = false
        gyroGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gyroGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 450).isActive = true
        gyroGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        gyroGraphView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        // set up gyroscope graph
        view.addSubview(magGraphView)
        magGraphView.translatesAutoresizingMaskIntoConstraints = false
        magGraphView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        magGraphView.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 650).isActive = true
        magGraphView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        magGraphView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    func setupInitialDataEntries() {
        // set up data for accelerometer, gyroscope, and magnetometer
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    
    func setupChartData() {
        // acc 1
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "x")
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.setColor(NSUIColor.red)
        chartDataSet.mode = .linear
        
        let chartDataSet2 = LineChartDataSet(entries: dataEntries, label: "y")
        chartDataSet2.drawCirclesEnabled = false
        chartDataSet2.setColor(NSUIColor.purple)
        chartDataSet2.mode = .linear

        let chartDataSet3 = LineChartDataSet(entries: dataEntries, label: "z")
        chartDataSet3.drawCirclesEnabled = false
        chartDataSet3.setColor(NSUIColor.orange)
        chartDataSet3.mode = .linear
        
        // acc 2
        let chartData = LineChartData(dataSets: [chartDataSet, chartDataSet2, chartDataSet3])
        accGraphView.data = chartData
        accGraphView.xAxis.labelPosition = .bottom
        
        // gyro
        gyroGraphView.data = chartData
        gyroGraphView.xAxis.labelPosition = .bottom
        
        // mag
        magGraphView.data = chartData
        magGraphView.xAxis.labelPosition = .bottom
        
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            accGraphView.data?.removeEntry(oldEntry, dataSetIndex: 0)
            gyroGraphView.data?.removeEntry(oldEntry, dataSetIndex: 0)
            magGraphView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        
        dataEntries.append(newDataEntry)
        accGraphView.data?.appendEntry(newDataEntry, toDataSet: 0)
        gyroGraphView.data?.appendEntry(newDataEntry, toDataSet: 0)
        magGraphView.data?.appendEntry(newDataEntry, toDataSet: 0)
        
        accGraphView.notifyDataSetChanged()
        accGraphView.moveViewToX(newDataEntry.x)
        
        gyroGraphView.notifyDataSetChanged()
        gyroGraphView.moveViewToX(newDataEntry.x)
        
        magGraphView.notifyDataSetChanged()
        magGraphView.moveViewToX(newDataEntry.x)
    }

}
