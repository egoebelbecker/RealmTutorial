//
//  ComicBookStore.swift
//  RealmTutorial
//
//  Created by Eric Goebelbecker on 10/29/18.
//  Copyright © 2018 Eric Goebelbecker. All rights reserved.
//

import Foundation
import RealmSwift


enum RuntimeError: Error {
    case NoRealmSet
}


class ComicBookStore {
    
    var realm: Realm?
    
    public func saveComicBook(_ comic: ComicBook) throws
    {
        
        if (realm != nil) {
            try! realm!.write {
                realm!.add(comic)
            }
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    public func updateComicBooks(_ field: String, currentValue: String, updatedValue: String) throws
    {
        let comics = try findComicsByField(field, value: currentValue)
        try! realm!.write {
            comics.setValue(updatedValue, forKeyPath: "\(field)")
        }
    }
    
    private func findComicsByField(_ field: String, value: String) throws -> Results<ComicBook>
    {
        if (realm != nil) {
            let predicate = NSPredicate(format: "%K == %@", field, value)
            return realm!.objects(ComicBook.self).filter(predicate)
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    public func findComicsByTitle(_ title: String) throws -> Results<ComicBook>
    {
        return try findComicsByField("title", value: title)
    }
    
    public func deleteAllComics() throws
    {
        if (realm != nil) {
            try! realm!.write {
                realm!.deleteAll()
            }
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    
    public func deleteComicBook(_ comicBook: ComicBook) throws {
        
        if (realm != nil) {
            
            let predicate = NSPredicate(format: "title == %@ AND character == %@ AND issue == %d",
                                        comicBook.title, comicBook.character, comicBook.issue)
            let targetComics = realm!.objects(ComicBook.self).filter(predicate)
           
            var comics = targetComics.makeIterator()
            while let comic = comics.next() {
                try! realm!.write {
                    realm!.delete(comic)
                }
            }
        } else {
            throw RuntimeError.NoRealmSet
        }
    }
    
    
    public func makeNewComicBook(_ title: String, character: String, issue: Int ) -> ComicBook
    {
        
        let newComic = ComicBook()
        newComic.title = title
        newComic.character = character
        newComic.issue = issue
        
        return newComic
    }
    
}

