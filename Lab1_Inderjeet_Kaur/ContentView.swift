import SwiftUI

struct ContentView: View {
    @State private var currentNumber = Int.random(in: 1...100)
    @State private var isCorrect: Bool? = nil
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var showAlert = false
    
    @State private var timer: Timer? = nil
    @State private var gameActive = true
    
    var body: some View {
        VStack(spacing: 40) {
            Text("\(currentNumber)")
                .font(.system(size: 80, weight: .bold)) // Larger and bold text
                .padding()
            
            VStack(spacing: 30) { // Increased spacing between buttons
                Button(action: {
                    checkAnswer(isPrime: true)
                }) {
                    Text("Prime")
                        .font(.system(size: 28)) // Increased font size (regular weight)
                        .padding()
                        .frame(width: 200, height: 70) // Increased button size
                        .background(Color.blue.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    checkAnswer(isPrime: false)
                }) {
                    Text("Not Prime")
                        .font(.system(size: 28)) // Increased font size (regular weight)
                        .padding()
                        .frame(width: 250, height: 70) // Increased button size
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            
            ZStack {
                if let isCorrect = isCorrect {
                    Image(systemName: isCorrect ? "checkmark.circle" : "xmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundColor(isCorrect ? .green : .red)
                        .padding()
                }
            }
            .frame(height: 50) // Prevents shifting of other text
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Game Stats").font(.largeTitle),
                  message: Text("Correct: \(correctCount)\nWrong: \(wrongCount)")
                    .font(.system(size: 30, weight: .bold)), // Increased font size
                  dismissButton: .default(Text("OK"), action: resetGame))
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if gameActive && isCorrect == nil {
                wrongCount += 1 // Auto-fail if no selection
                nextNumber()
            }
        }
    }
    
    func checkAnswer(isPrime: Bool) {
        timer?.invalidate()
        if isPrime == isPrimeNumber(currentNumber) {
            isCorrect = true
            correctCount += 1
        } else {
            isCorrect = false
            wrongCount += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            nextNumber()
        }
    }
    
    func nextNumber() {
        attempts += 1
        if attempts % 10 == 0 {
            gameActive = false
            showAlert = true
        } else {
            currentNumber = Int.random(in: 1...100)
            isCorrect = nil
            startTimer()
        }
    }
    
    func resetGame() {
        correctCount = 0
        wrongCount = 0
        attempts = 0
        gameActive = true
        currentNumber = Int.random(in: 1...100)
        isCorrect = nil
        startTimer()
    }
    
    func isPrimeNumber(_ num: Int) -> Bool {
        if num < 2 { return false }
        for i in 2..<num where num % i == 0 {
            return false
        }
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

