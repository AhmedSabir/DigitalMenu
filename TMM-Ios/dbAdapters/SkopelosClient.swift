//
//  SkopelosClient.swift
//  TMM-Ios
//
//  Created by Aakash Srivastav on 11/12/19.
//  Copyright © 2019 One World United. All rights reserved.
//

import Skopelos

protocol SkopelosClientDelegate: class {
    func handle(_ error: NSError)
}

class SkopelosClient: Skopelos {
    
    static let modelURL = Bundle.main.url(forResource: "TMM-Ios", withExtension: "momd")!
    static let shared = Skopelos(sqliteStack: modelURL)
    
    weak var delegate: SkopelosClientDelegate?
    
    class func sqliteStack() -> Skopelos {
        return Skopelos(sqliteStack: modelURL)
    }
    
    class func inMemoryStack() -> Skopelos {
        return Skopelos(inMemoryStack: modelURL)
    }
    
    override func handle(error: NSError) {
        DispatchQueue.main.async {
            self.delegate?.handle(error)
        }
    }
}
