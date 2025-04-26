//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mohamed Obaya on 25/04/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland",  "Spain", "UK", "Ukraine", "US"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var chosenAnswer = 0
    
    @State private var showingScore = false
    @State private var showingGameOver = false
    @State private var scoreTitle = ""
    @State private var isAnswerCorrect = true
    @State private var score = 0
    @State private var deduction = ""
    @State private var questionNumber = 1
    let maxQuestionNumber = 10
    let maxAnswerNumber = 4
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            
            VStack {
                Spacer()
                
                Text("Guess the Flag ?")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.thinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("\(questionNumber). Tap the flag of")
                            .font(.title3.weight(.heavy))
                            .foregroundStyle(.primary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold ))
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    
                    LazyVGrid(columns: [GridItem(), GridItem()]) {
                        ForEach(0..<maxAnswerNumber, id: \.self) { number in
                            Button {
                                flagTapped(number)
                                chosenAnswer = number
                            } label: {
                                Image(countries[number])
                                    .resizable()
                                    .frame(maxWidth: 200)
                                    .clipShape(.rect(cornerRadius: 20))
                                    .shadow(radius: 5)
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 10)
                
                Spacer()
                
                Text("Score is \(score)")
                    .font(.title.bold())
                    .foregroundStyle(.primary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius: 20))
            
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            if isAnswerCorrect {
                Text("Current score is now \(score)")
            } else {
                Text("That's the flag of \(countries[chosenAnswer])\(deduction)")
            }
        }
        .alert("Game Over", isPresented: $showingGameOver) {
            Button("Restart", action: reset)
        } message : {
            Text("Your total score is \(score)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            isAnswerCorrect = true
            score += 1
        } else {
            scoreTitle = "Wrong"
            isAnswerCorrect = false
            deduction = score != 0 ? ", a point have been deducted": ""
            score = score > 0 ? (score - 1): 0
        }
        if questionNumber < maxQuestionNumber {
            showingScore = true
        } else {
            showingGameOver = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0..<maxAnswerNumber)
        questionNumber += 1
    }
    
    func reset() {
        askQuestion()
        questionNumber = 1
        score = 0
    }
}

#Preview {
    ContentView()
}
 
