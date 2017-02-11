import UIKit

class SideMenu {
    var width: CGFloat = 0,
    height: CGFloat = 0,
    menuWidth: CGFloat = 0,
    menuHeight: CGFloat = 0,
    x: CGFloat = 0,
    y: CGFloat = 0,
    
    menuIV: UIImageView?,
    pauseBtn: UIButton?,
    playBtn: UIButton?,
    restartBtn: UIButton?,
    
    paused = false,
    
    view: UIView?
    
    init(height: CGFloat, width: CGFloat, x: CGFloat, y: CGFloat, view: UIView) {
        self.height = height
        self.width = width
        self.menuHeight = height
        self.menuWidth = width
        self.view = view
        self.x = x
        self.y = y
        setUp()
    }
    
    func setUp() {
        //menu bar background
        let img = UIImage(named: "square.png")
        menuIV = UIImageView(image: img)
        menuIV?.image? = (menuIV?.image!.withRenderingMode(.alwaysTemplate))!
        menuIV?.tintColor = UIColor.white
        menuIV?.frame = CGRect(x: self.x, y: self.y, width: self.menuWidth, height: self.menuHeight)
        print(self.x, self.y, self.menuWidth, self.menuHeight)
        
        //menu bar items
        let img2 = UIImage(named: "menu-pause.png")
        var height = img2!.size.height,
            width = img2!.size.width,
            aspectRatio = width/height
        
        pauseBtn = UIButton(frame: CGRect(x: x, y: y, width: menuWidth, height:menuWidth / aspectRatio))
        pauseBtn?.setImage(img2 , for: UIControlState.normal)
        pauseBtn?.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        
        let img3 = UIImage(named: "menu-play.png")
        height = img3!.size.height
        width = img3!.size.width
        aspectRatio = width/height
        
        playBtn = UIButton(frame: CGRect(x: x, y: y, width: menuWidth, height:menuWidth / aspectRatio))
        playBtn?.setImage(img3 , for: UIControlState.normal)
        playBtn?.addTarget(self, action: #selector(playAction), for: .touchUpInside)
    }
    
    @objc func pauseAction(sender: UIButton!) {
        //game is paused
        paused = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (view?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view?.addSubview(blurEffectView)
    }
    
    @objc func playAction(sender: UIButton!) {
        //game is paused
        paused = false
    }
    
    func render() {
        //draw menubar
        view?.addSubview(menuIV!)
        
        //draw menu items
        
        if (!paused) {
            view?.addSubview(pauseBtn!)
        } else {
            view?.addSubview(playBtn!)
        }
        
    }
    
}
