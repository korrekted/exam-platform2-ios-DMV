//
//  GetTestModeRequest.swift
//  DMV
//
//  Created by Andrey Chernyshev on 04.07.2021.
//

import Alamofire

struct GetTestModeRequest: APIRequestBody {
    let userToken: String
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/users/show"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken
        ]
    }
}
