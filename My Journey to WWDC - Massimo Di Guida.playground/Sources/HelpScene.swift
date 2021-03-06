import SpriteKit

public class HelpScene: SKScene {
    
    
    var cartoon : SKSpriteNode!
    var soundClick = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false) 
    
    
    
    public override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "HelpScene.jpeg")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        cartoon = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Help Speech.png")), color: .clear, size: CGSize(width: size.width * 0.40, height: size.height * 0.40))
        cartoon.position = CGPoint(x: frame.midX * 1.58 , y: frame.midY * 0.9)
        addChild(cartoon)
        
    }
    
    
    func changeNextScene () {
        
        let introGameScene = IntroGameScene(size: UIScreen.main.bounds.size)
        view?.presentScene(introGameScene, transition: SKTransition.fade(withDuration: 0.5))
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchNodes = nodes(at: touchLocation)
        
        
        for node in touchNodes {
            
            if node == cartoon {
                
                changeNextScene()
                run(soundClick)
                
            }
        }
        
    }
    
}

