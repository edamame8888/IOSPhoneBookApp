//
//  PhoneBookViewController.swift
//  PhoneBookApp
//
//  Created by 今枝弘貴 on 2018/09/13.
//  Copyright © 2018年 K.Imaeda. All rights reserved.
//


import UIKit
import RealmSwift

class PhoneBookViewController: UITableViewController , UISearchBarDelegate{
    
    // MARK: - properties
    var objects: Results<PhoneBookData>? = nil
    
    // MARK: - IBOutlet
    @IBOutlet weak var phoneBookSearchBar: UISearchBar!
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegate
        phoneBookSearchBar.delegate = self
        
        // MARK: set objects: Results<PhoneBookData>?
        do {
            let realm = try Realm()
            /// 名前順にDBから取り出す為に、firstName -> familyName の順でソート
            let sortProperties = [
                SortDescriptor(keyPath: "kanaFamilyName", ascending: true),
                SortDescriptor(keyPath: "kanaFirstName", ascending: true),
                ]
            self.objects = realm.objects(PhoneBookData.self).sorted(by: sortProperties)
            
        } catch {
            print("Error: can not set objects ." )
        }
        
        if #available(iOS 11.0, *) {
            // UISearchControllerをUINavigationItemのsearchControllerプロパティにセットする。
            //navigationItem.searchController = searchController
            
            // trueだとスクロールした時にSearchBarを隠す（デフォルトはtrue）
            // falseだとスクロール位置に関係なく常にSearchBarが表示される
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            //ableView.tableHeaderView = searchController.searchBar
        }
        
    }
    
    // MARK: reload TableCellData
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: set objects: Results<PhoneBookData>?
    private func setObjectsArray(){
        do {
            let realm = try Realm()
            //名前順にDBから取り出す為に、firstName -> familyName の順でソート
            let sortProperties = [
                SortDescriptor(keyPath: "kanaFamilyName", ascending: true),
                SortDescriptor(keyPath: "kanaFirstName", ascending: false),
                ]
            
            self.objects = realm.objects(PhoneBookData.self).sorted(by: sortProperties)
            
        } catch {
            print("Error: can not set objects ." )
        }
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    /// tableViewに表示するcellの数を返すメソッド
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - section: Int
    /// - Returns: objectsの要素数 (nil の場合は0を返す)
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = self.objects?.count else {
            return 0
        }
        return count
    }
    
    
    /// tableViewのcellに入れるコンテンツを設定
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - indexPath: cellForRowAt indexPath
    /// - Returns: UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        guard let object = self.objects?[indexPath.row] else {
            return cell
        }
        
        cell.textLabel?.text = String(object.familyName)  + " " +  String(object.firstName)
        //cell.textLabel
        return cell
    }
    
    /// スワイプでDBの要素とobjectの要素を消す
    ///
    /// - Parameters:
    ///   - tableView: UITableView
    ///   - editingStyle: comit editingStyle
    ///   - indexPath: forRowAt indexPath
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            //モデルオブジェクトの削除
            let removeObject = objects![indexPath.row]
            do {
                let realm = try Realm()
                try! realm.write {
                    realm.delete(removeObject)
                }
            } catch {
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    /// Segueで遷移時の処理
    ///
    /// - Parameters:
    ///   - segue: UIStoryboardSegue
    ///   - sender: Any!
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "showDetail") {
            let secondVC: DetailViewController = (segue.destination as? DetailViewController)!
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let chosenId = self.objects![indexPath.row].id
                // 選択しているidを渡す
                secondVC.userId = chosenId
            }
        }
        
    }
    
    ///  searchBarの更新があった際に呼ばれるメソッド
    ///
    /// - Parameters:
    ///   - searchBar: UISearchBar
    ///   - searchText: String
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let realm = try! Realm()
        //名前順にDBから取り出す為に、firstName -> familyName の順でソート
        let sortProperties = [
            SortDescriptor(keyPath: "kanaFamilyName", ascending: true),
            SortDescriptor(keyPath: "kanaFirstName", ascending: true),
            ]
        
        
        
        if (phoneBookSearchBar.text?.isEmpty)! {
            // back spaceでsearchBarが空文字になった際に全てのPhoneBookDataを表示
            
            self.objects = realm.objects(PhoneBookData.self).sorted(by: sortProperties)
            
        } else {
            // searchBarの文字列に部分一致するPhoneBookDataの要素をobjectsに代入
            
            let filterCondition =   "(firstName CONTAINS %@)"       + " OR " +
                "(kanaFirstName CONTAINS %@)"   + " OR " +
                "(familyName CONTAINS %@)"      + " OR " +
                "(kanaFamilyName CONTAINS %@)"  + " OR " +
                "(tel CONTAINS %@)"             + " OR " +
            "(memo CONTAINS %@)"
            
            self.objects = realm.objects(PhoneBookData.self)
                .sorted(by: sortProperties)
                .filter( filterCondition            ,
                         phoneBookSearchBar.text!   ,
                         phoneBookSearchBar.text!   ,
                         phoneBookSearchBar.text!   ,
                         phoneBookSearchBar.text!   ,
                         phoneBookSearchBar.text!   ,
                         phoneBookSearchBar.text!   )
        }
        
        // TableViewを更新
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
