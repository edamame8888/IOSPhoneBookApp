//
//  TopViewController.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//


import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var defaultIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //background color
        self.view.backgroundColor = UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 20/100)
        //set Default Icon
        defaultIcon.backgroundColor = UIColor.white
        defaultIcon.layer.borderColor = UIColor.gray.cgColor
        defaultIcon.layer.borderWidth = 5
        defaultIcon.layer.cornerRadius = 50
        defaultIcon.layer.masksToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
