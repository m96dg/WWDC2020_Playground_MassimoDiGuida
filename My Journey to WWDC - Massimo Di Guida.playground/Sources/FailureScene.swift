
import SpriteKit

public class FailureScene: SKScene {
    
    var retry : SKSpriteNode!
    var cell : SKSpriteNode!
    var virus : SKSpriteNode!
    var soundClick = SKAction.playSoundFileNamed("Click.mp3", waitForCompletion: false) 
    var soundFailure = SKAction.playSoundFileNamed("Game Over.mp3", waitForCompletion: false) 
    
    public override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "FailureScene.jpeg")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        retry = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Failure Speech.png")), color: .clear, size: CGSize(width: size.width * 0.40, height: size.height * 0.40))
        retry.position = CGPoint(x: frame.midX * 1.57 , y: frame.midY * 1.04)
        
        cell = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Fail Cell.png")), color: .clear, size: CGSize(width: size.width * 0.12, height: size.height * 0.19))
        cell.position = CGPoint(x: frame.midX * 0.20 , y: frame.midY * 2.0)
        addChild(cell)
        
        virus = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Fail Virus.png")), color: .clear, size: CGSize(width: size.width * 0.20, height: size.height * 0.22))
        virus.position = CGPoint(x: frame.midX * 1.2 , y: frame.midY * 2.0)
        addChild(virus)
        
        animation()
        
        run(soundFailure)
        
    }
    
    
    func animation () {
        
        let newCellPosition = CGPoint(x: frame.midX * 0.20 , y: frame.midY * 0.50)
        cell.run(SKAction.move(to: newCellPosition, duration: 2))
        let newVirusPosition = CGPoint(x: frame.midX * 1.2 , y: frame.midY * 0.50)
        virus.run(SKAction.move(to: newVirusPosition, duration: 2))
        
        
        perform(#selector(flag), with: nil,afterDelay: 2.5)
        
    }
    
    @objc 
    func flag () {
        
        addChild(retry)
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
            
            if node == retry {
                
                changeNextScene()
                run(soundClick)
                
            }
        }
        
    }
    
    
    
    
}

