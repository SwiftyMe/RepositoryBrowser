//
//  RepositoryBrowserTests.swift
//  RepositoryBrowserTests
//
//  Created by Anders Lassen on 14/04/2021.
//

import XCTest
import Combine
@testable import RepositoryBrowser

class RepositoryBrowserTests: XCTestCase {

    func testExample1() throws {

        let vm = RepositoryBrowserViewModel(api:APIServiceMockup1(repositoryCount:2, releaseCount:1))
        
        vm.searchText = ""
        
        XCTAssert(vm.repositories == nil)
    }

    func testExample2() throws {

        let vm = RepositoryBrowserViewModel(api:APIServiceMockup1(repositoryCount:2, releaseCount:1))
        
        vm.searchText = "name1"
        
        let repositories = try wait(vm.$repositories.dropFirst())

        XCTAssert(repositories!.count == 1)
        XCTAssert(repositories!.first!.id == 1)
        XCTAssert(repositories!.first!.name == "name1")
        XCTAssert(repositories!.first!.description == "desc1")
    }
    
    func testExample3() throws {

        let vm = RepositoryBrowserViewModel(api:APIServiceMockup1(repositoryCount:1, releaseCount:1))
        
        vm.searchText = "name1"
        
        let repositories = try wait(vm.$repositories.dropFirst())

        XCTAssert(repositories!.count == 0)
    }
    
    func testExample4() throws {

        let vm = RepositoryBrowserViewModel(api:APIServiceMockup1(error:APIError.Network(.HTTPCode(-344))))
        
        vm.searchText = "name1"
        
        let error = try wait(vm.$error.dropFirst())

        XCTAssertNil(vm.repositories)
        XCTAssertNotNil(error)
    }
}
