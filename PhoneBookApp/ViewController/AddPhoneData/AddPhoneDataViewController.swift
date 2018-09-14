//
//  AddPhoneDataViewController.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//

import UIKit
import RealmSwift

class AddPhoneDataViewController: UIViewController ,UITextFieldDelegate{
    
    
    // MARK: - IBOutlet
    @IBOutlet weak var familyNameField: UITextField!
    @IBOutlet weak var kanaFamilyNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var kanaFirstNameField: UITextField!
    @IBOutlet weak var telField: UITextField!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var memoTextView: UITextView!
    
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        familyNameField.delegate        = self
        kanaFamilyNameField.delegate    = self
        firstNameField.delegate         = self
        kanaFirstNameField.delegate     = self
        telField.delegate               = self
        
        addButton.isEnabled             = false
        
        //set TextField underline
        //setTextFieldUnderLine(textField: familyNameField)
        familyNameField.underlined()
        kanaFamilyNameField.underlined()
        firstNameField.underlined()
        kanaFirstNameField.underlined()
        telField.underlined()
        
        
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
    
    
    /// 編集完了後に入力漏れがないかチェック
    ///
    /// - Parameter textField: UITextField
    /// - Returns: Bool(true)
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if checkTextField() {
            
            if Int(telField.text!) != nil && Int(telField.text!)! >= 0{
                addButton.isEnabled = true
                
            } else {
                let alert: UIAlertController = UIAlertController( title: "\(telField.text!)", message: "電話番号は数字で入力して下さい。", preferredStyle: UIAlertControllerStyle.alert)
                
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
        return true
    }
    
    
    /// 新規作成内容をDBに反映 -> アラートで編集を通知 -> 電話帳に戻る
    ///
    /// - Parameter sender: Any
    @IBAction func AddPhoneBookData(_ sender: Any) {
        //追加するデータ
        let phoneBookData = PhoneBookData()
        phoneBookData.kanaFirstName     = kanaFirstNameField.text!
        phoneBookData.kanaFamilyName    = kanaFamilyNameField.text!
        phoneBookData.firstName         = firstNameField.text!
        phoneBookData.familyName        = familyNameField.text!
        phoneBookData.tel               = telField.text!
        phoneBookData.memo              = memoTextView.text
        
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(phoneBookData)
            }
        } catch {
            //Error
            print("Error : realm error")
        }
        
        let alert: UIAlertController = UIAlertController(title: "登録が完了しました", message: "", preferredStyle:  UIAlertControllerStyle.alert)
        
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
