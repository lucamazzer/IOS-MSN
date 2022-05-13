//
//  File.swift
//  Messenger
//
//  Created by luca andrea mazzer on 11/05/2022.
//

import Foundation



func checkIfUserLogged () -> Bool {
    return UserDefaults.standard.bool(forKey: "logged_in")
}
