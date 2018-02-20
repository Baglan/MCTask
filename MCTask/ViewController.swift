//
//  ViewController.swift
//  MCTask
//
//  Created by Baglan on 01/01/2018.
//  Copyright © 2018 Mobile Creators. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var buttonTask: MCTask.BasicTask!
    var timerTask: MCTask.TimedTask!
    var runner = MCTask.BasicRunner()
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func onButton(_ sender: Any) {
        buttonTask.finish()
        
        
    }
    
    var displayLink: CADisplayLink?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if true {
            buttonTask = MCTask.BasicTask()
            runner.tasks.append(buttonTask)
        }
        
        if true {
            timerTask = MCTask.TimedTask(duration: 10)
            timerTask.onStarted = { [unowned self] _ in
                self.startCountdown()
            }
            timerTask.onFinished = { [unowned self] _ in
                self.endCountdown()
            }
            
            runner.tasks.append(timerTask)
        }
        
        runner.start()
    }
    
    func startCountdown() {
        displayLink = UIScreen.main.displayLink(withTarget: self, selector: #selector(updateScreen))
        displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func endCountdown() {
        self.displayLink?.invalidate()
        self.displayLink = nil
        progressView.progress = 1
        label.text = "Done!"
    }
    
    @objc func updateScreen() {
        guard let timer = timerTask.timer else { return }
        let timeLeft = timer.fireDate.timeIntervalSinceNow
        label.text = "\(timeLeft)"
        progressView.progress = Float(timeLeft / timerTask.duration)
    }
}
