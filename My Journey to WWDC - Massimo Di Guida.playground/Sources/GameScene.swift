import SpriteKit


public class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let numberOfCells = 1
    let numberOfVirus = 12
    var scoreVirus = 0
    var scoreCells = 0
    var timer : Int = 10
    var timerLabel: SKLabelNode!
    var gameTimer: Timer?
    let maxCellSpeed : UInt32 = 50
    let maxVirusSpeed : UInt32 = 80
    
    var syringe: SKSpriteNode!
    var cells = [SKSpriteNode]()
    var a_virus = [SKSpriteNode]()
    var gameOver = false
    var movingSyringe = false
    var offset : CGPoint!
    
    var soundHeal = SKAction.playSoundFileNamed("Heal.wav", waitForCompletion: false) 
    var soundInfect = SKAction.playSoundFileNamed("Virus Attack.wav", waitForCompletion: false) 
    
    func positionWithin (range: CGFloat, containerSize: CGFloat) -> CGFloat {
        
        let partA = CGFloat(arc4random_uniform(100)) / 100.0
        let partB = (containerSize * (1.0 - range) * 0.5)
        let partC = (containerSize * range + partB)
        return partA * partC
        
    }
    func distanceFrom (posA: CGPoint, posB: CGPoint) -> CGFloat {
        let aSquared = (posA.x - posB.x) * (posA.x - posB.x)
        let bSquared = (posA.y - posB.y) * (posA.y - posB.y)
        return sqrt(aSquared + bSquared)
    }
    
    public override func didMove(to view: SKView) {
        
        
        timerLabel = SKLabelNode(text: String(timer))
        addChild(timerLabel)
        
        //timer
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countdown), userInfo: nil, repeats: true)
        
        
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        physicsWorld.contactDelegate = self
        
        //background
        
        let background = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Playground.png")))
        background.zPosition = -10
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
        
        
        //syringe
        
        syringe = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Syringe.png")), color: .clear, size: CGSize(width: size.width * 0.07, height: size.height * 0.20))
        
        syringe.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(syringe)
        
        syringe.physicsBody = SKPhysicsBody(circleOfRadius: syringe.size.width / 3)
        syringe.physicsBody?.isDynamic = false
        syringe.physicsBody?.categoryBitMask = Bitmasks.syringe
        syringe.physicsBody?.contactTestBitMask = Bitmasks.virus
        
        //cells
        
        for _ in 1...numberOfCells {
            createCell()
        }
        
        for cell in cells {
            cell.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(maxCellSpeed)) - CGFloat(maxCellSpeed), dy: CGFloat(arc4random_uniform(maxCellSpeed)) - CGFloat(maxCellSpeed)))
        }
        
        
        for _ in 1...numberOfVirus {
            createVirus()
        }
        
        for virus in a_virus {
            virus.physicsBody?.applyImpulse(CGVector(dx: CGFloat(arc4random_uniform(maxVirusSpeed)) - CGFloat(maxVirusSpeed) , dy: CGFloat(arc4random_uniform(maxVirusSpeed)) - CGFloat(maxVirusSpeed)))
        }
        
        
        scoreVirus = numberOfVirus
        scoreCells = numberOfCells
        
    }
    
    //functions
    
    func createCell(){ 
        
        
        let cell = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Cell.png")), color: .clear, size: CGSize(width: size.width * 0.10, height: size.height * 0.12))
        
        cell.position = CGPoint(x: positionWithin(range: 0.8, containerSize: size.width), y: positionWithin(range: 0.8, containerSize: size.height))
        
        addChild(cell)
        cells.append(cell)
        
        cell.physicsBody = SKPhysicsBody(circleOfRadius: cell.size.width / 2)
        cell.physicsBody?.affectedByGravity = false 
        cell.physicsBody?.categoryBitMask = Bitmasks.cell
        cell.physicsBody?.contactTestBitMask = Bitmasks.virus
        
        cell.physicsBody?.friction = 0.0
        cell.physicsBody?.angularDamping = 0.0
        cell.physicsBody?.restitution = 1.1
        cell.physicsBody?.allowsRotation = false 
        
    }
    
    
    func createVirus () { 
        
        
        let virus = SKSpriteNode(texture: SKTexture(image:#imageLiteral(resourceName: "Virus.png")), color: .clear, size: CGSize(width: size.width * 0.10, height: size.height * 0.10))
        virus.position = CGPoint(x: positionWithin(range: 0.8, containerSize: size.width), y: positionWithin(range: 0.8, containerSize: size.height))
        
        addChild(virus)
        a_virus.append(virus)
        
        virus.physicsBody = SKPhysicsBody(circleOfRadius: virus.size.width / 2)
        virus.physicsBody?.affectedByGravity = false 
        virus.physicsBody?.categoryBitMask = Bitmasks.virus
        virus.physicsBody?.contactTestBitMask = Bitmasks.virus
        
        
        virus.physicsBody?.friction = 0.0
        virus.physicsBody?.angularDamping = 0.0
        virus.physicsBody?.restitution = 1.1
        virus.physicsBody?.allowsRotation = false 
        
        
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNodes = nodes(at: touchLocation)
        
        for node in touchedNodes {
            if let sprite = node as? SKSpriteNode {
                if sprite == syringe {
                    movingSyringe = true
                    offset = CGPoint(x: touchLocation.x - syringe.position.x, y: touchLocation.y - syringe.position.y)
                }
            }
        }
        
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !gameOver && movingSyringe else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        let newSyringePosition = CGPoint(x: touchLocation.x - offset.x, y: touchLocation.y - offset.y)    
        syringe.run(SKAction.move(to: newSyringePosition, duration: 0.01))
        
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingSyringe = false
    }
    
    
    public func didBegin(_ contact: SKPhysicsContact) {
        
        
        //virus-->cell
        if contact.bodyA.categoryBitMask == Bitmasks.cell && contact.bodyB.categoryBitMask == Bitmasks.virus {
            
            infect(cell: contact.bodyA.node as! SKSpriteNode)
            
        }
        else if contact.bodyB.categoryBitMask == Bitmasks.cell && contact.bodyA.categoryBitMask == Bitmasks.virus { 
            
            infect(cell: contact.bodyB.node as! SKSpriteNode)
            
        }
            //syringe-->virus
            
            
        else if contact.bodyA.categoryBitMask == Bitmasks.virus && contact.bodyB.categoryBitMask == Bitmasks.syringe {
            heal(virus: contact.bodyA.node as! SKSpriteNode)
            
        }
            
        else if contact.bodyB.categoryBitMask == Bitmasks.virus && contact.bodyA.categoryBitMask == Bitmasks.syringe {
            
            heal(virus: contact.bodyB.node as! SKSpriteNode)
            
        }
            
        else if timer == 0 && scoreVirus == 0 {
            victory()
        }
        
    }
    
    
    func infect (cell: SKSpriteNode) {
        
        cell.texture = SKTexture(image:#imageLiteral(resourceName: "Virus.png"))
        cell.size = CGSize(width: size.width * 0.10, height: size.height * 0.10)
        cell.physicsBody?.categoryBitMask = Bitmasks.virus
        run(soundInfect)
        
        
        scoreVirus = scoreVirus + 1
        scoreCells = scoreCells - 1
        
    }
    
    
    func heal (virus: SKSpriteNode) {
        virus.texture = SKTexture(image:#imageLiteral(resourceName: "Cell.png"))
        virus.size = CGSize(width: size.width * 0.10, height: size.height * 0.12)
        virus.physicsBody?.categoryBitMask = Bitmasks.cell
        run(soundHeal)
        
        scoreVirus = scoreVirus - 1
        scoreCells = scoreCells + 1
        
        if scoreCells == numberOfCells + numberOfVirus {
            victory()
        }
        
    }
    
    @objc func countdown() {
        if timer > 0 {
            
            timerLabel.fontSize = 50.0
            timerLabel.position = CGPoint(x: frame.midX * 1.75 , y: frame.midY * 1.8)
            timerLabel.zPosition = 3
            timerLabel.fontColor = .white
            timer -= 1
            timerLabel.text = String(timer)
            
        }else {
            
            changeFailureScene()
            
        }
        
        
    }
    
    func victory () {
        changeVictoryScene()
    }
    
    
    func changeVictoryScene () {
        let victoryScene = VictoryScene(size: UIScreen.main.bounds.size)
        view?.presentScene(victoryScene, transition: SKTransition.fade(withDuration: 0.5))
        
    }
    
    
    func changeFailureScene () {
        let failureScene = FailureScene(size: UIScreen.main.bounds.size)
        view?.presentScene(failureScene, transition: SKTransition.fade(withDuration: 0.5))
        
    }
}

