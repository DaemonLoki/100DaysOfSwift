import PlaygroundSupport
import UIKit

var str = "Hello, playground"

// Challenge 1:

extension UIView {
    
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

// Challenge 2:

extension Int {
    
    func times(_ function: () -> Void) {
        guard self > 0 else { return }
        
        for _ in 0 ..< self {
            function()
        }
    }
    
}

// Challenge 3:

extension Array where Element: Comparable {
    
    mutating func remove(item: Element) {
        if let firstIndex = self.firstIndex(of: item) {
            self.remove(at: firstIndex)
        }
    }
    
}

// Test Challenge 2:

5.times {
    print("Hey there")
}

let count = -5

count.times {
    print("Hey you")
}

// Test Challenge 3:

var sampleArray = [ 1, 2, 4, 4, 6, 8]
sampleArray.remove(item: 4)

// Test Challenge 1;

class PlaygroundsViewController: UIViewController {
    
    let animatedView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .orange
        return v
    }()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        view.addSubview(animatedView)
        
        NSLayoutConstraint.activate([
            animatedView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animatedView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            animatedView.heightAnchor.constraint(equalToConstant: 200),
            animatedView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.animatedView.bounceOut(duration: 2)
        }
    }
    
}

let master = PlaygroundsViewController()

PlaygroundPage.current.liveView = master
