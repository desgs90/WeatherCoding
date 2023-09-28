//
//  ViewController.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/25/23.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
    private let viewModel: MainViewModel = .shared
    private var locationManager: CLLocationManager?
    
    lazy var errorView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        let label = UILabel(frame: view.frame)
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 5
        label.text = "No Data To Show"
        let image = UIImageView(frame: view.frame)
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "sun.max.trianglebadge.exclamationmark")
        image.alpha = 0.1
        view.center = self.view.center
        view.addSubview(image)
        view.addSubview(label)
        return view
    }()
    
    lazy var noDataView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        let label = UILabel(frame: view.frame)
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 5
        label.text = "Get info from your location or search for a city"
        let image = UIImageView(frame: view.frame)
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "xmark.icloud.fill")
        image.alpha = 0.1
        image.contentMode = .scaleAspectFit
        view.center = self.view.center
        view.addSubview(image)
        view.addSubview(label)
        return view
    }()
    
    lazy var loadingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        let label = UILabel(frame: view.frame)
        label.backgroundColor = .clear
        label.textColor = .black
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        label.numberOfLines = 5
        label.text = "Loading data..."
        let image = UIImageView(frame: view.frame)
        image.backgroundColor = .clear
        image.image = UIImage(systemName: "icloud.and.arrow.down")
        image.alpha = 0.1
        view.center = self.view.center
        let activity = UIActivityIndicatorView(frame: view.frame)
        activity.style = .large
        activity.startAnimating()
        view.addSubview(image)
        view.addSubview(label)
        view.addSubview(activity)
        return view
    }()


    @IBOutlet weak var infoTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        self.locationManager?.delegate = self
        self.viewModel.delegate = self
        self.locationManager = CLLocationManager()
        self.locationManager?.requestAlwaysAuthorization()
        self.infoTableView.register(UINib(nibName: "CurrentInfoCell", bundle: nil), forCellReuseIdentifier: "CurrentInfoCell")
        self.infoTableView.register(UINib(nibName: "CityAlertCell", bundle: nil), forCellReuseIdentifier: "CityAlertCell")
        self.infoTableView.register(UINib(nibName: "CityExtraInfoCell", bundle: nil), forCellReuseIdentifier: "CityExtraInfoCell")
    }
    override func viewWillAppear(_ animated: Bool) {
        self.viewModel.getSavedData()
    }
   

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        self.infoTableView.reloadData()
        if self.view.subviews.contains(errorView) {
            errorView.center = self.view.center
        }
        if self.view.subviews.contains(loadingView) {
            loadingView.center = self.view.center
        }
        if self.view.subviews.contains(noDataView) {
            noDataView.center = self.view.center
        }

    }
}

//MARK: - TABLE VIEW FUNCTIONS
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            guard let cell: CurrentInfoCell = tableView.dequeueReusableCell(withIdentifier: "CurrentInfoCell") as? CurrentInfoCell else {return UITableViewCell()}
            cell.backgroundView?.backgroundColor = .clear
            if let city = viewModel.getCurrentCity() {
                cell.cityName.text = "\(city.name)"
                cell.cityTemp.text = "\(city.main.temp.rounded(.towardZero).formatted(.number))°"
                cell.tempMax.text = "H:\(city.main.temp_max.rounded(.towardZero).formatted(.number))°"
                cell.tempMin.text = "L:\(city.main.temp_min.rounded(.towardZero).formatted(.number))°"
                if let weather = city.weather.first {
                    cell.weatherDetail.text = weather.main
                }
            }
            return cell
        }
        
        if section == 1 {
            guard let cell: CityExtraInfoCell = tableView.dequeueReusableCell(withIdentifier: "CityExtraInfoCell") as? CityExtraInfoCell else {return UITableViewCell()}
            cell.backgroundView?.backgroundColor = .clear
            if let city = viewModel.getCurrentCity() {
                cell.city = city
                cell.collectionView.reloadData()
            }
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        if section == 0 {
            return 230
        }
        
        if section == 1 {
            return 180
        }
        
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 1 {
            let view = UIView(frame: CGRect(x: 24, y: 0, width: tableView.frame.width-48, height: 35))
            view.backgroundColor = .clear
            let BGView = UIView(frame: view.frame)
            BGView.backgroundColor = UIColor(hexString: "#3badfc")
            BGView.alpha = 1.0
            BGView.layer.cornerRadius = 10
            BGView.layer.masksToBounds = true
            view.addSubview(BGView)
            let label = UILabel(frame: view.frame)
            label.text = "Details"
            label.textAlignment = .center
            label.backgroundColor = .clear
            label.textColor = .white
            view.addSubview(label)
            return view
        }
        return nil
    }
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        //if alerts
        if section == 1 {
            return 35
        }
        
        return 0
    }
}


//MARK: - BUTTONS ACTIONS
extension MainViewController {
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        if !hasLocationPermission() {
            self.showErrorView()
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if  let latOne = locationManager?.location?.coordinate.latitude ,
            let lonOne = locationManager?.location?.coordinate.longitude
        {
            self.showLoadingView()
            viewModel.getCurrentLocationInfo(Double(latOne), Double(lonOne))

        }
    }
    @IBAction func searhButtonTapped(_ sender: UIButton) {
       
    }
}

//MARK: - LOCATION DELEGATES
extension MainViewController: CLLocationManagerDelegate {
}

//MARK: - UTIL
extension MainViewController {
    
    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        locationAuthorizationStatus =  locationManager.authorizationStatus
        return locationAuthorizationStatus
    }
    
    private func hasLocationPermission() -> Bool {
        var hasPermission = false
        let manager = self.locationAuthorizationStatus()
        
        if CLLocationManager.locationServicesEnabled() {
            switch manager {
                case .notDetermined, .restricted, .denied:
                    hasPermission = false
                case .authorizedAlways, .authorizedWhenInUse:
                    hasPermission = true
                @unknown default:
                    break
            }
        } else {
            hasPermission = false
        }
        
        return hasPermission
    }
    
    private func showErrorView() {
        self.infoTableView.isHidden = true
        self.view.addSubview(self.errorView)
    }
    
    private func showLoadingView() {
        self.infoTableView.isHidden = true
        self.view.addSubview(self.loadingView)
    }
    private func showNoDataView() {
        self.infoTableView.isHidden = true
        self.view.addSubview(self.noDataView)
    }
    
}

extension MainViewController: MainViewModelDelegate {
    func noDataToShow() {
        DispatchQueue.main.async { [weak self] in
            self?.infoTableView.isHidden = true
            self?.loadingView.removeFromSuperview()
            self?.showNoDataView()
        }
    }
    
    func updateTablewith() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.removeFromSuperview()
            self?.errorView.removeFromSuperview()
            self?.noDataView.removeFromSuperview()
            self?.infoTableView.isHidden = false
            self?.infoTableView.reloadData()
        }
    }
    
    func dataError() {
        DispatchQueue.main.async { [weak self] in
            self?.loadingView.removeFromSuperview()
            self?.showErrorView()
        }
    }
    
    func showLoadingData() {
        self.showLoadingView()
    }
}

/*
 Section one, not scrollable
    City Name
    Temp
    Conditions ( Here we just shown the Main )
        Group 2xx: Thunderstorm
        Group 3xx: Drizzle
        Group 5xx: Rain
        Group 6xx: Snow
        Group 7xx: Atmosphere
        Group 800: Clear
        Group 80x: Clouds
    Hight
    Min
 
 If alerts exists
Section 2
 Alerts
 
 *Cancelled*
 Section 3 Summary
    "summary":"Expect a day of partly cloudy with rain"
 
 Section 3, Collection view 2 columns
    1 feels_like
        Temp
    2 Condtions details
        icon background
        Description
    3 sunrise
        sunrise image
        time
    4 sunset
        sunse image
        time
 
*/
