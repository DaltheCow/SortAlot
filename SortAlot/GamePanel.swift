
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
    imageView2: UIImageView?
    
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
        
        imageView!.image? = (imageView!.image?.imageWithRenderingMode(.AlwaysTemplate))!
        imageView!.tintColor = UIColor.whiteColor()
    }
    
    func addPanel(view: UIView) {
        
        imageView2!.frame=CGRect(x: x! - panelWidth/15, y: y!, width: panelWidth + panelWidth/7.5, height: panelHeight + panelWidth/15)
        view.addSubview(imageView2!)
        
        
        imageView!.frame=CGRect(x: x!, y: 0, width: panelWidth, height: panelHeight)
        view.addSubview(imageView!)
    }
    
    
}