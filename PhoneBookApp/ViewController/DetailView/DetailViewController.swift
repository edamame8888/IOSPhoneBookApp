//
//  DetailViewController.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//


import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var userTelLabel: UILabel!
    @IBOutlet weak var TopView: UIView!
    @IBOutlet weak var memoTitle: UILabel!
    @IBOutlet weak var userMemoTextView: UITextView!
    @IBOutlet weak var telButton: UIButton!
    
    var userId: String = ""
    var phoneNumber : String = ""
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get DB and set Label
        do {
            let realm = try Realm()
            let object = realm.objects(PhoneBookData.self).filter("id == %@", userId).last
            if object != nil {
                //今後拡張できるようにstackViewを採用
                let TopVC = childViewControllers[0] as! TopViewController
                
                TopVC.userNameLabel.text = String(object!.familyName) + " " + String(object!.firstName)
                
                phoneNumber = String(object!.tel)
                telButton.setTitle(phoneNumber, for: .normal)
                self.userMemoTextView.text = String(object!.memo)

                if String(object!.memo) == "" {
                    self.memoTitle.alpha = 0
                }
            }
        } catch {
            // do something
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "showEditDataView") {
            let secondVC: EditDataViewController = (segue.destination as? EditDataViewController)!
            secondVC.userId = userId
        }
        
    }
    
    
    @IBAction func callPhone(_ sender: Any) {
        UIApplication.shared.open(URL(string: "tel://\(phoneNumber)")!)
    }
}
    
