import SpriteKit
import UIKit

public class PresentationScene: SKScene {
    
    
    var cartoon : SKSpriteNode!
    var nextStep : SKSpriteNode!
    var soundClick = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false) 
    
    
    
    
    public override func didMove(to view: SKView) {
        
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "PresentationScene.jpeg")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        
        nextStep = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Next.png")), color: .clear, size: CGSize(width: size.width * 0.10, height: size.height * 0.20))
        nextStep.position = CGPoint(x: frame.midX * 1.9 , y: frame.midY * 0.2)
        addChild(nextStep)
        
        
    }
    
    
    func changeNextScene () {
        
        let dreamScene = DreamScene(size: UIScreen.main.bounds.size)
        view?.presentScene(dreamScene, transition: SKTransition.fade(withDuration: 0.5))
        
    }
    
    func addCartoon() {
        
        cartoon = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Presentation Speech.png")), color: .clear, size: CGSize(width: size.width * 0.40, height: size.height * 0.40))
        cartoon.position = CGPoint(x: frame.midX * 1.6 , y: frame.midY * 0.9)
        addChild(cartoon)
        
    }
    
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchNodes = nodes(at: touchLocation)
        
        
        for node in touchNodes {
            
            if node == nextStep {
                
                addCartoon()
                nextStep.removeFromParent()
                run(soundClick)
                
            }
            else if node == cartoon {
                
                changeNextScene()
                run(soundClick)
                
            }
        }
        
    }
    
}





