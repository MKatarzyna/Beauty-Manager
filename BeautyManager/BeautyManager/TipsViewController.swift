//
//  TipsViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 30/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class TipsViewController: UIViewController {
    var category:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Face" {
            if let vc = segue.destination as? TipsTableVC {
                vc.selectedCategory = "Face"
            }
        } else if segue.identifier == "Hair" {
            if let vc = segue.destination as? TipsTableVC {
                vc.selectedCategory = "Hair"
            }
        } else if segue.identifier == "Nails" {
            if let vc = segue.destination as? TipsTableVC {
                vc.selectedCategory = "Nails"
            }
        } else if segue.identifier == "Body" {
            if let vc = segue.destination as? TipsTableVC {
                vc.selectedCategory = "Body"
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    }
}
