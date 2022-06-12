//
//  ViewController.swift
//  Registration
//
//  Created by Матвей on 12.04.2022.
//

import UIKit
import Lottie

class AuthViewController: UIViewController {
        
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var loaderView: AnimationView!
        
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
        
    }
    
    var statusCode: Int!
    var error = ""

    
    
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func signButtonTapped(_ sender: Any) {
        
         if validation() {
             
             loaderView.play()
             loaderView.isHidden = false
             overlayView.isHidden = false
             
             let parameters = ["email": "\(emailTextField.text!)", "password": "\(passwordTextField.text!)"]
             
             checkLogin(parameters: parameters) { [unowned self] in
                 DispatchQueue.main.async {
                     guard let profileVC = (self.storyboard?.instantiateViewController(withIdentifier: "profileVC")) as? ProfileViewController else { return }
                     self.navigationController?.pushViewController(profileVC, animated: true)
                 }
             } failCompletion: { [unowned self] error in
                 loaderView.stop()
                 loaderView.isHidden = true
                 overlayView.isHidden = false
                 self.showToast(message: "Ошибка сервера: \(String(describing: error))", overlayView: self.overlayView)
             }
            
        } else {
            alert(title: "Заполните все поля правильно!", message: "Email должен содержать корректный адрес домена. Пароль - минимум 6 символов, латинские буквы и цифры, одна буква должна быть заглавной")
        }
    }
    
}

//MARK: - TextfieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - Private methods
private extension AuthViewController {
    
    func checkLogin(parameters: [String:Any], successCompletion:(()->())?, failCompletion:((Error?)->())?){
        NetworkManager.shared.checkLogin(parameters: parameters) { data, response, error in
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
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isValid(validType: emailValidType) == false {
            emailTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            emailTextField.backgroundColor = .white
        }
        
        if password.isValid(validType: passwordValidType) == false {
            passwordTextField.backgroundColor = UIColor(named: "PaleRed")
        } else {
            passwordTextField.backgroundColor = .white
        }
        
        if email.isValid(validType: emailValidType) && password.isValid(validType: passwordValidType) {
            return true
        } else {
            return false
        }
    }
}
