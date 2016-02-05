//
//  Audiosearch.swift
//  AudiosearchClientSwift
//
//  Created by Anders Howerton on 1/28/16.
//  Copyright © 2016 Pop Up Archive. All rights reserved.
//

import Foundation
import Alamofire
import p2_OAuth2

public typealias ServiceResponseAny = (AnyObject?, NSError?) -> Void

public class Audiosearch {
    
    var oauth2: OAuth2ClientCredentials?
    var settings: OAuth2JSON
    
    public init (id: String, secret: String, redirect_urls:[String]) {
        self.settings = [
            "client_id": id,
            "client_secret": secret,
            "authorize_uri": "https://audiosear.ch/oauth/authorize",
            "token_uri": "https://audiosear.ch/oauth/token", // code grant only!
            "scope": "",
            "redirect_uris": redirect_urls,  // Don't forget to register this scheme. Format here should be: ["<com.your-org-name.your-org-name>://oauth/callback"]
            "keychain": false,     // if you DON'T want keychain integration
            "secret_in_body": "true" //important to have this for client credential type oauth2 -- aka entire app rather than individual user
            ] as OAuth2JSON
        
        self.oauth2 = OAuth2ClientCredentials(settings: self.settings)
        print(self.oauth2)
        
        self.oauth2!.onAuthorize = { parameters in
            print("Did authorize with parameters: \(parameters)")
            self.oauth2!.clientConfig.accessToken = parameters["access_token"] as? String
        }
        self.oauth2!.onFailure = { error in
            if nil != error {
                print("Authorization went wrong: \(error)")
            }
        }
        
        self.oauth2!.authorize()
    }
    
    public func getShowById(id: Int, onCompletion: ServiceResponseAny ) -> Void {
        let stringId = String(id)
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/shows/\(stringId)", encoding:.JSON).responseJSON {response in switch response.result {
            case .Success(let JSON):
                let result = JSON
                onCompletion(result, nil)
            case .Failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    public func getShowBySearchString(words: String, onCompletion: ServiceResponseAny) -> Void {
        let podcastWordsEncoded = words.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
    
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/search/shows/\(podcastWordsEncoded!)"
            , encoding:.JSON).responseJSON {response in switch response.result {
            case .Success(let JSON):
                let result = JSON
                onCompletion(result, nil)
            case .Failure(let error):
                onCompletion(nil, error)
            }
        }
        
    }

    public func getEpisodeById(epId: Int, onCompletion: ServiceResponseAny) -> Void {
        let stringID = String(epId)
        
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/episodes/\(stringID)", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
    
    public func search(query: String, params: Dictionary<String,String>?, type: String, onCompletion: ServiceResponseAny) -> Void  {
        var queryItems: [NSURLQueryItem] = []
        let query:NSString = query.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let queryString = "https://www.audiosear.ch/api/search/\(type)/\(query)"
        let components = NSURLComponents(string: queryString)
        if params != nil {
            for (key, value) in params! {
                queryItems.append(NSURLQueryItem(name: key , value: value as String))
            }
        }
        components?.queryItems = queryItems
        let finalSearchString = components!.string!
        self.oauth2!.request(.GET, finalSearchString, encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }

    public func getTrending(onCompletion: ServiceResponseAny) -> Void {
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/trending", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
    
    public func getTastemakers(type: String, number: Int, onCompletion: ServiceResponseAny) -> Void {
        let stringNum = String(number)
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/tastemakers/\(type)/\(stringNum)", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
    
    public func getPersonById(id: Int, onCompletion: ServiceResponseAny) -> Void  {
        let stringId = String(id)
        print("https://www.audiosear.ch/api/people/\(stringId)")
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/people/\(stringId)", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
        
    }
    
    public func getPersonByName(name: String, onCompletion: ServiceResponseAny) -> Void  {
        let personNameEncoded = name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/search/people/\(personNameEncoded!)"
            , encoding:.JSON).responseJSON {response in switch response.result {
            case .Success(let JSON):
                print("Success with JSON: \(JSON)")
                let result = JSON
                onCompletion(result, nil)
            case .Failure(let error):
                onCompletion(nil, error)
            }
        }
    }
    
    public func getRelated(type: String, id: Int, onCompletion: ServiceResponseAny) -> Void {
        let stringId = String(id)
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/\(type)/\(stringId)/related", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
    
    public func getTastemakersBySource(type: String, number: Int, tasteMakerId: Int, onCompletion: ServiceResponseAny) -> Void {
        let stringTasteMakerID = String(tasteMakerId)
        let stringNum = String(number)
        
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/tastemakers/\(type)/source/\(stringTasteMakerID)/\(stringNum)", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
    
    public func getEpisodeSnippet(episodeId: Int, timestampInSecs: Int, onCompletion: ServiceResponseAny) -> Void {
        let stringEpId = String(episodeId)
        let stringTimestamp = String(timestampInSecs)
        
        self.oauth2!.request(.GET, "https://www.audiosear.ch/api/episodes/\(stringEpId)/snippet/\(stringTimestamp)", encoding:.JSON).responseJSON {response in switch response.result {
        case .Success(let JSON):
            let result = JSON
            onCompletion(result, nil)
        case .Failure(let error):
            onCompletion(nil, error)
            }
        }
    }
        
}

public extension OAuth2 {
    public func request(
        method: Alamofire.Method,
        _ URLString: URLStringConvertible,
        parameters: [String: AnyObject]? = nil,
        encoding: Alamofire.ParameterEncoding = .URL,
        headers: [String: String]? = nil)
        -> Alamofire.Request
    {
        
        var hdrs = headers ?? [:]
        if let token = accessToken {
            hdrs["Authorization"] = "Bearer \(token)"
        }
        return Alamofire.request(
            method,
            URLString,
            parameters: parameters,
            encoding: encoding,
            headers: hdrs)
    }
}