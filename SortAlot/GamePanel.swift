//note gamePanel has its own rendering function
//convert gamePanel into its own view

import UIKit

class GamePanel {
    var height: CGFloat = 0,
    width: CGFloat = 0,
    panelHeight: CGFloat = 0,
    panelWidth: CGFloat = 0,
    x: CGFloat = 0,
    y: CGFloat = 0,
    image: UIImage?,
    borderIV: UIImageView?,
    backgroundIV: UIImageView?,
    
    colorText: (src: String, imgView: UIImageView)? = nil,
    shapeText: (src: String, imgView: UIImageView)? = nil,
    currentText: (src: String, imgView: UIImageView)? = nil,
    scoreLabel: UILabel?,
    clockLabel: UILabel?,
    view: UIView?
    
    init(height: CGFloat, width: CGFloat, view: UIView) {
        self.height = height
        self.width = width
        self.view = view
        panelSetup()
    }
    func panelSetup() {
        panelHeight = height/4.2
        panelWidth = width/3
        x = width/2 - panelWidth/2
        y = 0
        image = UIImage(named: "square.png")
        borderIV = UIImageView(image:image!)
        backgroundIV = UIImageView(image:image!)
        
        backgroundIV!.image? = (borderIV!.image?.withRenderingMode(.alwaysTemplate))!
        backgroundIV!.tintColor = UIColor.black
        backgroundIV!.frame=CGRect(x: x - panelWidth/15, y: y, width: panelWidth + panelWidth/7.5, height: panelHeight + panelWidth/15)
        
        borderIV!.image? = (borderIV!.image?.withRenderingMode(.alwaysTemplate))!
        borderIV!.tintColor = UIColor.white
        borderIV!.frame=CGRect(x: x, y: y, width: panelWidth, height: panelHeight)
        
        scoreLabel = UILabel(frame: CGRect(x: x, y: y, width: panelWidth / 1.6, height: panelHeight / 2.2))
        scoreLabel?.textColor = UIColor.black
        scoreLabel?.textAlignment = NSTextAlignment.center
        scoreLabel?.font = UIFont(name:"HelveticaNeue", size: panelHeight / 2.2)
        
        clockLabel = UILabel(frame: CGRect(x: x + panelWidth / 1.8 + panelWidth / 15, y: y, width: panelWidth / 2.75, height: panelHeight / 2.3))
        clockLabel?.textColor = UIColor.black
        clockLabel?.textAlignment = NSTextAlignment.center
        clockLabel?.font = UIFont(name:"HelveticaNeue", size: panelHeight / 2.2)
    }
    
    func addPanel(_ score: Int, time: Int) {
        view?.addSubview(backgroundIV!)
        view?.addSubview(borderIV!)
        addScore(score)
        addTime(time)
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
        //set position and size according to panel sizing
        let size = (width: aspectRatio * self.panelHeight * 1/2.6, height: self.panelHeight * 1/2.6)
        let pos = CGPoint(x: x + panelWidth / 2 - size.width / 2, y: y + panelHeight/1.75)
        let imgView = UIImageView(image: text)
        imgView.frame = CGRect(x: pos.x, y: pos.y, width: size.width, height: size.height)
        return imgView
    }
    
    func addScore(_ score: Int) {
        scoreLabel?.text = String(score)
        view?.addSubview(scoreLabel!)
    }
    
    func addTime(_ time: Int) {
        clockLabel?.text = String(time)
        view?.addSubview(clockLabel!)

    }
    
    
}
