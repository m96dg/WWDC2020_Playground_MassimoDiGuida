/*
 
 Welcome to Massimo's Playground!
 I want to show you my journey to WWDC.
 I hope you can have fun with my story!
 
*/

import SpriteKit
import PlaygroundSupport
import UIKit


let skView = SKView(frame: .zero)

let presentationScene = PresentationScene(size: UIScreen.main.bounds.size)

skView.presentScene(presentationScene)
skView.preferredFramesPerSecond = 60

PlaygroundPage.current.liveView = skView
//PlaygroundPage.current.wantsFullScreenLiveView = true
