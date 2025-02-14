import SwiftUI

struct ContentView: View {
    @State private var currentNumber = Int.random(in: 1...100)
    @State private var isCorrect: Bool? = nil
    @State private var correctCount = 0
    @State private var wrongCount = 0
    @State private var attempts = 0
    @State private var showAlert = false
    
    @State private var timer: Timer? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            Text("\(currentNumber)")
                .font(.largeTitle)
                .padding()
            
            HStack(spacing: 40) {
                Button(action: {
                    checkAnswer(isPrime: true)
                }) {
                    Text("Prime")
                        .font(.title)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    checkAnswer(isPrime: false)
                }) {
                    Text("Not Prime")
                        .font(.title)
                        .padding()
                        .frame(width: 150, height: 50)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
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
            Alert(title: Text("Game Stats"),
                  message: Text("Correct: \(correctCount)\nWrong: \(wrongCount)"),
                  dismissButton: .default(Text("OK")))
        }
        .onAppear {
            startTimer()
        }
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if isCorrect == nil {
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
            showAlert = true
        }
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

