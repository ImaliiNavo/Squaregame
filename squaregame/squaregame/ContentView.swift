import SwiftUI

struct ContentView: View {
  
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
  
    @State private var colorMap: [Int] = [
        0, 1, 2, // Row 0
        3, 0, 1, // Row 1
        2, 3, 0  // Row 2
    ]
    
    @State private var selectedButtons: [Int] = []
    @State private var matchedPairs: Set<Set<Int>> = []
    @State private var score: Int = 0
    @State private var gameOver: Bool = false
    
    var body: some View {
        VStack {
            if gameOver {
               
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
            } else {
               
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .padding()
                
                ZStack {
                  
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color.black, lineWidth: 2)
                        .frame(width: 320, height: 320)
                    
                    VStack(spacing: 0) {
                        ForEach(0..<3) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<3) { column in
                                    Button(action: {
                                        handleButtonTap(row: row, column: column)
                                    }) {
                                        Rectangle()
                                            .fill(colors[colorMap[row * 3 + column]])
                                            .frame(width: 100, height: 100)
                                            .border(Color.black)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(2)
                }
            }
        }
        .padding()
    }
    
    private func handleButtonTap(row: Int, column: Int) {
        let index = row * 3 + column
        
        if gameOver {
            
            return
        }
        
        if selectedButtons.contains(index) {
            
            selectedButtons.removeAll { $0 == index }
        } else {
            
            selectedButtons.append(index)
            
            if selectedButtons.count == 2 {
                
                let firstIndex = selectedButtons[0]
                let secondIndex = selectedButtons[1]
                let pair = Set([firstIndex, secondIndex])
                
                if matchedPairs.contains(pair) {
                   
                    selectedButtons.removeAll()
                    return
                }
                
                if colorMap[firstIndex] == colorMap[secondIndex] {
                    
                    score += 10
                    matchedPairs.insert(pair)
                    
                    
                    refreshColors()
                } else {
                   
                    gameOver = true
                }
                
                
                selectedButtons.removeAll()
            }
        }
    }
    
    private func refreshColors() {
        
        var newColorMap = (0..<colorMap.count).map { _ in colors.indices.randomElement()! }
        while newColorMap == colorMap {
            newColorMap = (0..<colorMap.count).map { _ in colors.indices.randomElement()! }
        }
        colorMap = newColorMap
    }
}

#Preview {
    ContentView()
}
