
import UIKit

class GameViewController: UIViewController {

    var height = UIScreen.main.bounds.size.height,
        width = UIScreen.main.bounds.size.width,
    
        startPos = CGPoint(x: 0,y: 0),
        endPos = CGPoint(x: 0,y: 0),
    
        gameFlag = true,
    
        date = Date().timeIntervalSince1970,
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
        
        //theGamePanel!.setText()
        setBackground()
        //set background
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
    
    func addTemplateImage(_ x: CGFloat, y: CGFloat, color: UIColor, imageView: UIImageView) {
        //image and imageView are not initialized in here because imageView is needed to check for collisions
        
        //shape size is .3 x screen height
        imageView.frame = CGRect(x: x, y: y, width: 3/10 * height, height: 3/10 * height)
        view.addSubview(imageView)
    }
    
    //change
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
            if (el.beginAt + el.duration <= milliseconds) {
                indexes.append(index)
            } else if (el.beginAt <= milliseconds) {
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
            addTemplateImage(shape.pos.x, y: shape.pos.y, color: shape.color, imageView: shape.imgView)
        }
        
        theGamePanel!.addPanel(view)
        
        /*let clockLabel = UILabel(frame: CGRect(x: theGamePanel!.currentText!.pos.x + theGamePanel!.currentText!.size.x - 45, y: 3, width: theGamePanel!.currentText!.size.x, height: 36))
        
        clockLabel.textColor = UIColor.black
        clockLabel.font = UIFont(name:"HelveticaNeue;", size: 20)
        clockLabel.font = clockLabel.font.withSize(36)
        clockLabel.text = "59"
        view.addSubview(clockLabel)

        let clockLabel1 = UILabel(frame: CGRect(x: theGamePanel!.currentText!.pos.x, y: 3, width: theGamePanel!.currentText!.size.x, height: 36))
        clockLabel1.textColor = UIColor.black
        clockLabel1.font = UIFont(name:"HelveticaNeue;", size: 20)
        clockLabel1.font = clockLabel1.font.withSize(36)
        clockLabel1.text = "1025"
        view.addSubview(clockLabel1)
        
        */
        addImage((theGamePanel!.currentText?.imgView)!)
        
        addTemplateImage(theShapes!.currentShape!.pos.x, y: theShapes!.currentShape!.pos.y, color: theShapes!.currentShape!.color, imageView: theShapes!.currentShape!.imgView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        if let touch = touches.first {
            startPos = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            endPos = touch.location(in: self.view)
            theShapes!.currentShape!.pos = CGPoint(x: endPos.x - 3/10 * height/2, y: endPos.y - 3/10 * height/2)
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
            theShapes!.newShape()
            gameFlag = true
            newText()
            updateArray.append((type: backgroundImg[2], duration: 150, beginAt: milliseconds, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
        } else {
            for shape in theShapes!.shapeSet {
                if (theShapes!.currentShape!.imgView.frame.intersects(shape.imgView.frame)) {
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds + 300, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    updateArray.append((type: backgroundImg[3], duration: 200, beginAt: milliseconds + 600, pos: CGPoint(x: 0,y: 0), size: CGPoint(x: 0,y: 0), needsPos: false))
                    theShapes!.newShape()
                    newText()
                }
            }
        }
        //do something with startPos and endPos
    }
    
    override func awakeFromNib() {
        Timer.scheduledTimer(
            timeInterval: 0.001,
            target: self,
            selector: #selector(update),
            userInfo: nil,
            repeats: true)
    }
    //var last: Double = 0,
      //  lastdate: Double = 0
    func update() {
        //3-4 milliseconds to run the code
        let now = Date().timeIntervalSince1970
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
    
    

    override var prefersStatusBarHidden : Bool {
        return true
    }
}
