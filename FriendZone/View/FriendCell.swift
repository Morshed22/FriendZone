//
//  FriendCell.swift
//  FriendZone
//
//  Created by Morshed Alam on 3/3/18.
//  Copyright © 2018 GG. All rights reserved.
//

import UIKit

class FriendCell: UITableViewCell {
    
    
@IBOutlet weak var friendName: UILabel!
    
@IBOutlet weak var phoneNumber: UILabel!
    
    var viewModel:FriendCellViewModel?{
        didSet{
            guard let viewModel = viewModel else { return }
            friendName.text = viewModel.fullName
            phoneNumber.text = viewModel.phonenumberText
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        viewModel = nil
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
