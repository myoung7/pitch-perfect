//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Matthew Young on 12/13/15.
//  Copyright © 2015 Matthew Young. All rights reserved.
//

import Foundation

final class RecordedAudio: NSObject {
    
    var filePathURL: NSURL
    var title: String
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
    
}