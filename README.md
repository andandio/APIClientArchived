# AudiosearchClientSwift
Swift client for Audiosear.ch API : https://www.audiosear.ch/

See docs at https://www.audiosear.ch/developer/

OAuth credentials are available from https://www.audiosear.ch/oauth/applications

Example:

First, add 'AudiosearchClientSwift' to the podfile.

```swift
import 'AudiosearchClientSwift'

//create a client instance
let audiosearch = Audiosearch(id: YOUR_CLIENT_ID, secret: YOUR_CLIENT_SECRET, redirect_urls: [YOUR_URLS])

//fetch a show with id 60
self.audiosearch.getShowById(60) { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
 }
 
//fetch a show matching query string
self.audiosearch.getShowBySearchString("You Must Remember This") { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//fetch a person by ID
self.audiosearch.getPersonById(101){ (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//get related content
self.audiosearch.getRelated("shows", id: 20) { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//get trending on Twitter
self.audiosearch.getTrending() { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//get Tastemakers
self.audiosearch.getTastemakers("shows", number: 5){ (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//get Tastemakers by source
self.audiosearch.getTastemakersBySource("episodes", number: 5, tasteMakerId: 2) { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//get episode snippet
self.audiosearch.getEpisodeSnippet(399, timestampInSecs: 100) { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}

//customized search
self.audiosearch.search("2016 presidential campaign", params: ["filters[network]":"NPR", "size": "5", "from": "30" ], type:   "episodes") { (responseObject:AnyObject?, error:NSError?) in
            if (error != nil) {
                print(error)
            } else {
                print(responseObject)
            }
}
```

