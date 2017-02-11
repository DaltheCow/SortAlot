import UIKit

class GameViewController: UIViewController {

    var height = UIScreen.main.bounds.size.height,
        width = UIScreen.main.bounds.size.width,
        screenWidth = UIScreen.main.bounds.size.width,
        screenHeight = UIScreen.main.bounds.size.height,
    
        startPos = CGPoint(x: 0,y: 0),
        endPos = CGPoint(x: 0,y: 0),
    
        gameFlag = true,
        roundFlag = true,
        //time stuff can be a class so it can be easily reset
        time = (date: Date().timeIntervalSince1970, milliseconds: 0.0, difference: 0.0, renderTimer: 25.0, timer: 0, timerLength: 45.0),
        updateArray: [(type: UIImageView, duration: Double, beginAt: Double, pos: CGPoint, size: CGPoint, needsPos: Bool)] = [],
    
        backgroundImg: [UIImageView] = [],
        backgroundImgIndex = 0,
        theShapes: Shapes?,
        theGamePanel: GamePanel?,
        menu: SideMenu?,
    
        score: Int = 0,
        wasTextSwitch: Bool = false,
        streak: Int = 0,
        longStreak: Int = 0,
        textSwitchCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.height = self.screenHeight
        self.width = self.screenWidth * 9/10
        theShapes = Shapes(height: self.height, width: self.width)
        theShapes!.setShapes()
        theShapes!.newShape()
        theGamePanel = GamePanel(height: self.height, width: self.width, view: view)
        menu = SideMenu(height: self.height, width: 1/10 * self.screenWidth, x: 9/10 * self.screenWidth, y: 0, view: view)
    
        setBackground()
        //initialize timer
        time.timer = Int(time.timerLength)
    }
    
    func newText() {
        // 1/4 chance that it switches
        if (Int(arc4random_uniform(4)) == 0) {
            if (theGamePanel!.currentText!.src == "color.png") {
                backgroundImgIndex = 1
                theGamePanel!.currentText = theGamePanel!.shapeText
            } else {
                backgroundImgIndex = 0
                theGamePanel!.currentText = theGamePanel!.colorText
            }
            wasTextSwitch = true
            textSwitchCount += 1
        } else {
            wasTextSwitch = false
        }
    }
    
    func setBackground() {
        //run after setText since this function relies on currentText.src being set
        let bckgrndImgArray = ["SortAlotBackgroundBase.png", "SortAlotBackgroundBaseReverse.png", "SortAlotBackgroundGreen1.png", "SortAlotBackgroundRed1.png"]
        backgroundImg = bckgrndImgArray.map{setImageViews($0)}
        if (theGamePanel!.currentText!.src == theGamePanel!.colorText!.src) {
            backgroundImgIndex = 0
        } else {
            backgroundImgIndex = 1
        }
    }
    
    func setImageViews(_ src: String) -> UIImageView {
        let image = UIImage(named: src),
        imageView = UIImageView(image: image)
        let imgAR = image!.size.width / image!.size.height
        var imgWidth = self.width,
        imgHeight = self.width / imgAR
        if (imgHeight < self.height) {
            imgHeight = self.height
            imgWidth = self.height * imgAR
        }
        imageView.frame = CGRect(x: 0, y: 0, width: 1.75 * imgWidth, height: 1.75 * imgHeight)
        return imageView
    }
    
    func addTemplateImage(_ x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, imageView: UIImageView) {
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(imageView)
    }
    
    func addImage(_ imageView: UIImageView) {
        view.addSubview(imageView)
    }
    //difference between adding template and background is template images are the shapes that have a changing position and background images never change position
    func addBackgroundImage(_ imageView: UIImageView) {
        view.addSubview(imageView)
    }

    func render() {
        //try to find lighter way to display the view so the NSTimer can run more often
        var indexes: [Int] = []
        view.subviews.forEach({ $0.removeFromSuperview() })
        addBackgroundImage(backgroundImg[backgroundImgIndex])
        
        for (index, el) in updateArray.enumerated() {
            if (el.beginAt + el.duration <= time.milliseconds) {
                indexes.append(index)
            } else if (el.beginAt <= time.milliseconds) {
                if (el.needsPos) {
                } else {
                    addBackgroundImage(el.type)
                }
            }
        }
        for index in indexes.reversed() {
            updateArray.remove(at: index)
        }
        for shape in theShapes!.shapeSet {
            addTemplateImage(shape.pos.x, y: shape.pos.y, width: shape.size.width, height: shape.size.height, imageView: shape.imgView)
        }
        
        theGamePanel!.addPanel(self.score, time: self.time.timer)
        
        addImage((theGamePanel!.currentText?.imgView)!)
        
        addTemplateImage(theShapes!.currentShape!.pos.x, y: theShapes!.currentShape!.pos.y, width: theShapes!.currentShape!.size.width, height: theShapes!.currentShape!.size.height, imageView: theShapes!.currentShape!.imgView)
        
        menu?.render()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startPos = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if paused don't allow for movements
        if let touch = touches.first {
            endPos = touch.location(in: self.view)
            if (roundFlag) {
                theShapes!.currentShape!.pos = CGPoint(x: endPos.x - 3/10 * height/2, y: endPos.y - 3/10 * height/2)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (theGamePanel!.currentText!.src == "shape.png") {
            for shape in theShapes!.shapeSet {
                if (shape.type == theShapes!.currentShape!.type && theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    gameFlag = false
                }
            }
        } else {
            for shape in theShapes!.shapeSet {
                if (shape.color == theShapes!.currentShape!.color && theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    gameFlag = false
                }
            }
        }
        
        if (!gameFlag) {
            //run code that follows a correct swipe
            //scoring before newText
            scoring(isCorrect: true)
            theShapes!.newShape()
            newText()
            gameFlag = true
            updateArray.append((type: backgroundImg[2], duration: 150, beginAt: time.milliseconds, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
        } else {
            for shape in theShapes!.shapeSet {
                if (theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: time.milliseconds, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: time.milliseconds + 300, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: time.milliseconds + 600, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    scoring(isCorrect: false)
                    theShapes!.newShape()
                    newText()
                }
            }
        }
        //do something with startPos and endPos
    }
    
    //scoring for during a round
    //this should be a class so it can be easily reset
    func scoring(isCorrect: Bool) {
        if (isCorrect) {
            var streakScore = streak,
                textScore = 0,
                streakTens = 0
            if (streak > 0 && streak % 10 == 0) {
                streakTens = 10
            }
            if (streakScore > 10) {
                streakScore = 10
            }
            if (wasTextSwitch) {
                textScore = 10
            }
            score += streakScore + textScore + streakTens + 10
            streak += 1
            if (streak > longStreak) {
                longStreak = streak
            }
        } else {
            streak = 0
            score -= 5
        }
    }
    //scoring for after a round
    func postScoring() {
        score += longStreak * 2 + textSwitchCount * 5
    }
    
    override func awakeFromNib() {
        Timer.scheduledTimer(
            timeInterval: 0.001,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true)
    }
    //var last: Double = 0
    func update() {
        //3-4 milliseconds to run the code
        let now = Date().timeIntervalSince1970
        
        if (!(menu?.paused)!) {
            time.milliseconds = (now - self.time.date - time.difference / 1000) * 1000
            if (time.milliseconds > time.renderTimer) {
                //in game rendering
                render()
                //print(time.milliseconds - last)
                //last = time.milliseconds
                time.renderTimer = time.milliseconds + 25
                if (time.timer < 1 && time.milliseconds / 1000 > time.timerLength && roundFlag) {
                    roundFlag = false
                    postScoring()
                }
            }
            if (roundFlag) {
                time.timer = Int(time.timerLength) - Int(time.milliseconds/1000)
            }
        }
        else {
            addImage((theGamePanel!.currentText?.imgView)!)
            
            time.difference = (now - self.time.date - time.milliseconds / 1000) * 1000
        }
    }
    
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
