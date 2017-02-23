import UIKit

class GameViewController: UIViewController {

    var height = UIScreen.main.bounds.size.height,
        width = UIScreen.main.bounds.size.width,
        screenWidth = UIScreen.main.bounds.size.width,
        screenHeight = UIScreen.main.bounds.size.height,
    
        startPos = CGPoint(x: 0,y: 0),
        endPos = CGPoint(x: 0,y: 0),
    
        backgroundImg: [UIImageView] = [],
        backgroundImgIndex = 0,
        theShapes: Shapes?,
        theGamePanel: GamePanel?,
        menu: SideMenu?,
        game: GameTracking?,

        playView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.height = self.screenHeight
        self.width = self.screenWidth * 9/10
        
        playView = UIView(frame: CGRect(x: 1/10 * self.screenWidth, y: 0, width: width, height: height))
        self.view.addSubview(playView!)
        
        menu = SideMenu(x: 0, y: 0, height: height, width: 1/10 * screenWidth, view: self.view!, playView: playView!)
        
        theShapes = Shapes(height: height, width: width)
        theGamePanel = GamePanel(height: height, width: width, view: playView!)
        game = GameTracking()
        newGame()
        
        setBackground()
    }
    
    func newGame() {
        theShapes!.setShapes() //set corner shapes
        theShapes!.newShape() //set current shape
        theGamePanel!.setText() //set current text
        game?.newGame()
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
            game?.wasTextSwitch = true
            game?.textSwitchCount = (game?.textSwitchCount)! + 1
        } else {
            game?.wasTextSwitch = false
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
        playView!.addSubview(imageView)
    }
    
    func addImage(_ imageView: UIImageView) {
        playView!.addSubview(imageView)
    }

    func render() {
        var indexes: [Int] = []
        playView!.subviews.forEach({ $0.removeFromSuperview() })
        addImage(backgroundImg[backgroundImgIndex]) //make its own UIView

        for (index, el) in (game?.updateArray.enumerated())! {
            if (el.beginAt + el.duration <= (game?.time.milliseconds)!) {
                indexes.append(index)
            } else if (el.beginAt <= (game?.time.milliseconds)!) {
                if (el.needsPos) {
                } else {
                    addImage(el.type)
                }
            }
        }
        
        //remove in reverse to prevent errors
        for index in indexes.reversed() {
            game?.updateArray.remove(at: index)
        }
        for shape in theShapes!.shapeSet {
            addTemplateImage(shape.pos.x, y: shape.pos.y, width: shape.size.width, height: shape.size.height, imageView: shape.imgView)
        }
        
        theGamePanel!.addPanel((game?.score)!, time: (game?.time.timer)!)
        
        addImage((theGamePanel!.currentText?.imgView)!)
        
        addTemplateImage(theShapes!.currentShape!.pos.x, y: theShapes!.currentShape!.pos.y, width: theShapes!.currentShape!.size.width, height: theShapes!.currentShape!.size.height, imageView: theShapes!.currentShape!.imgView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            startPos = touch.location(in: playView)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if paused don't allow for movements
        if let touch = touches.first {
            endPos = touch.location(in: playView)
            if ((game?.roundFlag)! && !((menu?.paused)!)) {
                theShapes!.currentShape!.pos = CGPoint(x: endPos.x - 3/10 * height/2, y: endPos.y - 3/10 * height/2)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (theGamePanel!.currentText!.src == "shape.png") {
            for shape in theShapes!.shapeSet {
                if (shape.type == theShapes!.currentShape!.type && theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    game?.gameFlag = false
                }
            }
        } else {
            for shape in theShapes!.shapeSet {
                if (shape.color == theShapes!.currentShape!.color && theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    game?.gameFlag = false
                }
            }
        }
        
        if (!(game?.gameFlag)!) {
            //run code that follows a correct swipe
            //scoring before newText
            scoring(isCorrect: true)
            theShapes!.newShape()
            newText()
            game?.gameFlag = true
            game?.updateArray.append((type: backgroundImg[2], duration: 150, beginAt: (game?.time.milliseconds)!, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
        } else {
            for shape in theShapes!.shapeSet {
                if (theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    game?.updateArray.append((type: backgroundImg[3], duration: 200, beginAt: (game?.time.milliseconds)!, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    game?.updateArray.append((type: backgroundImg[3], duration: 200, beginAt: (game?.time.milliseconds)! + 300, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    game?.updateArray.append((type: backgroundImg[3], duration: 200, beginAt: (game?.time.milliseconds)! + 600, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
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
            var streakScore = (game?.streak)!,
                textScore = 0,
                streakTens = 0
            if ((game?.streak)! > 0 && (game?.streak)! % 10 == 0) {
                streakTens = 10
            }
            if (streakScore > 10) {
                streakScore = 10
            }
            if (game?.wasTextSwitch)! {
                textScore = 10
            }
            game?.score = (game?.score)! + streakScore + textScore + streakTens + 10
            game?.streak = (game?.streak)! + 1
            if ((game?.streak)! > (game?.longStreak)!) {
                game?.longStreak = (game?.streak)!
            }
        } else {
            game?.streak = 0
            game?.score = (game?.score)! - 5
        }
    }
    //scoring for after a round
    func postScoring() {
        game?.score = (game?.score)! + (game?.longStreak)! * 2 + (game?.textSwitchCount)! * 5
    }
    
    override func awakeFromNib() {
        Timer.scheduledTimer(
            timeInterval: 0.001,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true)
    }
    
    /*var last: Double = 0
     func fps() {
        print((game?.time.milliseconds)! - last)
        last = (game?.time.milliseconds)!
    }*/
    
    func update() {
        let now = Date().timeIntervalSince1970
        
        //if the game isn't paused
        if (!(menu?.paused)!) {
            game?.time.milliseconds = (now - (game?.time.date)! - (game?.time.difference)! / 1000) * 1000
            
            //render game view when necessary
            if ((game?.time.milliseconds)! > (game?.time.renderTimer)!) {
                render()
                
                //set next render time
                game?.time.renderTimer = (game?.time.milliseconds)! + 25
                
                //if timer is up end round
                if ((game?.time.timer)! < 1 && (game?.time.milliseconds)! / 1000 > (game?.time.timerLength)! && (game?.roundFlag)!) {
                    game?.roundFlag = false
                    postScoring()
                }
            }
            //update timer
            if (game?.roundFlag)! {
                game?.time.timer = Int((game?.time.timerLength)!) - Int((game?.time.milliseconds)!/1000)
            }
        }
        //if the game is paused
        else {
            if (menu?.restart)! {
                newGame()
                menu?.restart = false
            }
            
            menu?.render()
            
            game?.time.difference = (now - (game?.time.date)! - (game?.time.milliseconds)! / 1000) * 1000
        }
    }
    
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
