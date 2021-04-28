//
//  AppDevWithSwiftCloud.swift
//  ChatApp
//
//  Created by Kevin McQuown on 4/28/21.
//

import Foundation

public class AppDevWithSwiftCloud {
    let appID: String
    let kUserIDKey = "com.wcl.AppDevWithSwiftCloud.kUserIDKey"
    let kEndPoint = "trek.thewcl.com:14000"
//    let kEndPoint = "localhost:14000"
    var showJSONResults = true
    
    public init(appID: String, userID: String) {
        self.appID = appID
        UserDefaults.standard.setValue(userID, forKey: kUserIDKey)
        UserDefaults.standard.synchronize()
    }
    
    public func getUserID() -> String {
        if let id = UserDefaults.standard.value(forKey: kUserIDKey) as? String {
            return id
        } else {
            UserDefaults.standard.setValue(UUID().uuidString, forKey: kUserIDKey)
            UserDefaults.standard.synchronize()
            return getUserID()
        }
    }
    
    public func saveImage(name: String, imageData: Data) {
        var request = URLRequest(url: URL(string: "\(kEndPoint)/")!,timeoutInterval: Double.infinity)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = imageData
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            self.logResult(data)
        }
        task.resume()
    }
    
    public func save<T:Codable>(data: T) {
        guard let userID = UserDefaults.standard.value(forKey: kUserIDKey) as? String else {
            print ("No user ID set.  Run getUserID() atleast once when starting up your app")
            return
        }
        let url = URL(string: "http://\(kEndPoint)/\(appID)/\(userID)/\(T.self)")!
        var request = URLRequest(url: url)
        displayRequest(request: request)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(data)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            self.logResult(data)
        }
        task.resume()
    }
    
    public func get<T: Codable>(dummy: T, queries:[String : Any], complete: @escaping (([T]) -> Void)) {
        var urlString = "http://\(kEndPoint)/\(appID)/\(T.self)"
        if queries.keys.count > 0 {
            urlString += "?"
            for (key, value) in queries {
                urlString += "\(key)=\(value)"
            }
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        displayRequest(request: request)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else { print(error!.localizedDescription); return}
            if let data = data {
                self.logResult(data)
                let result = try? JSONDecoder().decode([T].self, from: data)
                complete(result ?? [])
            } else {
                complete([])
            }
        }
        task.resume()
    }
    public func delete<T: Codable>(dummy: T, queries:[String : Any], complete: @escaping (([T]) -> Void)) {
        var urlString = "http://\(kEndPoint)/\(appID)/\(T.self)"
        if queries.keys.count > 0 {
            urlString += "?"
            for (key, value) in queries {
                urlString += "\(key)=\(value)"
            }
        }
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        displayRequest(request: request)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else { print(error!.localizedDescription); return}
            if let data = data {
                self.logResult(data)
                let result = try? JSONDecoder().decode([T].self, from: data)
                complete(result ?? [])
            } else {
                complete([])
            }
        }
        task.resume()
    }

    public func getAll<T: Codable>(dummy: T, complete: @escaping (([T]) -> Void)) {
        let url = URL(string: "http://\(kEndPoint)/\(appID)/\(T.self)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        displayRequest(request: request)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else { print(error!.localizedDescription); return}
            if let data = data {
                self.logResult(data)
                let result = try? JSONDecoder().decode([T].self, from: data)
                complete(result ?? [])
            } else {
                complete([])
            }
        }
        task.resume()
    }

    public func deleteByID<T:Codable>(dummy: T, id: String) {
        let url = URL(string: "http://\(kEndPoint)/\(appID)/\(T.self)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        displayRequest(request: request)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else { print(error!.localizedDescription); return}
            if let data = data {
                self.logResult(data)
            }
        }
        task.resume()
    }

    public func getByID<T:Codable>(dummy: T, id: String, complete: @escaping ((T?) -> Void)) {
        let url = URL(string: "http://\(kEndPoint)/\(appID)/\(T.self)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        displayRequest(request: request)
        let task = URLSession.shared.dataTask(with: request) {data, response, error in
            guard error == nil else { print(error!.localizedDescription); return}
            if let data = data {
                self.logResult(data)
                let result = try? JSONDecoder().decode(T.self, from: data)
                complete(result)
            } else {
                complete(nil)
            }
        }
        task.resume()
    }
    
    public func displayRequest(request: URLRequest) {
        print("\(request.httpMethod ?? "no http method set"): \(request.url?.absoluteString ?? "url is nil")")
    }
    
    public func logResult(_ data: Data?) {
        guard showJSONResults else { return }
        guard let data = data else { return }
        print(String(decoding: data, as: UTF8.self))
    }
}
