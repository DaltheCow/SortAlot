
import UIKit

class Shapes {
    var height: CGFloat = 0, //414
        width: CGFloat = 0,  //736
        shapeSet: [(type: String, color: UIColor, pos: CGPoint, imgView: UIImageView)] = [],
        currentShape: (type: String, color: UIColor, pos: CGPoint, imgView: UIImageView)? = nil

    
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
    }
    
    func setShapes() {
        let shapes = ["circle.png", "square.png", "triangle.png", "diamond.png"],
        //the 4 corners of the screen
        positions = [CGPointMake(0,0), CGPointMake(0, height - 3/10 * height), CGPointMake(width - 3/10 * height, 0), CGPointMake(width - 3/10 * height, height - 3/10 * height)],
        //orange and red too similar, get a darker green, maybe a purple
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
            let img = UIImage(named: name)
            let imageView = UIImageView(image: img)
            imageView.image? = (imageView.image?.imageWithRenderingMode(.AlwaysTemplate))!
            imageView.tintColor = colors[rand]
            shapeSet.append((type: name, color: colors[rand], pos: positions[index], imgView: imageView))
        }
    }
    
    func newShape() {
        let randShape = Int(arc4random_uniform(4))
        let image = UIImage(named: shapeSet[randShape].type)
        let imageView = UIImageView(image: image)
        imageView.image? = (imageView.image?.imageWithRenderingMode(.AlwaysTemplate))!
        imageView.tintColor = shapeSet[Int(arc4random_uniform(4))].color
        currentShape = (type: shapeSet[randShape].type,
                        color: imageView.tintColor,
                        pos: CGPointMake(width/2 - 3/10 * height/2, height/2 - 3/10 * height/2),
                        imgView: imageView)
    }
}