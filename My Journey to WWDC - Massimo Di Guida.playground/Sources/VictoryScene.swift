
import SpriteKit

public class VictoryScene: SKScene {
    
    var cartoon : SKSpriteNode!
    var victoryNode : SKSpriteNode!
    var soundVictory = SKAction.playSoundFileNamed("Victory.wav", waitForCompletion: false) 
    
    public override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "VictoryScene.jpeg")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        
        cartoon = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Victory Speech.png")), color: .clear, size: CGSize(width: size.width * 0.40, height: size.height * 0.40))
        cartoon.position = CGPoint(x: frame.midX * 0.43 , y: frame.midY * 0.83)
        
        victoryNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Airplane.png")), color: .clear, size: CGSize(width: size.width * 0.50, height: size.height * 0.25))
        victoryNode.position = CGPoint(x: frame.midX * -0.6 , y: frame.midY * 1.75)
        addChild(victoryNode)
        
        checkVictory()
        
        run(soundVictory)
        
    }
    
    func checkVictory () {
        
        let newPosition = CGPoint(x: frame.midX * 2.9 , y: frame.midY * 1.75)
        victoryNode.run(SKAction.move(to: newPosition, duration: 4))
        
        perform(#selector(flag), with: nil,afterDelay: 4.0)
        
    }
    
    @objc 
    func flag () {
        
        victoryNode.removeFromParent()
        addChild(cartoon)
    }
    
    
}
