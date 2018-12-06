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
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleTipLabel: UILabel!
    @IBOutlet weak var imageTipView: UIImageView!
    @IBOutlet weak var textTipView: UITextView!
    
    var currentTipsID: Int64 = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var imageTip: UIImage

        categoryLabel.textColor = UIColor.gray
        titleTipLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
        textTipView.textAlignment = NSTextAlignment.justified
        
        
        currentTipsID = (tipDetailsArray?.id)!
        categoryLabel.text = tipDetailsArray?.category
        titleTipLabel.text = tipDetailsArray?.title
        
        print(tipDetailsArray!.pictureName)
        
        // scaleAspectFill - wypełnij, scaleAspectFit - dopasowanie
//        imageTipView.contentMode = UIView.ContentMode.scaleAspectFit
        
        imageTip = UIImage(named: (tipDetailsArray!.pictureName))!
        imageTipView.image = imageTip
        
        // this is the file we will write to and read from it
        let file = tipDetailsArray!.tip
        print("FILE!:")
        print(file)
        print("END of FILE")
      
        let bundlePath = Bundle.main.path(forResource: "TipsAssets", ofType: "bundle")
        let resourceBundle = Bundle.init(path: bundlePath!)
        
        if let filepath = resourceBundle!.path(forResource: file, ofType: "txt") {
            print(filepath)
            do {
                let zm = try String(contentsOfFile: filepath,
                                    encoding: .utf8)
                print(zm)
                textTipView.text = zm
           } catch {
                // contents could not be loaded
                print("Error occured")
            }
        }else {
            // example.txt not found!
            print("file not found")
        }
    }
}
