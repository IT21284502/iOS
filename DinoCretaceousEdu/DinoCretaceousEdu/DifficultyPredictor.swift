import Foundation

// MARK: - ML Models
struct GameFeature {
    let score: Double
    let lives: Double
    let orbsCollected: Double
    let hazardHits: Double
    let elapsedTime: Double
    let baseDifficulty: Double
}

class SimpleLinearRegression {
    private var weights: [Double] = []
    private var bias: Double = 0.0
    private let learningRate: Double = 0.01
    private let epochs: Int = 100
    
    func train(features: [[Double]], targets: [Double]) {
        let featureCount = features[0].count
        weights = Array(repeating: 0.0, count: featureCount)
        bias = 0.0
        
        for _ in 0..<epochs {
            for (feature, target) in zip(features, targets) {
                let prediction = predict(feature: feature)
                let error = prediction - target
                
                // Update weights and bias
                for i in 0..<featureCount {
                    weights[i] -= learningRate * error * feature[i]
                }
                bias -= learningRate * error
            }
        }
    }
    
    func predict(feature: [Double]) -> Double {
        var result = bias
        for (weight, value) in zip(weights, feature) {
            result += weight * value
        }
        return result
    }
}

class SimpleNeuralNetwork {
    private var weights1: [[Double]] = []
    private var weights2: [Double] = []
    private var bias1: [Double] = []
    private var bias2: Double = 0.0
    private let hiddenSize: Int = 4
    private let learningRate: Double = 0.01
    
    init(inputSize: Int) {
        // Initialize weights with small random values
        weights1 = (0..<hiddenSize).map { _ in
            (0..<inputSize).map { _ in Double.random(in: -0.1...0.1) }
        }
        weights2 = (0..<hiddenSize).map { _ in Double.random(in: -0.1...0.1) }
        bias1 = Array(repeating: 0.0, count: hiddenSize)
        bias2 = 0.0
    }
    
    private func sigmoid(_ x: Double) -> Double {
        return 1.0 / (1.0 + exp(-x))
    }
    
    private func sigmoidDerivative(_ x: Double) -> Double {
        let s = sigmoid(x)
        return s * (1.0 - s)
    }
    
    func train(features: [[Double]], targets: [Double], epochs: Int = 50) {
        for _ in 0..<epochs {
            for (feature, target) in zip(features, targets) {
                // Forward pass
                var hidden = [Double]()
                for i in 0..<hiddenSize {
                    var sum = bias1[i]
                    for (w, f) in zip(weights1[i], feature) {
                        sum += w * f
                    }
                    hidden.append(sigmoid(sum))
                }
                
                var output = bias2
                for (w, h) in zip(weights2, hidden) {
                    output += w * h
                }
                
                // Backward pass
                let outputError = output - target
                
                // Update output layer
                for i in 0..<hiddenSize {
                    weights2[i] -= learningRate * outputError * hidden[i]
                }
                bias2 -= learningRate * outputError
                
                // Update hidden layer
                for i in 0..<hiddenSize {
                    let hiddenError = outputError * weights2[i] * sigmoidDerivative(hidden[i])
                    for j in 0..<feature.count {
                        weights1[i][j] -= learningRate * hiddenError * feature[j]
                    }
                    bias1[i] -= learningRate * hiddenError
                }
            }
        }
    }
    
    func predict(feature: [Double]) -> Double {
        var hidden = [Double]()
        for i in 0..<hiddenSize {
            var sum = bias1[i]
            for (w, f) in zip(weights1[i], feature) {
                sum += w * f
            }
            hidden.append(sigmoid(sum))
        }
        
        var output = bias2
        for (w, h) in zip(weights2, hidden) {
            output += w * h
        }
        return output
    }
}

final class DifficultyPredictor {
    
    // ML Models
    private let linearModel = SimpleLinearRegression()
    private var neuralNetwork: SimpleNeuralNetwork?
    private var isModelTrained = false
    
    init() {
        neuralNetwork = SimpleNeuralNetwork(inputSize: 6)
    }
    
    /// Train models with sample data
    func trainModels() {
        // Sample training data (in real app, this would come from actual gameplay)
        let trainingFeatures: [[Double]] = [
            [50, 3, 2, 1, 30, 1.0],   // Low performance
            [120, 3, 8, 0, 45, 1.5],  // Good performance
            [80, 2, 4, 3, 60, 2.0],   // Struggling
            [200, 3, 12, 1, 90, 2.5], // Excellent
            [30, 1, 1, 5, 25, 1.0],   // Very struggling
            [150, 3, 10, 0, 75, 2.0]  // Good
        ]
        
        let trainingTargets: [Double] = [1.2, 2.1, 1.5, 2.8, 1.0, 2.3]
        
        // Train both models
        linearModel.train(features: trainingFeatures, targets: trainingTargets)
        neuralNetwork?.train(features: trainingFeatures, targets: trainingTargets)
        
        isModelTrained = true
    }
    
    /// Convert game parameters to feature vector
    private func toFeatureVector(score: Int, lives: Int, orbsCollected: Int, 
                                hazardHits: Int, elapsedTime: TimeInterval, 
                                baseDifficulty: Double) -> [Double] {
        return [
            Double(score),
            Double(lives),
            Double(orbsCollected),
            Double(hazardHits),
            elapsedTime,
            baseDifficulty
        ]
    }
    
    /// Predict difficulty using ML models
    func predictWithML(score: Int,
                      lives: Int,
                      orbsCollected: Int,
                      hazardHits: Int,
                      elapsedTime: TimeInterval,
                      baseDifficulty: Double) -> Double {
        
        if !isModelTrained {
            trainModels()
        }
        
        let features = toFeatureVector(score: score, lives: lives, 
                                      orbsCollected: orbsCollected, 
                                      hazardHits: hazardHits, 
                                      elapsedTime: elapsedTime, 
                                      baseDifficulty: baseDifficulty)
        
        // Get predictions from both models
        let linearPrediction = linearModel.predict(feature: features)
        let neuralPrediction = neuralNetwork?.predict(feature: features) ?? baseDifficulty
        
        // Ensemble: average of both models
        let mlPrediction = (linearPrediction + neuralPrediction) / 2.0
        
        // Keep within bounds
        return max(1.0, min(3.0, mlPrediction))
    }
    
    /// Predict a difficulty value between 1 and 3 using rule-based logic
    func predictDifficulty(score: Int,
                          lives: Int,
                          orbsCollected: Int,
                          hazardHits: Int,
                          elapsedTime: TimeInterval,
                          baseDifficulty: Double) -> Double {
        
        var difficulty = baseDifficulty
        
        // Adjust based on performance
        if score > 100 && hazardHits == 0 && orbsCollected > 5 {
            difficulty += 0.5  // Player doing well
        }
        if hazardHits >= 3 && score < 80 {
            difficulty -= 0.5  // Player struggling
        }
        if elapsedTime > 60 && score > 150 {
            difficulty += 0.5  // Long session with good performance
        }
        if lives == 1 {
            difficulty -= 0.25  // Help player on last life
        }
        
        // Keep within bounds
        return max(1.0, min(3.0, difficulty))
    }
    
    /// Hybrid prediction combining rule-based and ML approaches
    func predictHybrid(score: Int,
                      lives: Int,
                      orbsCollected: Int,
                      hazardHits: Int,
                      elapsedTime: TimeInterval,
                      baseDifficulty: Double) -> Double {
        
        let ruleBased = predictDifficulty(score: score, lives: lives, 
                                         orbsCollected: orbsCollected, 
                                         hazardHits: hazardHits, 
                                         elapsedTime: elapsedTime, 
                                         baseDifficulty: baseDifficulty)
        
        let mlBased = predictWithML(score: score, lives: lives, 
                                   orbsCollected: orbsCollected, 
                                   hazardHits: hazardHits, 
                                   elapsedTime: elapsedTime, 
                                   baseDifficulty: baseDifficulty)
        
        // Weighted average: 60% rule-based, 40% ML
        let hybrid = (ruleBased * 0.6) + (mlBased * 0.4)
        
        return max(1.0, min(3.0, hybrid))
    }
}
