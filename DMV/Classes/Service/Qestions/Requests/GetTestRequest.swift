//
//  GetTestRequest.swift
//  Nursing
//
//  Created by Vitaliy Zagorodnov on 08.02.2021.
//

import Alamofire

struct GetTestRequest: APIRequestBody {
    private let userToken: String
    private let courseId: Int
    private let testId: Int?
    private let activeSubscription: Bool
    
    init(userToken: String, courseId: Int, testid: Int?, activeSubscription: Bool) {
        self.userToken = userToken
        self.courseId = courseId
        self.testId = testid
        self.activeSubscription = activeSubscription
    }
    
    var url: String {
        GlobalDefinitions.domainUrl + "/api/tests/get"
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var parameters: Parameters? {
        var params: [String: Any] = [
            "_api_key": GlobalDefinitions.apiKey,
            "_user_token": userToken,
            "course_id": courseId,
            "user_is_premium": activeSubscription
        ]
        
        if let testId = testId {
            params["test_id"] = testId
        }
        
        return params
    }
}
