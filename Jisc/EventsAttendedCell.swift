//
//  EventsAttendedCell.swift
//  Jisc
//
//  Created by Marjana on 17.08.17.
//  Copyright © 2017 XGRoup. All rights reserved.
//

import UIKit

let kEventsAttendedCellNibName = "EventsAttendedCell"
let kEventsAttendedCellIdentifier = "EventsAttendedCell"

class EventsAttendedCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var moduleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dateLabel.text = ""
        timeLabel.text = ""
        activityLabel.text = ""
        moduleLabel.text = ""
    }
    
    func loadEvents(events:EventsAttendedObject){
        dateFormatter.dateFormat = "dd/MM/yy"
        dateLabel.text = dateFormatter.string(from: events.date)
        dateFormatter.dateFormat = "hh:mm"
        timeLabel.text = dateFormatter.string(from: events.date)
        activityLabel.text = events.activity
        moduleLabel.text = events.module
    }
}
