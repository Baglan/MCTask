//
//  MCTaskRunner.swift
//  MCTask
//
//  Created by Baglan on 18/02/2018.
//  Copyright © 2018 Mobile Creators. All rights reserved.
//

import Foundation

extension MCTask: Equatable {
    
    /**
     Basic single-track runner.
     
     Will go through the list of tasks one after another in order.
     */
    class BasicRunner: MCTaskObserver {
        
        func stateChanged(task: MCTask) {
            guard tasks.contains(task) else { return }
            
            switch task.state {
            case .finished:
                next()
                break
            default:
                // Perhaps some more advanced logic for different states
                break
            }
        }
        
        /// A list of current tasks
        var tasks = [MCTask]() {
            willSet {
                
                // Remove this runner as an observer
                for task in tasks {
                    task.remove(observer: self)
                }
            }
            
            didSet {
                
                // Add this runner as an observer
                for task in tasks {
                    task.add(observer: self)
                }
            }
        }
        
        /// Is the runner paused
        var isPaused = true
        
        /// Start the runner
        func start() {
            isPaused = false
            next()
        }
        
        /// Fetch the first unfinished task from the **tasks** array and, if it is not yet running, start it
        func next() {
            for task in tasks {
                switch task.state {
                    case .initial:
                        // If there is an "unstarted task", start it and bail out
                        if !isPaused {
                            task.start()
                        }
                        return
                    case .started:
                        // If there is a running task, just bail out
                        return
                    case .finished: break;
                    case .failed: break;
                    case .cancelled: break;
                }
            }
        }
    }
}

func ==(a: MCTask, b: MCTask) -> Bool {
    return a === b
}
