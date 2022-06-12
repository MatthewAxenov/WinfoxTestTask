//
//  NetworkManager.swift
//  Registration
//
//  Created by Федор Рубченков on 12.06.2022.
//

import Foundation

final class NetworkManager: NSObject {
    
    private enum Endpoints: String {
        case register = "registerUser"
        case checkLogin = "checkLogin"
        case uploadAvatar = "uploadAvatar"
        case updateProfile = "updateProfile"
    }
    
    private override init() {}
    static let shared = NetworkManager()
    
    private let baseUrlString: String = "http://94.127.67.113:8099/"
    
    private func makeRequest(endpoint: String, parameters: [String:Any], method:String="POST") -> URLRequest? {
        let urlString = baseUrlString + endpoint
        guard let url = URL(string: urlString) else { print("Ошибка апи"); return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { print("Корявые параметры"); return nil }
        request.httpBody = httpBody
        return request
    }
    
    func registerUser(parameters: [String:Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = makeRequest(endpoint: Endpoints.register.rawValue, parameters: parameters) else { print("wrong request"); return }
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func checkLogin(parameters: [String:Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = makeRequest(endpoint: Endpoints.checkLogin.rawValue, parameters: parameters) else { print("wrong request"); return }
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func uploadAvatar(parameters: [String:Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = makeRequest(endpoint: Endpoints.uploadAvatar.rawValue, parameters: parameters) else { print("wrong request"); return }
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func updateProfile(parameters: [String:Any], completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let request = makeRequest(endpoint: Endpoints.updateProfile.rawValue, parameters: parameters) else { print("wrong request"); return }
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
}
