//
//  AsteroidBehavior.swift
//  Asteroids
//
//  Created by Oleksii Huralnyk on 6/8/17.
//  Copyright © 2017 Oleksii Huralnyk. All rights reserved.
//

import UIKit

class AsteroidBehavior: UIDynamicBehavior, UICollisionBehaviorDelegate {
    
    private var asteroids: [AsteroidView] = []
    private var collisionHandlers: [String: (Void) -> Void] = [:]
    var speedLimit: CGFloat = 300.0
    
    private lazy var collider: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.collisionMode = .everything
        behavior.collisionDelegate = self
        return behavior
    }()
    
    private lazy var physics: UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.elasticity = 1
        behavior.allowsRotation = true
        behavior.friction = 0
        behavior.resistance = 0
        return behavior
    }()
    
    lazy var acceleration: UIGravityBehavior = {
        let behavior = UIGravityBehavior()
        behavior.magnitude = 0
        return behavior
    }()
    
    override init() {
        super.init()
        addChildBehavior(collider)
        addChildBehavior(physics)
        addChildBehavior(acceleration)
        physics.action = { [weak self] in
            for asteroid in self?.asteroids ?? [] {
                let velocity = self!.physics.linearVelocity(for: asteroid)
                let excessHorizontalVelocity = min(self!.speedLimit - velocity.x, 0)
                let excessVerticalVelocity = min(self!.speedLimit - velocity.y, 0)
                self!.physics.addLinearVelocity(
                    CGPoint(x: excessHorizontalVelocity, y: excessVerticalVelocity),
                    for: asteroid
                )
            }
        }
    }
    
    // inherited from UIDynamicBehavior
    // let's us know when our UIDynamicAnimator changes
    // we need to know so we can stop/start our wayward asteroid recapture
    override func willMove(to dynamicAnimator: UIDynamicAnimator?) {
        super.willMove(to: dynamicAnimator)
        if dynamicAnimator == nil {
            stopRecapturingWaywardAsteroids()
        } else if !asteroids.isEmpty {
            startRecapturingWaywardAsteroids()
        }
    }
    
    func addAsteroid(_ asteroid: AsteroidView) {
        asteroids.append(asteroid)
        collider.addItem(asteroid)
        physics.addItem(asteroid)
        acceleration.addItem(asteroid)
    }
    
    func removeAsteroid(_ asteroid: AsteroidView) {
        if let index = asteroids.index(of: asteroid) {
            asteroids.remove(at: index)
            collider.removeItem(asteroid)
            physics.removeItem(asteroid)
            acceleration.removeItem(asteroid)
        }
        if asteroids.isEmpty {
            stopRecapturingWaywardAsteroids()
        }
    }
    
    func pushAllAsteroids(by magnitude: Range<CGFloat> = 0 ..< 0.5) {
        for asteroid in asteroids {
            let pusher = UIPushBehavior(items: [asteroid], mode: .continuous)
            pusher.magnitude = .random(in: magnitude)
            pusher.angle = .random(in: 0 ..< CGFloat.pi * 2)
            addChildBehavior(pusher)
        }
    }
    
    func setBoundary(_ path: UIBezierPath?, named name: String, handler: ((Void) -> Void)? = nil) {
        collider.removeBoundary(withIdentifier: name as NSString)
        collisionHandlers[name] = nil
        if let path = path {
            collider.addBoundary(withIdentifier: name as NSString, for: path)
            collisionHandlers[name] = handler
        }
    }
    
    func collisionBehavior(
        _ behavior: UICollisionBehavior,
        beganContactFor item: UIDynamicItem,
        withBoundaryIdentifier identifier: NSCopying?,
        at p: CGPoint) {
        
        if let name = identifier as? String, let handler = collisionHandlers[name] {
            handler()
        }
    }
    
    // MARK: Recapturing Wayward Asteroids
    
    // every 0.5s
    // we look around for asteroids that are
    // outside an asteroid's superview
    // we wrap it around to the other side
    // we take care to notify the animator that we've moved the item 
    // using updateItem(usingCurrentState:)
    
    var recaptureCount = 0
    private weak var recaptureTimer: Timer?
    
    private func startRecapturingWaywardAsteroids() {
        if recaptureTimer == nil {
                recaptureTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
                    for asteroid in self?.asteroids ?? [] {
                        if let asteroidFieldBounds = asteroid.superview?.bounds, !asteroidFieldBounds.contains(asteroid.center) {
                            asteroid.center.x = asteroid.center.x.truncatingRemainder(dividingBy: asteroidFieldBounds.width)
                            if asteroid.center.x < 0 { asteroid.center.x += asteroidFieldBounds.width }
                            asteroid.center.y = asteroid.center.y.truncatingRemainder(dividingBy: asteroidFieldBounds.height)
                            if asteroid.center.y < 0 { asteroid.center.y += asteroidFieldBounds.height }
                            self?.dynamicAnimator?.updateItem(usingCurrentState: asteroid)
                            self?.recaptureCount += 1
                        }
                    }
            }
        }
    }
    
    private func stopRecapturingWaywardAsteroids() {
        recaptureTimer?.invalidate()
    }

}
