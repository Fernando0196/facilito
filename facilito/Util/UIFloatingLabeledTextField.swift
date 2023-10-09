//
//  FloatingLabeledTextField.swift
//  facilito
//
//  Created by iMac Mario on 6/01/23.
//

import Foundation
import UIKit
import CoreLocation
import GoogleMaps

class UIFloatingLabeledTextField: UITextField {

  var floatingLabel: UILabel!
  var placeHolderText: String?

    var floatingLabelColor = UIColor(red: 0/255, green: 26/255, blue: 97/255, alpha: 1)
    {
      
    didSet {
        self.floatingLabel.textColor = floatingLabelColor
    }
  }
  /* var floatingLabelFont: UIFont = UIFont(name: "Poppins-Regular", size: 14) {
      didSet {
        self.floatingLabel.font = floatingLabelFont
      }
  }*/
   var floatingLabelHeight: CGFloat = 25

   override init(frame: CGRect) {
     super.init(frame: frame)
   }
    override func layoutSubviews() {
        super.layoutSubviews()

        elevatePlaceholder()
    }
   required init?(coder aDecoder: NSCoder) {

    super.init(coder: aDecoder)

    let flotingLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 0)

    floatingLabel = UILabel(frame: flotingLabelFrame)
    floatingLabel.textColor = floatingLabelColor
    floatingLabel.font = UIFont(name: "Poppins-Regular", size: 14)
    floatingLabel.text = self.placeholder
    //floatingLabel.backgroundColor = UIColor.green
       
    self.addSubview(floatingLabel)
    placeHolderText = placeholder

    NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)

     NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)

       
 

}
    

@objc func textFieldDidBeginEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
        }
        self.placeholder = ""
    }
}

@objc func textFieldDidEndEditing(_ textField: UITextField) {

    if self.text == "" {
        UIView.animate(withDuration: 0.1) {
           self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
        self.placeholder = placeHolderText
    }
}
    private func elevatePlaceholder() {
        if self.text != "" {
            UIView.animate(withDuration: 0.3) {
                self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
            }
            self.placeholder = ""
        }
    }
    
    
deinit {

    NotificationCenter.default.removeObserver(self)

  }
}

//UIValidarTextosTextField
extension UIFloatingLabeledTextField {
        func setupDatePicker() {
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
            datePicker.frame.size = CGSize(width: 0, height: 300)
            datePicker.preferredDatePickerStyle = .wheels
            self.inputView = datePicker
            
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(doneButtonTapped))
            toolbar.setItems([doneButton], animated: false)
            self.inputAccessoryView = toolbar
            
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.text = dateFormatter.string(from: currentDate)
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            self.text = dateFormatter.string(from: sender.date)
        }
        
        @objc func doneButtonTapped() {
            self.resignFirstResponder()
        }
    

    
    
    
}

//validaciones de cajas
extension UIFloatingLabeledTextField: UITextFieldDelegate {
    func setupIntegerInput() {
        self.delegate = self
        self.keyboardType = .numberPad
    }

    func setupDecimalInput() {
        self.delegate = self
        self.keyboardType = .decimalPad
    }

    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.keyboardType == .decimalPad {
            // Verifica si el texto actual ya contiene un punto
            if let text = textField.text, text.contains(".") && string == "." {
                return false // No permite agregar otro punto
            }

            let allowedCharacters = CharacterSet(charactersIn: "0123456789.")
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        } else if self.keyboardType == .numberPad {
            let allowedCharacters = CharacterSet(charactersIn: "0123456789")
            let characterSet = CharacterSet(charactersIn: string)
            
            return allowedCharacters.isSuperset(of: characterSet)
        }
        
        return true
    }
}


extension CLLocation {
    typealias AddressCompletion = (String?) -> Void
    
    func getAddressFromGoogleMaps(completion: @escaping AddressCompletion) {
        let geocoder = GMSGeocoder()
        geocoder.reverseGeocodeCoordinate(self.coordinate) { (response, error) in
            if let error = error {
                print("Error en la geocodificación inversa: \(error.localizedDescription)")
                completion(nil)
            } else if let result = response?.firstResult() {
                let address = result.lines?.joined(separator: ", ")
                completion(address)
            } else {
                completion(nil)
            }
        }
    }
}
