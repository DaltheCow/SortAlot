import UIKit

class Shapes {
    var height: CGFloat = 0, //414
        width: CGFloat = 0,  //736
    shapeSet: [(type: String, color: UIColor, pos: CGPoint, size: (width: CGFloat, height: CGFloat), imgView: UIImageView)] = [],
        currentShape: (type: String, color: UIColor, pos: CGPoint, size: (width: CGFloat, height: CGFloat), imgView: UIImageView)? = nil

    
    init(height: CGFloat, width: CGFloat) {
        self.height = height
        self.width = width
    }
    
    func setShapes() {
        let shapeSrc = ["circle.png", "square.png", "triangle.png", "diamond.png", "club.png", "spade.png", "cloud.png", "pentagon.png"],
        //orange and red too similar, get a darker green, maybe a purple
        colors = [UIColor.blue, UIColor.green, UIColor.red, UIColor.black, UIColor.yellow, UIColor.orange]

        var shapeSetInts: [Int] = [],
            colorSetInts: [Int] = []
        
        //choose 4 shapes
        var rand: Int = 0
        for _ in 1...4 {
            rand = Int(arc4random_uniform(8))
            while(some(equiv, array: shapeSetInts, a: rand)) {
                rand = Int(arc4random_uniform(8))
            }
            shapeSetInts.append(rand)
        }
        
        //choose 4 colors and set shapeSet
        for (i, el) in shapeSetInts.enumerated() {
            rand = Int(arc4random_uniform(6))
            while(some(equiv, array: colorSetInts, a: rand)) {
                rand = Int(arc4random_uniform(6))
            }
            colorSetInts.append(rand)
            let img = UIImage(named: shapeSrc[el]),
                imageView = UIImageView(image: img),
                AR = (img?.size.width)! / (img?.size.height)!
            var size = (width: CGFloat(0), height: CGFloat(0))
            //do AR for size
            if (AR > 1) {
                size.width = height * 3/10
                size.height = height * 3/10 / AR
            } else if (AR == 1) {
                size.width = height * 3/10
                size.height = size.width
            } else {
                size.width = height * 3/10 * AR
                size.height = height * 3/10
            }
            //positions are then set based on size
            
            imageView.image? = (imageView.image?.withRenderingMode(.alwaysTemplate))!
            imageView.tintColor = colors[rand]
            imageView.layer.shadowColor = UIColor.black.cgColor
            imageView.layer.shadowOpacity = 1
            imageView.layer.shadowOffset = CGSize.zero
            imageView.layer.shadowRadius = 2
            shapeSet.append((type: shapeSrc[el], color: colors[rand], pos: positions(i: i, size: size), size: size, imgView: imageView))
        }
    }
    
    func positions(i : Int, size: (width: CGFloat, height: CGFloat)) -> CGPoint {
        var pos = [CGPoint(x: 0,y: 0), CGPoint(x: width - size.width, y: 0), CGPoint(x: 0, y: height - size.height), CGPoint(x: width - size.width, y: height - size.height)]
        return pos[i]
    }
    
    func newShape() {
        let randShape = Int(arc4random_uniform(4))
        let image = UIImage(named: shapeSet[randShape].type)
        let imageView = UIImageView(image: image)
        imageView.image? = (imageView.image?.withRenderingMode(.alwaysTemplate))!
        imageView.tintColor = shapeSet[Int(arc4random_uniform(4))].color
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize.zero
        imageView.layer.shadowRadius = 2
        currentShape = (type: shapeSet[randShape].type,
                        color: imageView.tintColor,
                        pos: CGPoint(x: width/2 - 3/10 * height/2, y: height/2 - 3/10 * height/2),
                        size: shapeSet[randShape].size,
                        imgView: imageView)
    }
}
