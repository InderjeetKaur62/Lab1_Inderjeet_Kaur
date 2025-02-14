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
        VStack {
            Text("\(currentNumber)")
                .font(.largeTitle)
                .padding()
            
            Button("Prime") {
                checkAnswer(isPrime: true)
            }
            .font(.title)
            .foregroundColor(.blue)
            
            Button("Not Prime") {
                checkAnswer(isPrime: false)
            }
            .font(.title)
            .foregroundColor(.blue)
            
            if let isCorrect = isCorrect {
                Image(systemName: isCorrect ? "checkmark" : "xmark")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
            }
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
            wrongCount += 1 // Auto-fail if no selection
            nextNumber()
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
        nextNumber()
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

