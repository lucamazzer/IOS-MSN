//
//  DBManager.swift
//  Messenger
//
//  Created by luca andrea mazzer on 13/05/2022.
//

import Foundation

import FirebaseDatabase

final class DBManager {
    static let share = DBManager()
    
    private let database = Database.database().reference()
    
}

// MARK - account Manager

extension DBManager {
    
    public func userExist(with email: String, completion: @escaping ((Bool) -> Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
              
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    
    // insert new user into DB
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmail).setValue(["first_name": user.firstName,
                                             "last_name": user.lastName])
    }
}


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let email: String
    var safeEmail: String {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    // let profilePictureUrl: String
}
