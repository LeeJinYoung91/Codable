//
//  CustomCollectionViewCell.swift
//  J.Codable
//
//  Created by JinYoung Lee on 23/10/2018.
//  Copyright © 2018 JinYoung Lee. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var dogName: UILabel!
    @IBOutlet weak var catName: UILabel!
    @IBOutlet weak var birdName: UILabel!
    
    func bindData(dog:String?, cat:String?, bird:String?) {
        dogName.text = dog
        catName.text = cat
        birdName.text = bird
    }
    
    func didSelect(select:Bool) {
        backgroundColor = select ? UIColor.red : UIColor.orange
    }
}
