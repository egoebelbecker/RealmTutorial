//
//  RealmTutorialTests.swift
//  RealmTutorialTests
//
//  Created by Eric Goebelbecker on 10/28/18.
//  Copyright © 2018 Eric Goebelbecker. All rights reserved.
//

import XCTest
import RealmSwift
@testable import RealmTutorial

class RealmTutorialTests: XCTestCase {
    
    var comicStore: ComicBookStore = ComicBookStore()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
        let realm = try! Realm()

        comicStore.realm = realm
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSaveAndGetComic() {
        
        do {
            
            let comic = comicStore.makeNewComicBook( "Amazing Spider-Man", character: "Punisher", issue: 129)
            
            try comicStore.saveComicBook(comic)
            let foundComics = try comicStore.findComicsByTitle("Amazing Spider-Man")
            XCTAssertEqual(foundComics.count, 1)
            
            let comic1 = foundComics.first
            XCTAssertEqual(comic1?.issue, 129)
            
        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    func testSaveAndUpdateComic() {
        
        do {
            
            let newComic = comicStore.makeNewComicBook( "The Incredible Hulk", character: "Wendigo", issue: 181)
            try comicStore.saveComicBook(newComic)
            
            let foundComics = try comicStore.findComicsByTitle("The Incredible Hulk")
            
            let foundComic = foundComics.first
            XCTAssertEqual(foundComic?.character, "Wendigo")
            
            try comicStore.updateComicBooks("character", currentValue: "Wendigo", updatedValue: "Wolverine")
            
            let changedComics = try comicStore.findComicsByTitle("The Incredible Hulk")
            XCTAssertEqual(changedComics.count, 1)

            let changedComic = changedComics.first
            XCTAssertEqual(changedComic?.character, "Wolverine")

        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    func testDelete() {
        
        do {
            
            let newComic = comicStore.makeNewComicBook( "Captain America", character: "Red Skull", issue: 183)
            try comicStore.saveComicBook(newComic)

            let newerComic = comicStore.makeNewComicBook( "Captain America", character: "Red Skull", issue: 183)
            try comicStore.deleteComicBook(newerComic)

            let foundComics = try comicStore.findComicsByTitle("Captain America")
            XCTAssertEqual(foundComics.count, 0)

        } catch RuntimeError.NoRealmSet {
            XCTAssert(false, "No realm database was set")
        } catch {
            XCTAssert(false, "Unexpected error \(error)")
        }
    }
    
    
}
