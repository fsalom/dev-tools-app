//
//  Network.swift
//  utils
//
//  Created by Fernando Salom Carratala on 23/3/23.
//

import Foundation

func callGPT() {
    let openAIEndpoint = "https://api.openai.com/v1/engines/davinci-codex/completions"
    let openAIKey = "YOUR_API_KEY_HERE"
    let prompt = "Hello, ChatGPT!"
    
    let headers = [
        "Content-Type": "application/json",
        "Authorization": "Bearer \(openAIKey)"
    ]
    
    let parameters: [String: Any] = [
        "prompt": prompt,
        "max_tokens": 50,
        "temperature": 0.5
    ]
    
    guard let url = URL(string: openAIEndpoint) else {
        fatalError("Invalid URL")
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.allHTTPHeaderFields = headers
    request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
    
    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            // Handle the error here
            print(error)
            return
        }
        
        guard let data = data else {
            fatalError("No data returned")
        }
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let choices = json["choices"] as? [[String: Any]], let text = choices.first?["text"] as? String {
                // Use the generated text here
                print(text)
            }
        } catch {
            // Handle the error here
            print(error)
        }
    }
    
    task.resume()
}
