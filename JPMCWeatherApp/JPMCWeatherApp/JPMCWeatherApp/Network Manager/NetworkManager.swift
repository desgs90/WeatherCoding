//
//  NetworkManager.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/26/23.
//

/*
 Conver city in lat lon
 http://api.openweathermap.org/geo/1.0/direct?q={city name},{state code},{country code}&limit={limit}&appid={API key}
 Request weather
 https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
 
 */
import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let apiKey = "0c0b3e99f6443bf0992446f17c67a448"
    
    private init(){}
    
    func getDataForLocationWith(lat: Double, lon: Double, completation: @escaping (Result<City,CustomError>) -> ()) {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&units=imperial&appid=\(apiKey)") else {
            completation(.failure(.apiError))
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { cityData, _, error in
            if let error = error {
                completation(.failure(.apiError))
                return
            }
            guard let data = cityData else {
                completation(.failure(.apiError))
                return
            }
            do {
                let parseCity = try JSONDecoder().decode(City.self, from: data)
                completation(.success(parseCity))
            } catch {
                completation(.failure(.parsingError))
            }
        }
        session.resume()
    }
    
    func getDataFromCity(cityName: String, completation: @escaping (Result<City,CustomError>) -> ()) {
        //https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),US&units=imperial&&appid=\(apiKey)") else {
            completation(.failure(.apiError))
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared.dataTask(with: request) { cityData, _, error in
            if let error = error {
                completation(.failure(.apiError))
                return
            }
            guard let data = cityData else {
                completation(.failure(.apiError))
                return
            }
            do {
                let parseCity = try JSONDecoder().decode(City.self, from: data)
                completation(.success(parseCity))
            } catch {
                completation(.failure(.parsingError))
            }
        }
        session.resume()
    }
}


enum CustomError: Error {
    case apiError
    case parsingError
    case unexpected(code: Int)
}
