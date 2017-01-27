
import UIKit

class GamePanel {
    var height: CGFloat = 0, //414
    width: CGFloat = 0,
    pos: CGPoint = CGPointMake(0,0),
    panelHeight: CGFloat = 0,
    panelWidth: CGFloat = 0,
    x: CGFloat?,
    y: CGFloat?,
    image: UIImage?,
    imageView: UIImageView?,
    imageView2: UIImageView?,
    
    colorText: (src: String, aspectRatio: CGFloat)? = nil,
    shapeText: (src: String, aspectRatio: CGFloat)? = nil,
    currentText: (src: String, aspectRatio: CGFloat, size: CGPoint, pos: CGPoint)? = nil
    
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
    }
    //use panel x,y and height,width to make a view for everything to go inside, when things are drawn they are drawn at panel x, y plus their own x, y within the panel
    func setPanelPosition(view: UIView) {
        panelHeight = height/4
        panelWidth = width/3
        x = width/2 - panelWidth/2
        y = 0
        image = UIImage(named: "square.png")
        imageView = UIImageView(image:image!)
        imageView2 = UIImageView(image:image!)
        
        imageView2!.image? = (imageView!.image?.imageWithRenderingMode(.AlwaysTemplate))!
        imageView2!.tintColor = UIColor.blackColor()
        imageView2!.frame=CGRect(x: x! - panelWidth/15, y: y!, width: panelWidth + panelWidth/7.5, height: panelHeight + panelWidth/15)
        
        imageView!.image? = (imageView!.image?.imageWithRenderingMode(.AlwaysTemplate))!
        imageView!.tintColor = UIColor.whiteColor()
        imageView!.frame=CGRect(x: x!, y: 0, width: panelWidth, height: panelHeight)
    }
    
    func addPanel(view: UIView) {
        view.addSubview(imageView2!)
        view.addSubview(imageView!)
        //add text, score, game clock
        //text change
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
        
        if (Int(arc4random_uniform(2)) == 1) {
            currentText = (src: colorText!.src, aspectRatio: colorText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
        } else {
            currentText = (src: shapeText!.src, aspectRatio: shapeText!.aspectRatio, size: CGPointMake(0,0), pos: CGPointMake(0,0))
        }
        currentText!.size = CGPointMake(currentText!.aspectRatio * height * 1/10, height * 1/10)
        currentText!.pos = CGPointMake(width/2 - currentText!.size.x/2, 45)
    }
    
    
}