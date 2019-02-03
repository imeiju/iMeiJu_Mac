
import Cocoa
import QuartzCore

class SpinningProgressIndicatorLayer: CALayer {
    // Properties and Accessors
    private(set) var isRunning = false
    private var _isDeterminate = false
    var isDeterminate: Bool {
        get {
            return _isDeterminate
        }
        set(determinate) {
            _isDeterminate = determinate
            setupType()
            setNeedsDisplay()
        }
    }
    
    var maxValue: Double = 0.0
    private var _doubleValue: Double = 0.0
    var doubleValue: Double {
        get {
            return _doubleValue
        }
        set(doubleValue) {
            _doubleValue = doubleValue
            setNeedsDisplay()
        }
    }
    
    var color: NSColor? {
        get {
            // Need to convert from CGColor to NSColor
            if let aColor = foreColor {
                return NSColor(cgColor: aColor)
            }
            return nil
        }
        set(newColor) {
            // Need to convert from NSColor to CGColor
            foreColor = newColor?.cgColor
            
            // Update do all of the fins to this new color, at once, immediately
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            for fin in finLayers {
                fin.backgroundColor = newColor?.cgColor
            }
            CATransaction.commit()
            
            setNeedsDisplay()
        }
    }
    
    // "copy" because we don't retain it -- we create a CGColor from it
    private var finBoundsForCurrentBounds: CGRect {
        let size: CGSize = bounds.size
        let minSide: CGFloat = size.width > size.height ? size.height : size.width
        let width: CGFloat = minSide * 0.095
        let height: CGFloat = minSide * 0.30
        return CGRect(x: 0, y: 0, width: width, height: height)
    }
    
    private var finAnchorPointForCurrentBounds: CGPoint {
        let size: CGSize = bounds.size
        let minSide: CGFloat = size.width > size.height ? size.height : size.width
        let height: CGFloat = minSide * 0.30
        return CGPoint(x: 0.5, y: -0.9 * (minSide - height) / minSide)
    }
    
    var animationTimer: Timer?
    var fposition: Int = 0
    var foreColor: CGColor?
    var fadeDownOpacity: CGFloat = 0.0
    var numFins: Int = 0
    var finLayers: [CALayer] = []
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func toggleProgressAnimation() {
        if isRunning {
            stopProgressAnimation()
        } else {
            startProgressAnimation()
        }
    }
    
    func startProgressAnimation() {
        isHidden = false
        isRunning = true
        fposition = numFins - 1
        setNeedsDisplay()
        setupAnimTimer()
    }
    
    func stopProgressAnimation() {
        isRunning = false
        disposeAnimTimer()
        setNeedsDisplay()
    }
    
    // Animation
    @objc private func advancePosition() {
        fposition += 1
        if fposition >= numFins {
            fposition = 0
        }
        let fin = finLayers[fposition]
        // Set the next fin to full opacity, but do it immediately, without any animation
        CATransaction.begin()
        CATransaction.setValue(true, forKey: kCATransactionDisableActions)
        fin.opacity = 1.0
        CATransaction.commit()
        // Tell that fin to animate its opacity to transparent.
        fin.opacity = Float(fadeDownOpacity)
        setNeedsDisplay()
    }
    
    // Helper Methods
    private func setupType() {
        if isDeterminate {
            setupDeterminate()
        } else {
            setupIndeterminate()
        }
    }
    
    private func setupIndeterminate() {
        createFinLayers()
        if isRunning {
            setupAnimTimer()
        }
    }
    
    private func setupDeterminate() {
        if isRunning {
            disposeAnimTimer()
        }
        removeFinLayers()
        isHidden = false
    }
    
    private func removeFinLayers() {
        for finLayer in finLayers {
            finLayer.removeFromSuperlayer()
        }
    }
    
    private func createFinLayers() {
        removeFinLayers()
        // Create new fin layers
        let finBounds: CGRect = finBoundsForCurrentBounds
        let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
        let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let finCornerRadius: CGFloat = finBounds.size.width / 2
        for i in 0..<numFins {
            let newFin = CALayer()
            newFin.bounds = finBounds
            newFin.anchorPoint = finAnchorPoint
            newFin.position = finPosition
            newFin.transform = CATransform3DMakeRotation(CGFloat(i) * (-6.282185 / CGFloat(numFins)), 0.0, 0.0, 1.0)
            newFin.cornerRadius = finCornerRadius
            newFin.backgroundColor = foreColor
            // Set the fin's initial opacity
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            newFin.opacity = Float(fadeDownOpacity)
            CATransaction.commit()
            // set the fin's fade-out time (for when it's animating)
            let anim = CABasicAnimation()
            anim.duration = 0.7
            let actions = ["opacity": anim]
            newFin.actions = actions
            addSublayer(newFin)
            finLayers.append(newFin)
        }
    }
    
    private func setupAnimTimer() {
        // Just to be safe kill any existing timer.
        disposeAnimTimer()
        // Why animate if not visible?  viewDidMoveToWindow will re-call this method when needed.
        animationTimer = Timer(timeInterval: TimeInterval(0.05), target: self, selector: #selector(SpinningProgressIndicatorLayer.advancePosition), userInfo: nil, repeats: true)
        animationTimer?.fireDate = Date()
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .common)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .default)
        }
        if let aTimer = animationTimer {
            RunLoop.current.add(aTimer, forMode: .eventTracking)
        }
    }
    
    private func disposeAnimTimer() {
        animationTimer?.invalidate()
        animationTimer = nil
    }
    
    init(size: CGFloat) {
        super.init()
        
        fposition = 0
        numFins = 12
        fadeDownOpacity = 0.0
        isRunning = false
        color = .black
        bounds = CGRect(x: -(size / 2), y: -(size / 2), width: size, height: size)
        isDeterminate = false
        doubleValue = 0
        maxValue = 100
        
    }
    
    deinit {
        color = nil
        stopProgressAnimation()
        removeFinLayers()
    }
    
    override var bounds: CGRect {
        get {
            return super.bounds
        }
        set(newBounds) {
            super.bounds = newBounds
            
            // Resize the fins
            let finBounds: CGRect = finBoundsForCurrentBounds
            let finAnchorPoint: CGPoint = finAnchorPointForCurrentBounds
            let finPosition = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
            let finCornerRadius: CGFloat = finBounds.size.width / 2
            
            // do the resizing all at once, immediately
            CATransaction.begin()
            CATransaction.setValue(true, forKey: kCATransactionDisableActions)
            for fin in finLayers {
                fin.bounds = finBounds
                fin.anchorPoint = finAnchorPoint
                fin.position = finPosition
                fin.cornerRadius = finCornerRadius
            }
            CATransaction.commit()
        }
    }
    
    // MARK: - Determinate indicator drawing
    
    override func draw(in ctx: CGContext) {
        ctx.clear(bounds)
        if !isDeterminate {
            super.draw(in: ctx)
            return
        }
        let maxSize: CGFloat = (bounds.size.width >= bounds.size.height) ? bounds.size.height : bounds.size.width
        let lineWidth: CGFloat = 1 + (0.01 * maxSize)
        let circleCenter = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let circleRadius: CGFloat = (maxSize - lineWidth) / 2.1
        ctx.setFillColor(foreColor!)
        if let aColor = foreColor {
            ctx.setStrokeColor(aColor)
        }
        ctx.setLineWidth(lineWidth)
        ctx.beginPath()
        ctx.move(to: CGPoint(x: circleCenter.x + circleRadius, y: circleCenter.y))
        ctx.addEllipse(in: CGRect(x: circleCenter.x - circleRadius, y: circleCenter.y - circleRadius, width: 2 * circleRadius, height: 2 * circleRadius))
        ctx.closePath()
        ctx.strokePath()
        if doubleValue > 0 {
            let pieRadius: CGFloat = circleRadius - 2 * lineWidth
            ctx.beginPath()
            ctx.move(to: CGPoint(x: circleCenter.x, y: circleCenter.y))
            ctx.addLine(to: CGPoint(x: circleCenter.x, y: circleCenter.y + pieRadius))
            ctx.addArc(center: CGPoint(x: circleCenter.x, y: circleCenter.y), radius: pieRadius, startAngle: .pi, endAngle: CGFloat(.pi / 2 - (2 * .pi * (doubleValue / maxValue))), clockwise: true)
            ctx.closePath()
            ctx.fillPath()
        }
    }
    
}
