//
//  TipsDetailsUIViewController.swift
//  BeautyManager
//
//  Created by Katarzyna Mural on 17/11/2018.
//  Copyright © 2018 Katarzyna Mural. All rights reserved.
//

import UIKit

class TipsDetailsVC: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    var tipDetailsArray: Tip?
    var currentTipsID: Int64 = 0
    var selectedCategory:String = ""
    var cellColor:UIColor = UIColor.clear
    var icon: UIImage? = nil
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleTipLabel: UILabel!
    @IBOutlet weak var imageTipView: UIImageView!
    @IBOutlet weak var textTipView: UITextView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageTip: UIImage

        categoryLabel.textColor = UIColor.gray
        titleTipLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        textTipView.textAlignment = NSTextAlignment.justified
        currentTipsID = (tipDetailsArray?.id)!
        categoryLabel.text = tipDetailsArray?.category
        titleTipLabel.text = tipDetailsArray?.title
        selectedCategory = (tipDetailsArray?.category)!
        imageTip = UIImage(named: (tipDetailsArray!.pictureName))!
        imageTipView.image = imageTip
        
        // this is the file we will write to and read from it
        let file = tipDetailsArray!.tip
        let bundlePath = Bundle.main.path(forResource: "TipsAssets", ofType: "bundle")
        let resourceBundle = Bundle.init(path: bundlePath!)
        
        if let filepath = resourceBundle!.path(forResource: file, ofType: "txt") {
            do {
                let zm = try String(contentsOfFile: filepath, encoding: .utf8)
                textTipView.text = zm
           } catch {
                print("Error")
            }
        }else {
            print("File not found")
        }
        
        if(selectedCategory == "Face"){
            // blue
            icon = UIImage(named: "face")
            cellColor = UIColor.init(red: 114.0/255.0, green: 216.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Hair"){
            icon = UIImage(named: "hair")
            // violet
            cellColor = UIColor.init(red: 211.0/255.0, green: 218.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Nails"){
            icon = UIImage(named: "nails")
            // green
            cellColor = UIColor.init(red: 208.0/255.0, green: 242.0/255.0, blue: 173.0/255.0, alpha: 1.0)
        } else if(selectedCategory == "Body"){
            icon = UIImage(named: "body2")
            // pink
            cellColor = UIColor.init(red: 252.0/255.0, green: 184.0/255.0, blue: 231.0/255.0, alpha: 1.0)
        }
        iconImageView.image = icon
        categoryLabel.backgroundColor = UIColor.clear
        categoryLabel.textColor = cellColor
        titleTipLabel.backgroundColor = cellColor
        titleTipLabel.textColor = UIColor.white
        tipLabel.textColor = cellColor
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let nav = self.navigationController?.navigationBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "te", style: .done, target: self, action: nil)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        imageView.contentMode = .scaleAspectFit
        imageView.center = nav!.center
        let image = UIImage(named: "Colorfull")
        imageView.image = image
        navigationItem.titleView = imageView
    } 
}
