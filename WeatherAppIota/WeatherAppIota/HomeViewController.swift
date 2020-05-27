//
//  ViewController.swift
//  WeatherAppIota
//
//  Created by Kendall Poindexter on 5/27/20.
//  Copyright © 2020 Kendall Poindexter. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    enum Section {
        case main
    }
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var forcastTableView: UITableView!
    
    private let viewModel = HomeViewModel()
    private var dataSource: UITableViewDiffableDataSource<Section, DailyWeatherForcast>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setLocationManagerDelegate()
        viewModel.requestLocation()
        configureDataSource()
        viewModel.delegate = self
        reloadUI()
    }
    
    private func configureDataSource() {
        dataSource = UITableViewDiffableDataSource(tableView: forcastTableView, cellProvider: { (tableView, indexPath, dailyWeatherForcast) -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "forcastCell", for: indexPath) as? ForcastTableViewCell
            cell?.dayLabel.text = self.formatDate(timeStamp: dailyWeatherForcast.day)
            cell?.forcastLowTemp.text = "low: \(dailyWeatherForcast.temp.lowTemp)"
            cell?.forcastHighTemp.text = "high: \(dailyWeatherForcast.temp.highTemp)"
            
            return cell
        })
    }
    
    private func updateTableViewUI() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, DailyWeatherForcast>()
        snapShot.appendSections([.main])
        snapShot.appendItems(viewModel.dailyWeatherForcasts)
        dataSource?.apply(snapShot)
    }
    
    private func formatDate(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }


}

extension HomeViewController: HomeViewModelDelegate {
    func reloadUI() {
        cityLabel.text = "\(viewModel.city), \(viewModel.state)"
        weatherDescriptionLabel.text = viewModel.currentWeatherDescription
        currentTempLabel.text = String(viewModel.currentTemp)
        updateTableViewUI()
    }
    
    
}
