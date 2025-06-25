//
//  Enums.swift
//  DemoDialpad
//
//  Created by iapp on 19/06/25.
//  Copyright © 2025 iApp. All rights reserved.
//


//MARK: - APIRequestState
enum APIRequestState {
    case notConsumedOnce, beingConsumed, consumedWithSuccess, consumedWithError
    
    var isBeingConsumed: Bool {
        return self == .beingConsumed
    }
    
    var isConsumed: Bool {
        return self == .consumedWithSuccess || self == .consumedWithError
    }
}

//MARK: - SearchState
enum SearchState {
    case notStarted, inProgress, complete
    
    var inProgress: Bool {
        return self == .inProgress
    }
    
    var isComplete: Bool {
        return self == .complete
    }
}
