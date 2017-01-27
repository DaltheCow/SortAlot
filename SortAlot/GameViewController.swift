
import UIKit

class GameViewController: UIViewController {

    var height = UIScreen.mainScreen().bounds.size.height,
        width = UIScreen.mainScreen().bounds.size.width,
    
        startPos = CGPointMake(0,0),
        endPos = CGPointMake(0,0),
    
        gameFlag = true,
    
        date = NSDate().timeIntervalSince1970,
        milliseconds: Double = 0,
        difference: Double = 0, //gets larger whenever millisecond counter is paused
        pauseFlag = false,
        renderTimer: Double = 25,
        updateArray: [(type: UIImageView, duration: Double, beginAt: Double, pos: CGPoint, size: CGPoint, needsPos: Bool)] = [],
        backgroundImg: [UIImageView] = [],
        backgroundImgIndex = 0,
        theShapes: Shapes?,
        theGamePanel: GamePanel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        theShapes = Shapes(height: self.height, width: self.width)
        theShapes!.setShapes()
        theShapes!.newShape()
        theGamePanel = GamePanel(height: self.height, width: self.width)
        theGamePanel!.setPanelPosition(view)
        
        theGamePanel!.setText()
        setBackground()
        //set background
    }
    
    func newText() {
        // 1/4 chance that it switches
        if (Int(arc4random_uniform(4)) == 0) {
            if (theGamePanel!.currentText!.src == "color.png") {
                backgroundImgIndex = 1
                theGamePanel!.currentText = (src: theGamePanel!.shapeText!.src, aspectRatio: theGamePanel!.shapeText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
            } else {
                backgroundImgIndex = 0
                theGamePanel!.currentText = (src: theGamePanel!.colorText!.src, aspectRatio: theGamePanel!.colorText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
            }
            
            theGamePanel!.currentText!.size = CGPointMake(theGamePanel!.currentText!.aspectRatio * height * 1/10, height * 1/10)
            theGamePanel!.currentText!.pos = CGPointMake(width/2 - theGamePanel!.currentText!.size.x/2 - 3, 45 - 3)
        }
        render()
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
    
    func setImageViews(src: String) -> UIImageView {
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
    
    func addTemplateImage(x: CGFloat, y: CGFloat, color: UIColor, imageView: UIImageView) {
        //image and imageView are not initialized in here because imageView is needed to check for collisions
        
        //all shapes are displayed as 100 by 100, change so that it is percentage of screen size
        imageView.frame = CGRect(x: x, y: y, width: 3/10 * height, height: 3/10 * height)
        view.addSubview(imageView)
    }
    
    //change
    func addImage(name: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let image = UIImage(named: name),
            imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(imageView)
    }
    //difference between adding template and background is template images are the shapes that have a changing position and background images never change position
    func addBackgroundImage(imageView: UIImageView) {
        view.addSubview(imageView)
    }

    func render() {
        //try to find lighter way to display the view so the NSTimer can run more often
        var indexes: [Int] = []
        view.subviews.forEach({ $0.removeFromSuperview() })
        addBackgroundImage(backgroundImg[backgroundImgIndex])
        
        for (index, el) in updateArray.enumerate() {
            if (el.beginAt + el.duration <= milliseconds) {
                indexes.append(index)
            } else if (el.beginAt <= milliseconds) {
                if (el.needsPos) {
                } else {
                    addBackgroundImage(el.type)
                }
            }
        }
        for index in indexes.reverse() {
            updateArray.removeAtIndex(index)
        }
        for shape in theShapes!.shapeSet {
            addTemplateImage(shape.pos.x, y: shape.pos.y, color: shape.color, imageView: shape.imgView)
        }
        
        theGamePanel!.addPanel(view)
        
        let clockLabel = UILabel(frame: CGRectMake(theGamePanel!.currentText!.pos.x + theGamePanel!.currentText!.size.x - 45, 3, theGamePanel!.currentText!.size.x, 36))
        
        clockLabel.textColor = UIColor.blackColor()
        clockLabel.font = UIFont(name:"HelveticaNeue;", size: 20)
        clockLabel.font = clockLabel.font.fontWithSize(36)
        clockLabel.text = "59"
        view.addSubview(clockLabel)

        let clockLabel1 = UILabel(frame: CGRectMake(theGamePanel!.currentText!.pos.x, 3, theGamePanel!.currentText!.size.x, 36))
        clockLabel1.textColor = UIColor.blackColor()
        clockLabel1.font = UIFont(name:"HelveticaNeue;", size: 20)
        clockLabel1.font = clockLabel1.font.fontWithSize(36)
        clockLabel1.text = "1025"
        view.addSubview(clockLabel1)
        
        
        addImage(theGamePanel!.currentText!.src, x: theGamePanel!.currentText!.pos.x, y: theGamePanel!.currentText!.pos.y, width: theGamePanel!.currentText!.size.x, height: theGamePanel!.currentText!.size.y)
        
        addTemplateImage(theShapes!.currentShape!.pos.x, y: theShapes!.currentShape!.pos.y, color: theShapes!.currentShape!.color, imageView: theShapes!.currentShape!.imgView)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            startPos = touch.locationInView(self.view)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            endPos = touch.locationInView(self.view)
            theShapes!.currentShape!.pos = CGPointMake(endPos.x - 3/10 * height/2, endPos.y - 3/10 * height/2)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (theGamePanel!.currentText!.src == "shape.png") {
            for shape in theShapes!.shapeSet {
                if (shape.type == theShapes!.currentShape!.type && CGRectIntersectsRect(theShapes!.currentShape!.imgView.frame, shape.imgView.frame)) {
                    gameFlag = false
                }
            }
        } else {
            for shape in theShapes!.shapeSet {
                if (shape.color == theShapes!.currentShape!.color && CGRectIntersectsRect(theShapes!.currentShape!.imgView.frame, shape.imgView.frame)) {
                    gameFlag = false
                }
            }
        }
        
        if (!gameFlag) {
            theShapes!.newShape()
            gameFlag = true
            newText()
            updateArray.append((type: backgroundImg[2], duration: 150, beginAt: milliseconds, pos: CGPointMake(0,0), size: CGPointMake(0,0), needsPos: false))
        } else {
            for shape in theShapes!.shapeSet {
                if (CGRectIntersectsRect(theShapes!.currentShape!.imgView.frame, shape.imgView.frame)) {
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds, pos: CGPointMake(0,0), size: CGPointMake(0,0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds + 300, pos: CGPointMake(0,0), size: CGPointMake(0,0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds + 600, pos: CGPointMake(0,0), size: CGPointMake(0,0), needsPos: false))
                    theShapes!.newShape()
                    newText()
                }
            }
        }
        //do something with startPos and endPos
    }
    
    override func awakeFromNib() {
        NSTimer.scheduledTimerWithTimeInterval(
            0.001,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true)
    }
    //var last: Double = 0,
      //  lastdate: Double = 0
    func update() {
        //3-4 milliseconds to run the code
        let now = NSDate().timeIntervalSince1970
        //print((now-lastdate) * 1000)
        
        if (!pauseFlag) {
            milliseconds = (now - self.date - difference / 1000) * 1000
            if (milliseconds > renderTimer) {
                render()
                //print(milliseconds - last)
                //last = milliseconds
                renderTimer = milliseconds + 25
            }
        }
        else {
            difference = (now - self.date - milliseconds / 1000) * 1000
        }
        //lastdate = NSDate().timeIntervalSince1970
    }
    
    

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
