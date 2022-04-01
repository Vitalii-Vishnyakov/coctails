//
//  ViewController.swift
//  CoctailTest
//
//  Created by Виталий on 01.04.2022.
//

import UIKit
import SnapKit
import Alamofire
class ViewController: UIViewController   {
    var collectionView : UICollectionView!
    var textField : UITextField!
    var labels = [UILabel]()
    
    override func loadView() {
        super.loadView()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout( ))
        let tf = UITextField(frame: .zero)
        collectionView = cv
        textField = tf
        textField.placeholder = "Coctail name"
        view.addSubview(collectionView)
        collectionView.addSubview(textField)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapper = UITapGestureRecognizer(target: self, action:#selector(endEditing))
        tapper.cancelsTouchesInView = false
        view.addGestureRecognizer(tapper)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getData { resp in
            for item in resp.drinks {
                let lb = UILabel()
                lb.text = item.strDrink
                lb.font = UIFont(name: "Helvetica", size: 14)
                self.labels.append(lb)
            }
            self.collectionView.reloadData()
        }
        configCollectionView( )
        configTextField ( )
    }
    
    func configCollectionView( ){
        collectionView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.bounds.width - 10, height: view.bounds.height))
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func configTextField ( ){
        textField.textAlignment = .center
        textField.contentVerticalAlignment = .center
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.layer.shadowOpacity = 0.8
        textField.layer.shadowRadius = 8.0
        textField.layer.shadowOffset = CGSize(width: 0, height: 1)
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.bounds.width - 40, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view).inset(60)
        }
    }
    
    func getData(completion : @escaping (Coctail) -> Void){
        guard let link = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?a=Non_Alcoholic") else {
            return
        }
        let req = URLRequest(url: link)
        AF.request(req).response{ response in
            guard response.error == nil,
            let data = response.data else {
                return
            }
            let coctails = try? JSONDecoder().decode(Coctail.self, from: data)
            guard let coctails = coctails else {
                return
            }
            DispatchQueue.main.async {
                completion ( coctails)
            }
        }
    }
    
    @objc func endEditing( ){
        textField.resignFirstResponder()
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        let keyboardSize = (notification.userInfo?  [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let keyboardHeight = keyboardSize?.height
        self.textField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view).inset(Int(keyboardHeight!))
            make.width.equalToSuperview().inset(-20)
        }
        textField.layer.shadowRadius = 0.0
        
    }
    
    @objc func keyboardWillHide(notification: Notification){
        textField.snp.removeConstraints()
        textField.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: view.bounds.width - 40, height: 50))
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view).inset(60)
        }
        textField.layer.shadowRadius = 8.0
        
    }
}
extension ViewController : UICollectionViewDelegate , UICollectionViewDataSource  , UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        labels.count
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! Cell
        cell.textlabel.text = labels[indexPath.row].text
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 8
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: labels[indexPath.row].intrinsicContentSize.width + 10, height:  labels[indexPath.row].intrinsicContentSize.height + 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        8
    }
    
}

extension ViewController  : UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if ((textField.text) != nil ){
            for (index , item) in self.labels.enumerated(){
                if item.text == textField.text{
                    collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: UICollectionView.ScrollPosition.centeredVertically)
                }
            }
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


















