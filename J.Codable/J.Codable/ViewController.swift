//
//  ViewController.swift
//  J.Codable
//
//  Created by JinYoung Lee on 23/10/2018.
//  Copyright © 2018 JinYoung Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    struct AnimalList : Codable {
        var dogName:String
        var catName:String
        var birdName:String
    }
    
    @IBOutlet weak var dogTextField: UITextField!
    @IBOutlet weak var catTextField: UITextField!
    @IBOutlet weak var birdTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var dogName:String = ""
    private var catName:String = ""
    private var birdName:String = ""
    
    private var selectedIndex:IndexPath?
    private var selectedData:Data?
    private var savedDataList:[Data] = [Data]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDelegate()
    }
    
    private func addDelegate() {
        dogTextField.delegate = self
        catTextField.delegate = self
        birdTextField.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == dogTextField {
            dogName = textField.text ?? ""
        } else if textField == catTextField {
            catName = textField.text ?? ""
        } else {
            birdName = textField.text ?? ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @IBAction func onClickSaveButton(_ sender: Any) {
        guard (!(dogName.isEmpty) && !(catName.isEmpty) && !(birdName.isEmpty)) else {
            print("some field is empty")
            return
        }
        
        createJsonData()
    }
    
    private func createJsonData() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        
        let list = AnimalList(dogName: dogName, catName: catName, birdName: birdName)
        let jsonData = try? encoder.encode(list)
        if let dat = jsonData, let jsonString = String(data: jsonData!, encoding: String.Encoding.utf8) {
            savedDataList.append(dat)
            collectionView.reloadData()
            print("saved data to jsonString: \(jsonString)")
        }
    }
    
    @IBAction func onClickLoadButton(_ sender: Any) {
        guard selectedData != nil else {
            print("saved data is nil")
            return
        }
        
        let decoder = JSONDecoder()
        let jsonData = try? decoder.decode(AnimalList.self, from: selectedData!)
        if let list = jsonData {
            dogTextField.text = list.dogName
            catTextField.text = list.catName
            birdTextField.text = list.birdName
        }
    }
    
    @IBAction func onClickDelete(_ sender: Any) {
        guard let selIdx = selectedIndex else {
            return
        }
        
        selectedIndex = nil
        savedDataList.remove(at: selIdx.row)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard savedDataList.count > 0 else {
            return
        }
        
        let cell:CustomCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.didSelect(select: true)
        selectedIndex = indexPath
        selectedData = savedDataList[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard savedDataList.count > 0 else {
            return
        }
        
        let cell:CustomCollectionViewCell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        cell.didSelect(select: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedDataList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "id_reusecell", for: indexPath) as! CustomCollectionViewCell
        cell.didSelect(select: false)
        if savedDataList.count > 0 {
            if indexPath == selectedIndex {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
                cell.didSelect(select: true)
            }
            let data:Data = savedDataList[indexPath.row]
            let jsonData = try? JSONDecoder().decode(AnimalList.self, from: data)
            cell.bindData(dog: jsonData?.dogName, cat: jsonData?.catName, bird: jsonData?.birdName)
        }
        
        
        
        return cell
    }
}

