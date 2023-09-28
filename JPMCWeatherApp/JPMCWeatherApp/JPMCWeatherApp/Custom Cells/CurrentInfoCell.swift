//
//  CurrentInfoCell.swift
//  JPMCWeatherApp
//
//  Created by Diego Eduardo on 9/25/23.
//

import UIKit

class CurrentInfoCell: UITableViewCell {

    @IBOutlet weak var tempMin: UILabel!
    @IBOutlet weak var weatherDetail: UILabel!
    @IBOutlet weak var cityTemp: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var tempMax: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
