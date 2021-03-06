//
//  Secret.swift
//  Secrets
//
//  Created by James Craige on 4/10/15.
//  Copyright (c) 2015 thoughtbot. All rights reserved.
//

import Parse
import PromiseKit

class Secret: Modelable {
    class func find() -> Promise<[Secret]> {
        let query = PFQuery(className: "Secret")
        query.orderByDescending("createdAt")
        return query.findObjectsInBackgroundPromise()
    }
    
    class func createWithBody(body: String) -> Promise<Void> {
        var secret = PFObject(className: "Secret")
        secret["body"] = body
        secret["user"] = PFUser.currentUser()

        return LocationManager.currentNeighborhood().then { neighborhood in
            secret["neighborhood"] = neighborhood;
        }.finally {
            return secret.saveInBackgroundPromise()
        }
    }
    
    let object: PFObject
    
    required init(object: PFObject) {
        self.object = object
    }
    
    var body: String? {
        return object["body"] as? String
    }

    var neighborhood: String? {
        return object["neighborhood"] as? String
    }
    
    var createdAt: NSDate? {
        return object.createdAt
    }
    
    var hearts: Int {
        return object["hearts"] as? Int ?? 0
    }
    
    func addHeart() {
        self.object.incrementKey("hearts")
    }
    
    func saveEventually() {
        object.saveEventually()
    }
}