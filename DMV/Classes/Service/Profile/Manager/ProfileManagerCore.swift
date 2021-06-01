//
//  ProfileManagerCore.swift
//  CDL
//
//  Created by Andrey Chernyshev on 22.04.2021.
//

import RxSwift

final class ProfileManagerCore {
    enum Constants {
        static let cachedSelectedSpecificTopicsKey = "cachedSelectedSpecificTopicsKey"
        static let cachedCountiesKey = "cachedCountiesKey"
    }
}

// MARK: Specific Topic
extension ProfileManagerCore {
    func obtainSpecificTopics() -> Single<[SpecificTopic]> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .deferred { .just([]) }
        }
        
        let request = GetTopicsRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetTopicsResponseMapper.map(from:))
    }
    
    func obtainSelectedSpecificTopics() -> Single<[SpecificTopic]> {
        Single<[SpecificTopic]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.cachedSelectedSpecificTopicsKey) else {
                event(.success([]))
                return Disposables.create()
            }
            
            let array = try? JSONDecoder().decode([SpecificTopic].self, from: data)
            
            event(.success(array ?? []))
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
    
    func saveSelected(specificTopics: [SpecificTopic]) -> Single<Void> {
        Single<Void>.create { event in
            guard let data = try? JSONEncoder().encode(specificTopics) else {
                return Disposables.create()
            }
            
            UserDefaults.standard.setValue(data, forKey: Constants.cachedSelectedSpecificTopicsKey)
            
            event(.success(Void()))
            
            ProfileMediator.shared.notifyAboutSaveSelected(specificTopics: specificTopics)
            
            return Disposables.create()
        }
    }
    
    func set(topicsIds: [Int]? = nil) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = SetRequest(userToken: userToken,
                                 topicsIds: topicsIds)

        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
    }
}

// MARK: Counties
extension ProfileManagerCore {
    func retrieveCountries(forceUpdate: Bool) -> Single<[Country]> {
        guard forceUpdate else {
            return getCachedCountries()
        }
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: GetCountriesRequest())
            .map(GetCountriesResponseMapper.map(from:))
            .flatMap(cache)
    }
    
    private func getCachedCountries() -> Single<[Country]> {
        Single<[Country]>.create { event in
            guard let data = UserDefaults.standard.data(forKey: Constants.cachedCountiesKey) else {
                event(.success([]))
                
                return Disposables.create()
            }
            
            let array = try? JSONDecoder().decode([Country].self, from: data)
            let countries = array ?? []
            
            event(.success(countries))
            
            return Disposables.create()
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
    }
    
    private var cache: ([Country]) -> Single<[Country]> {
        return { countries -> Single<[Country]> in
            Single<[Country]>.create { event in
                guard let data = try? JSONEncoder().encode(countries) else {
                    event(.success(countries))
                    
                    return Disposables.create()
                }
                
                UserDefaults.standard.setValue(data, forKey: Constants.cachedCountiesKey)
                
                event(.success(countries))
                
                return Disposables.create()
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
        }
    }
}

// MARK: Profile locale
extension ProfileManagerCore {
    func obtainProfileLocale() -> Single<ProfileLocale?> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }
        
        let request = GetLocaleRequest(userToken: userToken)
        
        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map(GetLocaleResponseMapper.map(from:))
    }
    
    func set(country: String? = nil,
             state: String? = nil,
             language: String? = nil) -> Single<Void> {
        guard let userToken = SessionManagerCore().getSession()?.userToken else {
            return .error(SignError.tokenNotFound)
        }

        let request = SetRequest(userToken: userToken,
                                 country: country,
                                 state: state,
                                 language: language)

        return SDKStorage.shared
            .restApiTransport
            .callServerApi(requestBody: request)
            .map { _ in Void() }
            .do(onSuccess: {
                let locale = ProfileLocale(countryCode: country,
                                           languageCode: language,
                                           stateCode: state)
                ProfileMediator.shared.notifyAboutUpdated(profileLocale: locale)
            })
    }
}
