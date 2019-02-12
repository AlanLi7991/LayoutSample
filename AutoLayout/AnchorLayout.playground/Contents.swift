//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    
    let redView = UIView()
    let yellowView = UIView()
    let blueView = UIView()
    let fixA = UIView()
    let fixB = UIView()
    let fixC = UIView()
    let stretchA = UIView()
    let stretchB = UIView()
    let stretchC = UIView()
    let imageView = UIImageView()
    
    let layoutUseContainer: Bool = true
    
    
    override func loadView() {
        self.view = UIView()
        self.view.backgroundColor = UIColor.white
        
        redView.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        yellowView.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        blueView.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        
        fixA.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        fixB.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        fixC.backgroundColor = UIColor.orange.withAlphaComponent(0.2)
        
        stretchA.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
        stretchB.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)
        stretchC.backgroundColor = UIColor.magenta.withAlphaComponent(0.3)

        layoutRYBView()
        layoutStretchViewInYellow()
        layoutPicSquareInBlue()
        if layoutUseContainer { layoutFixedViewWithContainerInRed()}
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if !layoutUseContainer {
            layoutFixedViewInRed()
        }
    }
    
    func layoutRYBView() {
        view.addSubview(redView)
        view.addSubview(yellowView)
        view.addSubview(blueView)
        
        var guide: UILayoutGuide = view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
           guide = view.safeAreaLayoutGuide
        }
        //Red
        //Fix height 100 from bottom
        redView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            redView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            redView.heightAnchor.constraint(equalToConstant: 100),
            redView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            redView.rightAnchor.constraint(equalTo: guide.rightAnchor)
            ])


        //Yellow
        //Fix 30% of superView height from red top
        yellowView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            yellowView.bottomAnchor.constraint(equalTo: redView.topAnchor),
            yellowView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            yellowView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            yellowView.rightAnchor.constraint(equalTo: guide.rightAnchor)
            ])
        //Blue
        //Fill all space left
        blueView.translatesAutoresizingMaskIntoConstraints = false
        blueView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        blueView.bottomAnchor.constraint(equalTo: yellowView.topAnchor).isActive = true
        blueView.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
        blueView.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true
    }
    
    func layoutFixedViewInRed() {
        guard view.bounds.width != 0 else { return }
        
        redView.addSubview(fixA)
        redView.addSubview(fixB)
        redView.addSubview(fixC)
        
        //ABC has fix size
        //Then divide the left space as gap
        let size: CGFloat = 80
        let gap = (view.bounds.size.width - size * 3)/4
        
        fixA.translatesAutoresizingMaskIntoConstraints = false
        fixA.widthAnchor.constraint(equalToConstant: size).isActive = true
        fixA.heightAnchor.constraint(equalToConstant: size).isActive = true
        fixA.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
        fixA.leftAnchor.constraint(equalTo: redView.leftAnchor, constant: gap).isActive = true

        fixB.translatesAutoresizingMaskIntoConstraints = false
        fixB.widthAnchor.constraint(equalToConstant: size).isActive = true
        fixB.heightAnchor.constraint(equalToConstant: size).isActive = true
        fixB.centerXAnchor.constraint(equalTo: redView.centerXAnchor).isActive = true
        fixB.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
        
        fixC.translatesAutoresizingMaskIntoConstraints = false
        fixC.widthAnchor.constraint(equalToConstant: size).isActive = true
        fixC.heightAnchor.constraint(equalToConstant: size).isActive = true
        fixC.centerYAnchor.constraint(equalTo: redView.centerYAnchor).isActive = true
        fixC.rightAnchor.constraint(equalTo: redView.rightAnchor, constant: -gap).isActive = true
    }
    
    func layoutFixedViewWithContainerInRed()  {
        //Create Container
        let containerA = addFixedViewToContainer(view: fixA)
        let containerB = addFixedViewToContainer(view: fixB)
        let containerC = addFixedViewToContainer(view: fixC)
        redView.addSubview(containerA)
        redView.addSubview(containerB)
        redView.addSubview(containerC)
        
        //ABC has fix size
        //Then divide the left space as gap
        containerA.translatesAutoresizingMaskIntoConstraints = false
        containerA.leftAnchor.constraint(equalTo: redView.leftAnchor).isActive = true
        containerA.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
        containerA.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true
        containerA.widthAnchor.constraint(equalTo: redView.widthAnchor, multiplier: 0.333).isActive = true
        
        containerB.translatesAutoresizingMaskIntoConstraints = false
        containerB.centerXAnchor.constraint(equalTo: redView.centerXAnchor).isActive = true
        containerB.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
        containerB.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true
        containerB.widthAnchor.constraint(equalTo: redView.widthAnchor, multiplier: 0.333).isActive = true
        
        containerC.translatesAutoresizingMaskIntoConstraints = false
        containerC.rightAnchor.constraint(equalTo: redView.rightAnchor).isActive = true
        containerC.topAnchor.constraint(equalTo: redView.topAnchor).isActive = true
        containerC.heightAnchor.constraint(equalTo: redView.heightAnchor).isActive = true
        containerC.widthAnchor.constraint(equalTo: redView.widthAnchor, multiplier: 0.333).isActive = true

    }
    
    func addFixedViewToContainer(view: UIView) -> UIView {
        let size: CGFloat = 80

        let container = UIView()
        container.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: size).isActive = true
        view.heightAnchor.constraint(equalToConstant: size).isActive = true
        view.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        return container;
    }
    
    func layoutStretchViewInYellow() {
        
        //ABC size can stretch
        //gap is fix
        let gap: CGFloat = 10
        
        yellowView.addSubview(stretchA)
        yellowView.addSubview(stretchB)
        yellowView.addSubview(stretchC)

        stretchA.translatesAutoresizingMaskIntoConstraints = false
        stretchB.translatesAutoresizingMaskIntoConstraints = false
        stretchC.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stretchA.leftAnchor.constraint(equalTo: yellowView.leftAnchor, constant: gap),
            stretchA.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: gap),
            stretchA.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor, constant: -gap),
            stretchA.widthAnchor.constraint(equalTo: yellowView.widthAnchor, multiplier: 0.333, constant: -gap*1.5),
            
            stretchB.centerXAnchor.constraint(equalTo: yellowView.centerXAnchor),
            stretchB.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: gap),
            stretchB.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor, constant: -gap),
            stretchB.widthAnchor.constraint(equalTo: yellowView.widthAnchor, multiplier: 0.333, constant: -gap),

            stretchC.rightAnchor.constraint(equalTo: yellowView.rightAnchor, constant: -gap),
            stretchC.topAnchor.constraint(equalTo: yellowView.topAnchor, constant: gap),
            stretchC.bottomAnchor.constraint(equalTo: yellowView.bottomAnchor, constant: -gap),
            stretchC.widthAnchor.constraint(equalTo: yellowView.widthAnchor, multiplier: 0.333, constant: -gap*1.5),
            
            ])
    }
    
    func layoutPicSquareInBlue() {
        imageView.image = UIImage(named: "ll")
        blueView.addSubview(imageView)
        //Picture is a square size
        //Cneter in blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: blueView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: blueView.widthAnchor, multiplier: 0.5),
            imageView.centerXAnchor.constraint(equalTo: blueView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: blueView.centerYAnchor),
            ])
    }
    
    
    
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
