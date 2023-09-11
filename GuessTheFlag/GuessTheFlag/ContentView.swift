//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Oluwapelumi Williams on 04/09/2023.
//

/*
 Additional Challenges to the GuessTheFlagApp.
 Add an @State property to store the user’s score, modify it when they get an answer right or wrong, then display it in the alert and in the score label.
 When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.
 Make the game show only 8 questions, at which point they see a final alert judging their score and can restart the game.
 */
import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var alertMessage: String = ""
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var showingScore = false
    @State private var showingReset = false
    @State private var scoreTitle = ""
    @State private var userScore: Int = 0
    private var maxQuestionCount: Int = 8
    @State private var questionCount: Int = 0
    
    // VARIABLES FOR THE TRANSITION
    @State private var opacity: Double = 1.0
    
    // This is done as a custom modifier.
    struct FlagImage: View {
        var country: String
        
        var body: some View {
            Image(country)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    var body: some View {
        ZStack {
//            Color.blue
//            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue:0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    // .font(.largeTitle.bold()) // shortcut for the above line
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    // .foregroundColor(.white)
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
//                            Image(countries[number])
//                                .renderingMode(.original)
//                                .clipShape(Capsule())
//                                .shadow(radius: 5)
                            FlagImage(country: countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
            // where the alert is placed does not matter. However, We cannot place two alert modifiers on the same element/view.
            
//            .alert(scoreTitle, isPresented: $showingReset) {
//                Button("Reset", role: .destructive, action: resetGame)
//            } message: {
//                Text(alertMessage)
//            }
        }
        // Uhh... ignore the comment above about not being able to put two alert modifiers on the same view. Apparently it works as you can see. But I think it will not work if you try to put them on the same button.
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            // Text("Your score is \(userScore)")
            Text(alertMessage)
        }
        
        .alert(scoreTitle, isPresented: $showingReset) {
            Button("Reset", action: resetGame)
        } message: {
            Text(alertMessage)
        }
        
        
        Button(action: {
            print("Button tapped")
            withAnimation(.easeInOut(duration: 5.0)) {
                self.opacity = 0.5
            }
        }) {
            Text("Tap me!")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(opacity)
        }
        
    }
    
    func flagTapped(_ number: Int) {
        if questionCount == maxQuestionCount {
            // dispay another button to reset the game -> start from the beginning.
            showingReset = true
            alertMessage = alertMessage + "\nYou got \(userScore) out of \(maxQuestionCount) correct!"
            // it is important for this to come first, so that we don't get one alert and then the other, when the questions have reached 8
        } else {
            if number == correctAnswer {
                scoreTitle = "Correct"
                userScore += 1
                alertMessage = ""// not showing any alert message if selection is correct. Because the score is already being shown
            } else {
                scoreTitle = "Wrong!"
                alertMessage = "That's the flag of \(countries[number])"
            }
            showingScore = true
            questionCount += 1
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func resetGame() {
        questionCount = 0
        userScore = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
