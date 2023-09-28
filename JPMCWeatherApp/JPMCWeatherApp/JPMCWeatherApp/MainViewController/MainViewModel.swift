//
//  MainViewModel.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/25/23.
//

import Foundation
protocol MainViewModelDelegate: AnyObject {
    func updateTablewith()
    func dataError()
    func noDataToShow()
    func showLoadingData()
}


class MainViewModel {
    static let shared = MainViewModel()
    weak var delegate: MainViewModelDelegate?
    private let networkManager: NetworkManager = .shared
    private var cityToSearch = ""
    private var currentCity: City? {
        didSet {
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(currentCity)
                UserDefaults.standard.set(data, forKey: "LastCitySaved")
            } catch {
                print("Unable to Encode Note (\(error))")
            }
        }
    }
    private init(){}
    
    func getSavedData() {
        if let data = UserDefaults.standard.data(forKey: "LastCitySaved") {
            do {
                let decoder = JSONDecoder()
                let city = try decoder.decode(City.self, from: data)
                currentCity = city
                delegate?.updateTablewith()
            } catch {
                delegate?.noDataToShow()
                print("Unable to Decode Note (\(error))")
            }
        } else {
            delegate?.noDataToShow()
        }
    }
    
    func getCurrentCity() -> City? {
        guard let city = self.currentCity else {return nil}
        return city
    }
    
    func getCurrentLocationInfo(_ lat: Double, _ lon: Double) {
        guard let del = delegate else {
            print("No delegate set")
            return
        }
        networkManager.getDataForLocationWith(lat: lat, lon: lon) { [weak self] result in
            switch result {
            case.success(let newCity):
                self?.currentCity = newCity
                del.updateTablewith()
            case.failure(_):
                del.dataError()
            }
        }
    }
    
    func setCityToSearch(_ city: String) {
        self.cityToSearch = city
        guard let del = delegate else {
            print("No delegate set")
            return
        }
        del.showLoadingData()
        networkManager.getDataFromCity(cityName: self.cityToSearch) {  [weak self] result in
            switch result {
            case.success(let newCity):
                self?.currentCity = newCity
                del.updateTablewith()
            case.failure(_):
                del.dataError()
            }
        }
    }
    
}
