//
//  ViewController.swift
//  currency converter - dollar - swift
//
//  Created by matheus maignardi on 15/09/2021.
//  Copyright © 2021 matheus maignardi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var currencyCode:[String] = []
    var values: [Double] = []
    var activeCurrency = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        fetchjSON()
        textField.addTarget(self, action: #selector(updateView), for: .editingChanged)
    }
    
    @objc func updateView(input:Double){
        guard let amountText = textField.text, let theAmountText = Double(amountText) else { return }
        if textField.text != ""{
            let total = theAmountText * activeCurrency
            priceLabel.text = String(format: "%.2f", total)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyCode.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyCode[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency = values[row]
        updateView(input: activeCurrency)
    }
    
    func fetchjSON(){
        guard let url = URL(string:"https://open.er-api.com/v6/latest/USD") else { return }
        URLSession.shared.dataTask(with: url) {(data, response, error)in
            if error != nil{
                print(error!)
                return
            }
            guard let safeData = data else{ return }
            do{
                let results = try JSONDecoder().decode(ExchangeRates.self, from: safeData)
                self.currencyCode.append(contentsOf: results.rates.keys)
                self.values.append(contentsOf: results.rates.values)
                DispatchQueue.main.async {
                    self.pickerView.reloadAllComponents()
                }
            }catch{
                print(error)
            }
        }.resume()
    }
}

