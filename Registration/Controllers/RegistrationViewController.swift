//
//  RegistrationViewController.swift
//  Registration
//
//  Created by Матвей on 12.04.2022.
//

import UIKit
import Lottie

class RegistrationViewController: UIViewController {
    
    //MARK: Outlets
    
    
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var loaderView: AnimationView!
    @IBOutlet weak var overlayView: UIView!
    
    @IBOutlet weak var eyeButton: UIButton!
    var passwordIsHidden = true
    
    //MARK: Valid types
    
    let nameValidType: String.ValidTypes = .name
    let emailValidType: String.ValidTypes = .email
    let passwordValidType: String.ValidTypes = .password

    //MARK: VC lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loaderView.contentMode = .scaleAspectFit
        loaderView.loopMode = .loop
        loaderView.animationSpeed = 0.5
        loaderView.isHidden = true
        overlayView.isHidden = true
        
        
        registerKeyboardNotification()
    }
    
    deinit {
        removeKeyboardNotification()
    }
    

    
    
    //MARK: IBActions
    
    @IBAction func eyeButtonTapped(_ sender: Any) {
        if passwordIsHidden {
            passwordIsHidden = false
            eyeButton.setImage(UIImage(systemName: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            confirmPasswordTextField.isSecureTextEntry = false
        } else {
            passwordIsHidden = true
            eyeButton.setImage(UIImage(systemName: "eye.slash"), for: .normal) 
            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = true
        }
    }
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func registrationButtonTapped(_ sender: Any) {
        
        if validation() {
            loaderView.play()
            loaderView.isHidden = false
            overlayView.isHidden = false
            let parameters = ["firstName": "\(nameTextField.text!.utf8)", "lastName": "\(surnameTextField.text!.utf8)", "patronymic": "\(patronymicTextField.text!.utf8)", "email": "\(emailTextField.text!)", "password": "\(passwordTextField.text!)"]

            registerUser(parameters: parameters) { [unowned self] in
                DispatchQueue.main.async {
                    guard let authVC = (self.storyboard?.instantiateViewController(withIdentifier: "authVC")) as? AuthViewController else { return }
                    self.navigationController?.pushViewController(authVC, animated: true)
                }
            } failCompletion: { [unowned self] error in
                loaderView.stop()
                loaderView.isHidden = true
                overlayView.isHidden = false
                self.showToast(message: "Ошибка сервера: \(String(describing: error))", overlayView: self.overlayView)

            }

        } else {
            alert(title: "Заполните все поля правильно!", message: "Фамилия, имя, отчество - только буквы, без символов. Email должен содержать корректный адрес домена. Пароль - минимум 6 символов, латинские буквы и цифры, одна буква должна быть заглавной. Пароли должны совпадать")
        }
    }
    
    @objc func hideOverlay() {
        self.overlayView.isHidden = true
    }
    
}

//MARK: - Text Field Delegate

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private
private extension RegistrationViewController {
    
    func registerUser(parameters: [String:Any], successCompletion:(()->())?, failCompletion:((Error?)->())?){
        NetworkManager.shared.registerUser(parameters: parameters) { data, response, error in
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
        let nameText = nameTextField.text ?? ""
        let surameText = surnameTextField.text ?? ""
        let patronymicText = patronymicTextField.text ?? ""
        let emailText = emailTextField.text ?? ""
        let passwordText = passwordTextField.text ?? ""
        let confPasText = confirmPasswordTextField.text ?? ""
        
        if nameText.isValid(validType: nameValidType) == false {
            nameTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            nameTextField.backgroundColor = .white
        }
        
        if surameText.isValid(validType: nameValidType) == false {
            surnameTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            surnameTextField.backgroundColor = .white
        }
        
        if patronymicText.isValid(validType: nameValidType) == false {
            patronymicTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            patronymicTextField.backgroundColor = .white
        }
        
        if emailText.isValid(validType: emailValidType) == false {
            emailTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            emailTextField.backgroundColor = .white
        }
        
        if passwordText.isValid(validType: passwordValidType) == false {
            passwordTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            passwordTextField.backgroundColor = .white
        }
        
        if confPasText.isValid(validType: passwordValidType) == false {
            confirmPasswordTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            confirmPasswordTextField.backgroundColor = .white
        }
        
        if nameText.isValid(validType: nameValidType)
            && surameText.isValid(validType: nameValidType)
            && patronymicText.isValid(validType: nameValidType)
            && emailText.isValid(validType: emailValidType)
            && passwordText == confPasText
            && passwordText.isValid(validType: passwordValidType) {
            return true
        } else {
            return false
        }
    }
    
}


