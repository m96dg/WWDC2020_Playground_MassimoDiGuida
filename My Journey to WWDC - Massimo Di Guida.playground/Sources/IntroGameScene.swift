import SpriteKit

public class IntroGameScene: SKScene {
    
    var start : SKSpriteNode!
    var soundClick = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false) 
    
    public override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Game Rules.png")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        start = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Next.png")), color: .clear, size: CGSize(width: size.width * 0.10, height: size.height * 0.20))
        start.position = CGPoint(x: frame.midX * 1.8 , y: frame.midY * 0.25)
        addChild(start)
        
    }
    
    func changeNextScene(){
        let gameScene = GameScene(size: UIScreen.main.bounds.size)
        view?.presentScene(gameScene, transition: SKTransition.fade(withDuration: 0.5))
    }
    
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchNodes = nodes(at: touchLocation)
        
        
        for node in touchNodes {
            
            if node == start {
                
                changeNextScene()
                run(soundClick)
                
            }
        }
        
    }
    
    
}

