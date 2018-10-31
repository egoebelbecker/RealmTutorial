//
//  ComicBook.swift
//  RealmTutorial
//
//  Created by Eric Goebelbecker on 10/28/18.
//  Copyright © 2018 Eric Goebelbecker. All rights reserved.
//

import RealmSwift

class ComicBook: Object {
    @objc dynamic var title = ""
    @objc dynamic var character = ""
    @objc dynamic var issue = 0
}

