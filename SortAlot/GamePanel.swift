
import UIKit

class GamePanel {
    var height: CGFloat = 0, //414
    width: CGFloat = 0,
    pos: CGPoint = CGPoint(x: 0,y: 0),
    panelHeight: CGFloat = 0,
    panelWidth: CGFloat = 0,
    x: CGFloat?,
    y: CGFloat?,
    image: UIImage?,
    imageView: UIImageView?,
    imageView2: UIImageView?,
    
    colorText: (src: String, imgView: UIImageView)? = nil,
    shapeText: (src: String, imgView: UIImageView)? = nil,
    currentText: (src: String, imgView: UIImageView)? = nil
    
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
        setText()
    }
    //use panel x,y and height,width to make a view for everything to go inside, when things are drawn they are drawn at panel x, y plus their own x, y within the panel
    func setPanelPosition(_ view: UIView) {
        panelHeight = height/4
        panelWidth = width/3
        x = width/2 - panelWidth/2
        y = 0
        image = UIImage(named: "square.png")
        imageView = UIImageView(image:image!)
        imageView2 = UIImageView(image:image!)
        
        imageView2!.image? = (imageView!.image?.withRenderingMode(.alwaysTemplate))!
        imageView2!.tintColor = UIColor.black
        imageView2!.frame=CGRect(x: x! - panelWidth/15, y: y!, width: panelWidth + panelWidth/7.5, height: panelHeight + panelWidth/15)
        
        imageView!.image? = (imageView!.image?.withRenderingMode(.alwaysTemplate))!
        imageView!.tintColor = UIColor.white
        imageView!.frame=CGRect(x: x!, y: 0, width: panelWidth, height: panelHeight)
    }
    
    func addPanel(_ view: UIView) {
        view.addSubview(imageView2!)
        view.addSubview(imageView!)
        //add text, score, game clock
        //text change
    }
    
    func setText() {
        shapeText = (src: "shape.png", imgView: makeTextImgView("shape.png"))
        colorText = (src: "color.png", imgView: makeTextImgView("color.png"))
        if (Int(arc4random_uniform(2)) == 1) {
            currentText = colorText
        } else {
            currentText = shapeText
        }
    }
    
    func makeTextImgView(_ src: String) -> UIImageView {
        let text = UIImage(named: src),
            height = text!.size.height,
            width = text!.size.width
        let aspectRatio = width/height
        let size = (width: aspectRatio * self.height * 1/10, height: self.height * 1/10)
        let pos = CGPoint(x: self.width / 2 - size.width / 2, y: 45)
        let imgView = UIImageView(image: text)
        imgView.frame = CGRect(x: pos.x, y: pos.y, width: size.width, height: size.height)
        return imgView
    }
    
    
}
