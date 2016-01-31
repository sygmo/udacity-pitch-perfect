//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Sydney Mercier on 1/23/16.
//  Copyright © 2016 Sydney Mercier. All rights reserved.
//

import Foundation

class RecordedAudio {
    
    var filePathURL: NSURL!
    var title: String!
    
    init(filePathURL:NSURL!, title:String!) {
        self.filePathURL = filePathURL
        self.title = title
    }
}