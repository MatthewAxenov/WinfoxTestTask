//
//  ProfileViewController.swift
//  Registration
//
//  Created by Матвей on 11.06.2022.
//

import UIKit
import Lottie

class ProfileViewController: UIViewController {
    
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    
    var image = UIImage()
    
    let intetests = ["Авто", "Бизнес", "Инвестиции", "Спорт", "Саморазвитие", "Здоровье", "Еда", "Семья, дети", "Домашние питомцы", "Фильмы", "Компьютерные игры", "Музыка"]
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var loaderView: AnimationView!
    
    
    @IBOutlet weak var photoButton: UIButton!
    
    
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var patronymicTF: UITextField!
    @IBOutlet weak var placeOfBirthTF: UITextField!
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var companyTF: UITextField!
    @IBOutlet weak var positionTF: UITextField!
    @IBOutlet weak var interestsTF: UITextField!
    
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        loaderView.contentMode = .scaleAspectFit
        loaderView.loopMode = .loop
        loaderView.animationSpeed = 0.5
        loaderView.isHidden = true
        overlayView.isHidden = true
        
        navigationItem.title = "Профиль"
        registerKeyboardNotification()
        setDatePicker()
        setPicker()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func photoButtonTapped(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if validation() {
            loaderView.play()
            loaderView.isHidden = false
            overlayView.isHidden = false
            let parameters = ["firstName": "\(nameTF.text!)", "lastName": "\(lastNameTF.text!)", "patronymic": "\(patronymicTF.text)", "placeOfBirth": "\(placeOfBirthTF.text)", "dateOfBirth": "\(dateTF.text)", "interests": "\(interestsTF.text)", "company": "\(companyTF.text)", "position": "\(positionTF.text)"]

            updateProfile(parameters: parameters) { [unowned self] in
                DispatchQueue.main.async {
                    alert(title: "Отлично!", message: "Профиль был обновлен")
                    self.loaderView.stop()
                    self.loaderView.isHidden = true
                    self.overlayView.isHidden = true
                }
            } failCompletion: { [unowned self] error in
                loaderView.stop()
                loaderView.isHidden = true
                overlayView.isHidden = false
                self.showToast(message: "Ошибка сервера: \(String(describing: error))", overlayView: self.overlayView)

            }
        } else {
            alert(title: "Заполните все обязательные поля правильно!", message: "Поля имени и фамилии не должны содержать символов, только буквы")
        }
    }
    
    
    func setDatePicker() {
        dateTF.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = .now
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneDateAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexSpace, doneButton], animated: true)
        dateTF.inputAccessoryView = toolBar
    }
    
    
    @objc func doneDateAction() {
        getDate()
        view.endEditing(true)
    }
    
    @objc func doneAction() {
        view.endEditing(true)
    }
    
    func getDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        dateTF.text = formatter.string(from: datePicker.date)
    }
    
    func setPicker() {
        pickerView.delegate = self
        pickerView.dataSource = self
        interestsTF.inputView = pickerView
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([flexSpace, doneButton], animated: true)
        interestsTF.inputAccessoryView = toolBar
    }
    
    
    func imageRequest() {
        
    }
    
    

   

}


 extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

 extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            self.image = image
            let imageData: Data = image.jpegData(compressionQuality: 0.1) ?? Data()
            let parameters = ["image": imageData]
            self.photoButton.setTitle("Фото загружено", for: .normal)
                
            
        }
        
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return intetests.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return intetests[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if interestsTF.text == "" {
            interestsTF.text = intetests[row]
        } else if let text = interestsTF.text {
            interestsTF.text = text + ", " + intetests[row]
        }
        interestsTF.resignFirstResponder()
    }
}

//MARK: - Private

private extension ProfileViewController {
    
    func updateProfile(parameters: [String:Any], successCompletion:(()->())?, failCompletion:((Error?)->())?){
        NetworkManager.shared.updateProfile(parameters: parameters) { data, response, error in
            if let response = response as? HTTPURLResponse {
                DispatchQueue.main.async {
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        successCompletion?()
                    } else {
                        if let error = error {
                            failCompletion?(error)
                        } else {
                            failCompletion?(nil)
                        }
                    }
                }
                
            }
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print(error)
            }
        }
    }
    
    func validation() -> Bool {
        let nameText = nameTF.text ?? ""
        let lastNameText = lastNameTF.text ?? ""
        
        if nameText.isValid(validType: nameValidType) == false {
            nameTF.backgroundColor = UIColor(named: "PaleRed")
        } else {
            nameTF.backgroundColor = .white
        }
        
        if lastNameText.isValid(validType: nameValidType) == false {
            lastNameTF.backgroundColor = UIColor(named: "PaleRed")
        } else {
            lastNameTF.backgroundColor = .white
        }
        
        if placeOfBirthTF.text == "" {
            placeOfBirthTF.backgroundColor = UIColor(named: "PaleRed")
        } else {
            placeOfBirthTF.backgroundColor = .white
        }
        
        if interestsTF.text == "" {
            interestsTF.backgroundColor = UIColor(named: "PaleRed")
        } else {
            interestsTF.backgroundColor = .white
        }
        
        
        if nameText.isValid(validType: nameValidType)
            && lastNameText.isValid(validType: nameValidType)
            && interestsTF.text != ""
            && placeOfBirthTF.text != "" {
            return true
        } else {
            return false
        }
    }
    
    
}
