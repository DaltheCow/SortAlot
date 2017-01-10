
import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var height = UIScreen.mainScreen().bounds.size.height,
        width = UIScreen.mainScreen().bounds.size.width,
    
        shapeSet: [(type: String, color: UIColor, pos: CGPoint, img: UIImageView)] = [],
        currentShape: (type: String, color: UIColor, pos: CGPoint, img: UIImageView)? = nil,
        colorText: (src: String, aspectRatio: CGFloat)? = nil,
        shapeText: (src: String, aspectRatio: CGFloat)? = nil,
        currentText: (src: String, aspectRatio: CGFloat, size: CGPoint, pos: CGPoint)? = nil,
    
        startPos = CGPointMake(0,0),
        endPos = CGPointMake(0,0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setShapes()
        var randShape = Int(arc4random_uniform(4))
        let image = UIImage(named: shapeSet[randShape].type)
        let imageView = UIImageView(image: image)
        currentShape = (type: shapeSet[randShape].type,
                        color: shapeSet[Int(arc4random_uniform(4))].color,
                        pos: CGPointMake(width/2 - 50, height/2 - 50),
                        imgView: imageView)
        setText()
        if (Int(arc4random_uniform(2)) == 1) {
            currentText = (src: colorText!.src, aspectRatio: colorText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
        } else {
            currentText = (src: shapeText!.src, aspectRatio: shapeText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
        }
        currentText!.size = CGPointMake(currentText!.aspectRatio * 80, 80)
        currentText!.pos = CGPointMake(width/2 - currentText!.size.x/2, -15)
        render()
    }

    func setShapes() {
        //only use these 4 shapes
        let shapes = ["circle.png", "square.png", "triangle.png", "diamond.png"],
        //the 4 corners of the screen
            positions = [CGPointMake(0,0), CGPointMake(0, height - 100), CGPointMake(width - 100, 0), CGPointMake(width - 100, height - 100)],
        //add more colors later
            colors = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.blackColor(), UIColor.yellowColor(), UIColor.orangeColor()]
        var colorSet: [Int] = []
        
        //shapeset
        var rand: Int = 0
        for (index, name) in shapes.enumerate() {
            rand = Int(arc4random_uniform(6))
            while(some(equiv, array: colorSet, a: rand)) {
                rand = Int(arc4random_uniform(6))
            }
            colorSet.append(rand)
            let image = UIImage(named: name)
            let imageView = UIImageView(image: image)
            shapeSet.append((type: name, color: colors[rand], pos: positions[index], imgView: imageView))
        }
    }
    
    func setText() {
        let sText = UIImage(named: "shape.png"),
            shapeHeight = sText!.size.height,
            shapeWidth = sText!.size.width
        shapeText = (src: "shape.png", aspectRatio: shapeWidth/shapeHeight)
        
        let cText = UIImage(named: "color.png"),
            colorHeight = cText!.size.height,
            colorWidth = cText!.size.width
        colorText = (src: "color.png", aspectRatio: colorWidth/colorHeight)
    }
    
    func addTemplateImage(x: CGFloat, y: CGFloat, color: UIColor, image: UIImage) {
        let imageView = UIImageView(image: image)
        
        imageView.image? = (imageView.image?.imageWithRenderingMode(.AlwaysTemplate))!
        imageView.tintColor = color
        
        //all shapes are displayed as 100 by 100, change so that it is percentage of screen size
        imageView.frame = CGRect(x: x, y: y, width: 100, height: 100)
        view.addSubview(imageView)
    }
    
    func addImage(name: String, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) {
        let image = UIImage(named: name),
            imageView = UIImageView(image: image!)
        imageView.frame = CGRect(x: x, y: y, width: width, height: height)
        view.addSubview(imageView)
    }

    
    func render() {
        for shape in shapeSet {
            addTemplateImage(shape.pos.x, y: shape.pos.y, color: shape.color, image: shape.img)
        }
        addImage(currentText!.src, x: currentText!.pos.x, y: currentText!.pos.y, width: currentText!.size.x, height: currentText!.size.y)
        addTemplateImage(currentShape!.pos.x, y: currentShape!.pos.y, color: currentShape!.color, image: currentShape!.img)
    }
    
    
    func some(funct: (Int, Int) -> Bool, array: [Int], a: Int) -> Bool {
        for el in array {
            if (funct(el, a)) {
                return true
            }
        }
        return false
    }
    
    func equiv(a: Int, b: Int) -> Bool {
        return a == b
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
            currentShape!.pos = endPos
            if (currentText!.src == "shape.png") {
                for shape in shapeSet {
                    if (shape.type == currentShape!.type && CGRectIntersectsRect(currentShape!.img.frame, shape.img.frame)) {
                        print("correct")
                    }
                }
            } else {
                
            }
            view.subviews.forEach({ $0.removeFromSuperview() })
            render()
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //do something with startPos and endPos
    }
    
    
    
    //function adds each image in at its position

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
