//
//  NetworkingTests.swift
//  TaskTests
//
//  Created by Habibur Rahman on 18/3/19.
//  Copyright © 2019 Habib. All rights reserved.
//

import XCTest
import Swinject
@testable import Task
class NetworkingTests: XCTestCase {
    let container = Container()
    
    override func setUp() {
        container.register(NetWorking.self) { _ in
            let data = try! JSONSerialization.data(withJSONObject: MockRepository.data, options: JSONSerialization.WritingOptions.prettyPrinted)
            let networking = MockNetworking(data: data, error: nil)
            return networking
        }
    }

    override func tearDown() {
        container.removeAll()
    }

    func testExample() {

    }


}

struct MockNetworking: NetWorking {
    var data: Data?
    var error: Error?
    init(data: Data?, error: Error?) {
        self.data = data
        self.error = error
    }
    func get(from endPoint: String, completion: @escaping completionHandler) {
        if let error = error {
            completion(.failure(error))
            return
        }
        
        if let data = data {
            completion(.success(data))
        }
    }
    
    
}
