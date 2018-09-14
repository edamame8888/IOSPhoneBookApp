//
//  EditDataViewController.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//



import UIKit
import RealmSwift

class EditDataViewController: UIViewController ,UITextFieldDelegate{
    
    // MARK: - properties
    var userId: String = ""
    
    // MARK: - IBOutlet
    @IBOutlet weak var familyNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var kanaFamilyNameField: UITextField!
    @IBOutlet weak var kanaFirstNameField: UITextField!
    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var memoTextView: UITextView!
    @IBOutlet weak var finishButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // delegate を　EditDataViewController に任せる
        familyNameField.delegate        = self
        kanaFamilyNameField.delegate    = self
        firstNameField.delegate         = self
        kanaFirstNameField.delegate     = self
        telField.delegate               = self
        
        //set TextField underline
        familyNameField.underlined()
        kanaFamilyNameField.underlined()
        firstNameField.underlined()
        kanaFirstNameField.underlined()
        telField.underlined()
        
        // PhoneBookData から　id でオブジェクトを取得し、TextField に反映させる
        do {
            let realm = try Realm()
            let object = realm.objects(PhoneBookData.self).filter("id == %@", userId).last
            
            if object != nil {
                familyNameField.text        = String(object!.familyName)
                kanaFamilyNameField.text    = String(object!.kanaFamilyName)
                firstNameField.text         = String(object!.firstName)
                kanaFirstNameField.text     = String(object!.kanaFirstName)
                telField.text               = String(object!.tel)
                memoTextView.text           = String(object!.memo)
            }
        } catch {
            print("Error : can not get data")
        }
        // 完了　Button を　無効化
        finishButton.isEnabled = true
        
        //textViewの枠線の太さを設定
        memoTextView.layer.borderWidth = 1
        
        //枠線の色をグレーに設定
        memoTextView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    //MARK: キーボードが出ている状態で、キーボード以外をタップしたらキーボードを閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //MARK: return keyを押すと次の入力に進む
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 今フォーカスが当たっているテキストボックスからフォーカスを外す
        textField.resignFirstResponder()
        // 次のTag番号を持っているテキストボックスがあれば、フォーカスする
        let nextTag = textField.tag + 1
        if let nextTextField = self.view.viewWithTag(nextTag) {
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: memo以外のtextFieldが0以上か判定
    private func checkTextField() -> Bool {
        return  (familyNameField.text?.count)!  *
            (kanaFamilyNameField.text?.count)!  *
            (firstNameField.text?.count)!       *
            (kanaFirstNameField.text?.count)!   *
            (telField.text?.count)!             > 0
    }
    
    //MARK: 文字が入力されていないとボタンを受け付けない判定
    func dataCheck() -> Bool{
        finishButton.isEnabled = false
        if  checkTextField() {
            if Int(telField.text!) != nil && Int(telField.text!)! >= 0{
                finishButton.isEnabled = true
                return true
            }
            else{
                let alert: UIAlertController = UIAlertController(title: "\(telField.text!)", message: "電話番号は数字で入力して下さい。", preferredStyle:  UIAlertControllerStyle.alert)
                
                // Actionの設定
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler:{
                    // ボタンが押された時の処理
                    (action: UIAlertAction!) -> Void in
                    self.telField.text = ""
                    
                })
                
                //UIAlertControllerにActionを追加
                alert.addAction(defaultAction)
                
                //Alertを表示
                present(alert, animated: true, completion: nil)
                
                
            }
        }
        return false
    }
    
    
    // textField Delegate method
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        _ = dataCheck()
        return true
    }
    
    
    //MARK: PhoneBook Data update and back to homeView
    @IBAction func finishEditPhoneData(_ sender: Any) {
        
        ///datacheck
        if !dataCheck(){
            return
        }
        
        do {
            let realm = try Realm()
            let upDateObject = realm.objects(PhoneBookData.self).filter("id == %@", userId).last
            try realm.write {
                upDateObject?.kanaFirstName     = kanaFirstNameField.text!
                upDateObject?.kanaFamilyName    = kanaFamilyNameField.text!
                upDateObject?.firstName         = firstNameField.text!
                upDateObject?.familyName        = familyNameField.text!
                upDateObject?.tel               = telField.text!
                upDateObject?.memo              = memoTextView.text!
            }
        } catch {
            // Error
        }
        
        let alert: UIAlertController = UIAlertController(title: "編集が完了しました。", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
        // Actionの設定
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler:{
            // ボタンが押された時の処理
            (action: UIAlertAction!) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        })
        
        //UIAlertControllerにActionを追加
        alert.addAction(defaultAction)
        
        //Alertを表示
        present(alert, animated: true, completion: nil)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
