//
//  CityExtraInfoCell.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/27/23.
//

import UIKit

class CityExtraInfoCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var city: City?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
        self.collectionView.backgroundColor = UIColor(hexString: "#3BADFC")
        
    }
    override func prepareForReuse() {
        self.collectionView.register(UINib(nibName: "CollectionCell", bundle: nil), forCellWithReuseIdentifier: "CollectionCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CityExtraInfoCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //0 Feels Like
        //1 Clouds
        //2 sunrise
        //3 sunset
        //4 pressure
        //5 humidity
        //6 wind Speed
        //7 wind Direction
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath) as? CollectionCell else { return UICollectionViewCell()}
        if let city = self.city {
            switch indexPath.item {
            case 0:
                cell.bottomLabel.text = "Feels Like"
                cell.midLabel.text = "\(city.main.feels_like.rounded(.towardZero).formatted(.number))°"
                cell.backgroundIcon.image = UIImage(systemName: "thermometer.medium")
                break;
            case 1: 
                cell.bottomLabel.text = "Clouds"
                cell.midLabel.text = "\(city.clouds.all.rounded(.towardZero).formatted(.number))%"
                cell.backgroundIcon.image = UIImage(systemName: "cloud.fill")
                break;
            case 2: 
                cell.topLabel.text = "Sunrise"
                let time = self.getCorrectTime(city.timezone, city.sys.sunrise)
                cell.bottomLabel.text = time
                cell.backgroundIcon.image = UIImage(systemName: "sunrise.fill")
                break;
            case 3: 
                cell.topLabel.text = "Sunset"
                let time = self.getCorrectTime(city.timezone, city.sys.sunset)
                cell.bottomLabel.text = time
                cell.backgroundIcon.image = UIImage(systemName: "sunset.fill")
                break;
            case 4: 
                cell.topLabel.text = "Pressure"
                cell.midLabel.text = "\(city.main.pressure)"
                cell.bottomLabel.text = "hPa"
                cell.backgroundIcon.image = UIImage(systemName: "globe.americas.fill")
                break;
            case 5:
                cell.bottomLabel.text = "Humiduty"
                cell.midLabel.text = "\(city.main.humidity)%"
                cell.backgroundIcon.image = UIImage(systemName: "humidity.fill")
                break;
            case 6: 
                cell.topLabel.text = "Wind Speed"
                cell.midLabel.text = "\(city.wind.speed.rounded(.towardZero).formatted(.number))"
                cell.backgroundIcon.image = UIImage(systemName: "wind")
                cell.bottomLabel.text = "mph"
                break;
            case 7: 
                cell.topLabel.text = "Wind Direction"
                cell.midLabel.text = "\(city.wind.deg)°"
                cell.backgroundIcon.image = UIImage(systemName: "safari")
                break;
            default:break;
            }
            
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: 180.0)
    }
    
    private func getCorrectTime(_ timeZone: Double,_ date: Double) -> String {
        let timezoneEpochOffset = (date + Double(timeZone))
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: timeZoneOffsetDate)
    }
}
