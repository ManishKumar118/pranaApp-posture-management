//
//  SignupViewController.swift
//  Prana
//
//  Created by Luccas on 2019/2/28.
//  Copyright © 2019 Prana. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import Crashlytics
//import MBProgressHUD
import MKProgress

class SignupViewController: SuperViewController, UITextFieldDelegate {
    
    @IBOutlet weak var tf_firstname: UITextField!
    @IBOutlet weak var lbl_error_firstname: UILabel!
    @IBOutlet weak var tf_lastname: UITextField!
    @IBOutlet weak var lbl_error_lastname: UILabel!
    @IBOutlet weak var tf_email: UITextField!
    @IBOutlet weak var lbl_error_email: UILabel!
    @IBOutlet weak var tf_password: UITextField!
    @IBOutlet weak var lbl_error_password: UILabel!
    @IBOutlet weak var tf_confirmpassword: UITextField!
    @IBOutlet weak var lbl_error_confirmpassword: UILabel!
    @IBOutlet weak var tf_birthdate: UITextField!
    @IBOutlet weak var lbl_error_birthdate: UILabel!
    @IBOutlet weak var btn_submit: UIButton!
    @IBOutlet weak var btn_gender_male: UIButton!
    @IBOutlet weak var btn_gender_female: UIButton!
    
    var strGender: String!
    
    var datePicker: UIDatePicker!
    
    var isUpdateProfile = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        
        tf_birthdate.delegate = self
        
        initView()
        
        genderChange(nGender: 0)
        
        tf_firstname.spellCheckingType = .no
        tf_lastname.spellCheckingType = .no
        tf_email.keyboardType = .emailAddress
        tf_email.spellCheckingType = .no
//        changeBirthDay(Date())
        
        if isUpdateProfile {
            print(dataController.currentUser as Any)
                       
                       tf_firstname.text = UserDefaults.standard.value(forKey: "firstName") as? String
                       print(tf_firstname.text as Any)
                       tf_lastname.text = UserDefaults.standard.value(forKey: "lastName") as? String
                       print(tf_lastname.text as Any)

                       tf_email.text =  UserDefaults.standard.value(forKey: "chkemail") as? String
                       tf_birthdate.text = UserDefaults.standard.value(forKey: "birthDay") as? String
                       UserDefaults.standard.value(forKey: "gender")
//            if let user = dataController.currentUser {
//                tf_firstname.text = user.firstName
//                tf_lastname.text = user.lastName
//                tf_email.text = user.email
//                tf_password.text = user.password
//                tf_confirmpassword.text = user.password
//                changeBirthDay(user.birthDay)
//                if user.gender == "male" {
//                    genderChange(nGender: 0)
//                } else {
//                    genderChange(nGender: 1)
//                }
//            }
        }
    }
    
    @IBAction func onBackClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func initView() {
        let background = UIImage(named: "app-background")
        let imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.insertSubview(imageView, at: 0)
        view.sendSubviewToBack(imageView)
        
        tf_firstname.borderStyle = .none
        tf_lastname.borderStyle = .none
        tf_email.borderStyle = .none
        tf_password.borderStyle = .none
        tf_confirmpassword.borderStyle = .none
        tf_birthdate.borderStyle = .none
        
        lbl_error_firstname.isHidden = true
        lbl_error_lastname.isHidden = true
        lbl_error_email.isHidden = true
        lbl_error_password.isHidden = true
        lbl_error_confirmpassword.isHidden = true
        lbl_error_birthdate.isHidden = true
    }

    @IBAction func onSubmitClick(_ sender: Any) {
        
        var alertController:UIAlertController!
        
        if tf_firstname.text! == "" {
            alertController = UIAlertController(title: "Input Error", message: "Please input your first name", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            return
        }
        
        if tf_lastname.text! == "" {
            alertController = UIAlertController(title: "Input Error", message: "Please input last first name", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            return
        }
        
        if !Utils.isValidEmail(str:tf_email.text!) {
            alertController = UIAlertController(title: "Input Error", message: "Invalid Email", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            return
        }
        
        if !Utils.isValidPassword(str:tf_password.text!) {
            alertController = UIAlertController(title: "Input Error", message: "Password must be 4 - 20 chars", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            return
        }
        
        if !Utils.isValidPassword(str:tf_confirmpassword.text!) {
            alertController = UIAlertController(title: "Input Error", message: "Password must be 4 - 20 chars", preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
            self.present(alertController, animated: false, completion: nil)
            return
        }
        
        if isUpdateProfile {
            
        } else {
            signup()
        }
    }
    
    func signup() {
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate
//        hud.label.text = "Loading..."
        MKProgress.show()
        
        let param: Parameters = [
            "first_name": tf_firstname.text!,
            "last_name": tf_lastname.text!,
            "email": tf_email.text!,
            "password": tf_password.text!,
            "birth_date": tf_birthdate.text!,
            "gender": strGender
        ]
        APIClient.sessionManager.request(APIClient.BaseURL + "register", method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {(response) in
                MKProgress.hide()
                switch response.result {
                case .success:
                    let alertController = UIAlertController(title: "Success", message:
                        "Sign up success", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
                        self.login()
                    }))
                    self.present(alertController, animated: false, completion: nil)
                    break
                case .failure:
                    if response.response == nil {
                        let alertController = UIAlertController(title: "Error", message:
                            "Network error", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else if response.response!.statusCode == 500 {
                        let alertController = UIAlertController(title: "Error", message:
                            "Server Error!", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else if response.response!.statusCode == 422 {
                        let alertController = UIAlertController(title: "Error", message:
                            "Invalid Data", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else {
                        let alertController = UIAlertController(title: "Error", message:
                            "error", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    }
                }
//                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
    }
    
    func login() {
//        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
//        hud.mode = .indeterminate
//        hud.label.text = "Loading..."
        MKProgress.show()
        
        let param: Parameters = [
            "email": tf_email.text!,
            "password": tf_password.text!
        ]
        
        APIClient.sessionManager.request(APIClient.BaseURL + "login", method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil)
            .validate(statusCode: 200..<300)
            .responseJSON {(response) in
                MKProgress.hide()
                switch response.result {
                case .success:
                    if let data = response.value as? [String: Any] {
                        let token = data["access_token"] as! String
                        let expires_at = data["expires_at"] as! String
                        UserDefaults.standard.set(token, forKey: KEY_TOKEN)
                        UserDefaults.standard.set(expires_at, forKey: KEY_EXPIREAT)
                        UserDefaults.standard.set(false, forKey: KEY_REMEMBERME)
                        UserDefaults.standard.set(data["first_name"], forKey: "firstName")
                        print(UserDefaults.standard.value(forKey: "firstName") as Any)
                    UserDefaults.standard.set( data["last_name"], forKey: "lastName")
                    print(UserDefaults.standard.value(forKey: "lastName") as Any)
                        UserDefaults.standard.set(data["email"], forKey: "chkemail")
                        print(UserDefaults.standard.value(forKey: "chkemail") as Any)
                            UserDefaults.standard.set(data["DOB"], forKey: "birthDay")
                        UserDefaults.standard.set(data["gender"], forKey: "gender")
                        UserDefaults.standard.synchronize()
                        self.dataController.currentUser = User(data: data)
                        self.dataController.saveUserData()
                        self.dataController.clearData()
                        self.navigationController?.popToRootViewController(animated: false)
                        NotificationCenter.default.post(name: .didLogIn, object: nil)
                    }
                    break
                case .failure:
                    if response.response == nil {
                        let alertController = UIAlertController(title: "Error", message:
                            "Network error", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else if response.response!.statusCode == 500 {
                        let alertController = UIAlertController(title: "Error", message:
                            "Server Error!", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else if response.response!.statusCode == 422 {
                        let alertController = UIAlertController(title: "Error", message:
                            "Invalid Data", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    } else {
                        let alertController = UIAlertController(title: "Error", message:
                            "error", preferredStyle: UIAlertController.Style.alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default,handler: nil))
                        self.present(alertController, animated: false, completion: nil)
                        break
                    }
                }
//                MBProgressHUD.hide(for: self.view, animated: true)
                
        }
    }
    
    @IBAction func onTouchScreen(_ sender: Any) {
        
    }
    
    @IBAction func onGenderChange(_ sender: UIButton) {
        genderChange(nGender: sender.tag)
    }
    
    func genderChange(nGender: Int) {
        if nGender == 0 {
            strGender = "male"
            
            btn_gender_male.setBackgroundImage(UIImage(named: "radio-green-selected"), for: .normal)
            btn_gender_female.setBackgroundImage(UIImage(named: "radio-green-normal"), for: .normal)
        } else {
            strGender = "female"
            
            btn_gender_male.setBackgroundImage(UIImage(named: "radio-green-normal"), for: .normal)
            btn_gender_female.setBackgroundImage(UIImage(named: "radio-green-selected"), for: .normal)
        }
    }
    
    @IBAction func onBlinkPasswordClick(_ sender: UIButton) {
        if tf_password.isSecureTextEntry {
            tf_password.isSecureTextEntry = false
        } else {
            tf_password.isSecureTextEntry = true
        }
    }
    
    @IBAction func onBlinkConfirmPasswordClick(_ sender: UIButton) {
        if tf_confirmpassword.isSecureTextEntry {
            tf_confirmpassword.isSecureTextEntry = false
        } else {
            tf_confirmpassword.isSecureTextEntry = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == tf_birthdate){
            let datePickerView:UIDatePicker = UIDatePicker()
            datePickerView.datePickerMode = UIDatePicker.Mode.date
            textField.inputView = datePickerView
            datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControl.Event.valueChanged)
        }
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        changeBirthDay(sender.date)
    }
    
    func changeBirthDay(_ date: Date) {
        guard let year = Calendar.current.dateComponents([.year], from: Date(), to: date).year, year < 0 else {
            return
        }
        let formatter = DateFormatter()
        
        formatter.locale = Locale.init(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM/YYYY"
        formatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        
        tf_birthdate.text = formatter.string(from: date)
        
    }
}
