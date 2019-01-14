//
//  MeasurementsMenuVC.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 14/01/2019.
//  Copyright © 2019 Katarzyna Mural. All rights reserved.
//

import UIKit

class MeasurementsMenuVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
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
