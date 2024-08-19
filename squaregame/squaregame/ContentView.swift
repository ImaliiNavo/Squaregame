import SwiftUI

struct ContentView: View {
    // Define the four colors
    let colors: [Color] = [.red, .blue, .green, .yellow]
    
    // Define a color map for button positions
    @State private var colorMap: [Int] = [
        0, 1, 2, // Row 0
        3, 0, 1, // Row 1
        2, 3, 0  // Row 2
    ]
    
    @State private var selectedButtons: [Int] = [] // Track selected button indices
    @State private var matchedPairs: Set<Set<Int>> = [] // Track matched pairs
    @State private var score: Int = 0 // Track score
    @State private var gameOver: Bool = false // Track game over state
    
    var body: some View {
        VStack {
            if gameOver {
                // Game over message
                Text("Game Over")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Score Display
                Text("Score: \(score)")
                    .font(.largeTitle)
                    .padding()
                
                ZStack {
                    // Outline border for the entire grid
                    RoundedRectangle(cornerRadius: 10) // Optional corner radius for rounded corners
                        .strokeBorder(Color.black, lineWidth: 2) // Border color and width
                        .frame(width: 320, height: 320) // Adjust size to fit the grid
                    
                    // 3x3 grid of colored buttons
                    VStack(spacing: 0) {
                        ForEach(0..<3) { row in
                            HStack(spacing: 0) {
                                ForEach(0..<3) { column in
                                    Button(action: {
                                        handleButtonTap(row: row, column: column)
                                    }) {
                                        Rectangle()
                                            .fill(colors[colorMap[row * 3 + column]]) // Fill each button with the specified color
                                            .frame(width: 100, height: 100) // Adjust the size of each button
                                            .border(Color.black) // Optional border for clarity
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                        }
                    }
                    .padding(2) // Optional padding to create space between buttons and the border
                }
            }
        }
        .padding()
    }
    
    private func handleButtonTap(row: Int, column: Int) {
        let index = row * 3 + column
        
        if gameOver {
            // If the game is over, ignore button taps
            return
        }
        
        if selectedButtons.contains(index) {
            // If the button is already selected, deselect it
            selectedButtons.removeAll { $0 == index }
        } else {
            // Add the button index to the selection
            selectedButtons.append(index)
            
            if selectedButtons.count == 2 {
                // Check if the two selected buttons have the same color
                let firstIndex = selectedButtons[0]
                let secondIndex = selectedButtons[1]
                let pair = Set([firstIndex, secondIndex])
                
                if matchedPairs.contains(pair) {
                    // If the pair has already been matched, ignore it
                    selectedButtons.removeAll()
                    return
                }
                
                if colorMap[firstIndex] == colorMap[secondIndex] {
                    // If colors match, increase score and mark the pair as matched
                    score += 10
                    matchedPairs.insert(pair) // Mark this pair as matched
                    
                    // Refresh colors after a correct match
                    refreshColors()
                } else {
                    // If colors do not match, show game over message
                    gameOver = true
                }
                
                // Clear selection
                selectedButtons.removeAll()
            }
        }
    }
    
    private func refreshColors() {
        // Shuffle colors and assign to the color map
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
