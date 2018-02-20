//
//  MCTask.swift
//  MCTask
//
//  Created by Baglan on 01/01/2018.
//  Copyright © 2018 Mobile Creators. All rights reserved.
//

import Foundation

/// Observes get notified when the task state changes
protocol MCTaskObserver: class {
    func stateChanged(task: MCTask)
}

/// The base MCTask class
class MCTask {
    enum TastState {
        case initial
        case started
        case finished
        case cancelled
        case failed
    }
    
    /// Timer state
    /// Changes in the state will inform the registered observers
    var state: TastState = .initial {
        didSet {
            // Observers
            for observer in observers {
                observer.stateChanged(task: self)
            }
            
            // Callbacks
            switch state {
            case .started:
                onStarted?(self)
            case .finished:
                onFinished?(self)
            case .cancelled:
                onCancelled?(self)
            case .failed:
                onFailed?(self)
            default:
                break
            }
        }
    }
    
    internal var observers = [MCTaskObserver]()
    
    /// Add an observer
    /// Observers get notified when the task state changes
    func add(observer: MCTaskObserver) {
        observers.append(observer)
    }
    
    /// Remove an observer
    func remove(observer: MCTaskObserver) {
        observers = observers.filter { (o) -> Bool in return observer === o }
    }
    
    /// Start the task
    /// The default implmenetation sets the state to _started_ and then to _finished_
    func start() {
        state = .started
        state = .finished
    }
    
    /// Cancel the task
    /// The default implementation just sets the state to _cancelled_
    func cancel() {
        guard state == .started else { return }
        state = .cancelled
    }
    
    // MARK: - Callbacks
    
    /// Callback that will be called when the task starts
    var onStarted: ((_:MCTask)->Void)?
    
    /// Callback that will be called when the task is finished
    var onFinished: ((_:MCTask)->Void)?
    
    /// Callback that will be called when the task fails
    var onFailed: ((_:MCTask)->Void)?
    
    /// Callback that will be called when the task is cancelled
    var onCancelled: ((_:MCTask)->Void)?
}

extension MCTask {
    
    /// Task tracking a timer
    class TimedTask: MCTask {
        
        /// Timer duration
        let duration: TimeInterval
        
        /// Initialize with timer interval
        init(duration: TimeInterval) {
            self.duration = duration
        }
        
        internal var timer: Timer?
        
        /// Start the timer
        override func start() {
            timer?.invalidate()
            
            timer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false, block: { [unowned self] (timer) in
                self.state = .finished
            })
            
            state = .started
        }
        
        /// Cancel the timer
        override func cancel() {
            timer?.invalidate()
            timer = nil
            
            super.cancel()
        }
    }
}

extension MCTask {
    
    /// Task that tracks some one-off event, say, a button press
    class BasicTask: MCTask {
        override func start() {
            state = .started
        }
        
        /// Finish the task
        func finish() {
            state = .finished
        }
    }
}

