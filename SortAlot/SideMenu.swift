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
    
    view: UIView?,
    playView: UIView?
    
    init(x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat, view: UIView, playView: UIView) {
        self.height = height
        self.width = width
        self.menuHeight = height
        self.menuWidth = width
        self.view = view
        self.playView = playView
        self.x = x
        self.y = y
        setUp()
    }
    
    func setUp() {
        //menu bar background
        let img = UIImage(named: "square.png")
        menuIV = UIImageView(image: img)
        menuIV?.image? = (menuIV?.image!.withRenderingMode(.alwaysTemplate))!
        menuIV?.tintColor = UIColor.black
        menuIV?.frame = CGRect(x: self.x, y: self.y, width: self.menuWidth, height: self.menuHeight)
        
        //menu bar items
        pauseBtn = UIButton(frame: CGRect(x: x, y: y, width: menuWidth, height:menuWidth))
        pauseBtn?.setImage(UIImage(named: "menu-pause.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        pauseBtn?.tintColor = UIColor.white
        pauseBtn?.addTarget(self, action: #selector(pauseAction), for: .touchUpInside)
        
        playBtn = UIButton(frame: CGRect(x: x, y: y, width: menuWidth, height:menuWidth))
        playBtn?.setImage(UIImage(named: "menu-play.png")?.withRenderingMode(.alwaysTemplate), for: UIControlState.normal)
        playBtn?.tintColor = UIColor.white
        playBtn?.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        
        render()
    }
    
    @objc func pauseAction(sender: UIButton!) {
        //game is paused
        paused = true
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = (playView?.bounds)!
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        playView?.addSubview(blurEffectView)
        render()
    }
    
    @objc func playAction(sender: UIButton!) {
        //game is paused
        paused = false
        render()
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
