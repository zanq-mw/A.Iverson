//
//  API.swift
//  A.Iverson
//
//  Created by Anders Tai on 2023-08-07.
//

import Foundation
import SwiftUI

class API: ObservableObject {
    @Published var response: Response?
    @Published var request: Request?
    @Published var viewModel: ContentView.ViewModel?

    func message(_ text: String) async -> Response? {
        var request = URLRequest(url: URL(string: "http://127.0.0.1:8000/message")!)

        let tempBody = Request(user_message: text, mode: response?.mode ?? .none, bet_data: response?.bet_data ?? nil, bet: response?.bet ?? nil, saved_question: nil)
        do {
            let jsonData = try JSONEncoder().encode(tempBody)
            let jsonString = String(data: jsonData, encoding: .utf8)!
            print(jsonString)

            request.httpBody = jsonData
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data.prettyPrintedJSONString!)
            let responseData = try JSONDecoder().decode(Response.self, from: data)
            self.response = responseData
            return responseData
        } catch {
            print(error)
            return nil
        }
        
        return nil
    }

    init(response: Response? = nil, request: Request? = nil, viewModel: ContentView.ViewModel? = nil) {
        self.response = response
        self.request = request
        self.viewModel = viewModel
    }
}

struct Request: Codable {
    let user_message: String
    let mode: BotMode
    let bet_data: BetData?
    let bet: FinalBetData?
    let saved_question: [String]?

//    private enum CodingKeys: String, CodingKey {
//        case user_message, mode, bet_data, bet, suggested_prompts
//    }

//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(user_message, forKey: .user_message)
//        try container.encode(mode.rawValue, forKey: .mode)
//        try container.encode(bet_data, forKey: .bet_data)
//        try container.encode(bet, forKey: .bet)
//        try container.encode(suggested_prompts, forKey: .suggested_prompts)
//    }
}

struct Response: Codable {
    let bot_message: String
    let mode: BotMode
    let bet_data: BetData?
    let bet: FinalBetData?
    let suggested_prompts: [String]?
}

enum BotMode: Int, Codable {
    case none = 1
    case bet = 2
    case question = 3
}

struct BetData: Codable {
    let sport: String?
    let team: String?
    let bet_amount: Double?
    let points: Int?
    let game_title: String?
    let multiplier: Double?
    let odds: Int?
}

struct FinalBetData: Codable {
    let game_title: String
    let bet_title: String
    let bet_description: String
    let bet_amount: Double
    let to_win: Double
    let odds: Int
}
