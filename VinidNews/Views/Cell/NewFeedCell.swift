//
//  NewFeed2Cell.swift
//  VinidNews
//
//  Created by Apple on 11/28/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class NewFeedCell: UITableViewCell {
    
    @IBOutlet weak var spinerActivity: UIActivityIndicatorView!
    @IBOutlet weak var imageUrl: UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pubdateLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        spinerActivity.startAnimating()
    }
    // configure cell
    
    func configureCell(data:NewsModel){
        let imageString = "https://www.nytimes.com/\(data.thumnail ?? "")"
        self.imageUrl.loadImageUsingCache(withUrl: imageString)
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.subtitle
        self.pubdateLabel.text = getFormattedDate(chain: data.pubdate)
        
    }
    
    // get fomat date
    func getFormattedDate(chain:String) -> String {
        
        let dates = Date()
        
        let components = Calendar.current.dateComponents([.year, .month, .day], from: dates)

        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        let date: Date = dateFormatterGet.date(from: "\(chain)") ?? dateFormatterGet.date(from: "\(components.year!)-02-01T19:10:04+00:00")!
                
        return dateFormatterPrint.string(from: date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
