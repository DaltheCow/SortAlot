import UIKit

//for keeping track of in game data like score, time, streak, etc
//consider hosting shape and game panel information in here too for simplifying restarts
class GameTracking {
    var gameFlag: Bool?,
        roundFlag: Bool?,
        //time stuff can be a class so it can be easily reset
        time = (date: Date().timeIntervalSince1970, milliseconds: 0.0, difference: 0.0, renderTimer: 25.0, timer: 0, timerLength: 45.0),
        updateArray: [(type: UIImageView, duration: Double, beginAt: Double, pos: CGPoint, size: CGPoint, needsPos: Bool)] = [],
        score: Int?,
        wasTextSwitch: Bool?,
        streak: Int?,
        longStreak: Int?,
        textSwitchCount: Int?
    
    func newGame() {
        gameFlag = true
        roundFlag = true
        //time stuff can be a class so it can be easily reset
        time = (date: Date().timeIntervalSince1970, milliseconds: 0.0, difference: 0.0, renderTimer: 25.0, timer: 0, timerLength: 45.0)
        updateArray = []
        score = 0
        wasTextSwitch = false
        streak = 0
        longStreak = 0
        textSwitchCount = 0
        
        //initialize timer
        time.timer = Int(time.timerLength)
    }
}
