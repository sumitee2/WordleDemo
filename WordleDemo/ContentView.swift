//
//  ContentView.swift
//  WordleDemo
//
//  Created by Sumit Chaudhary on 10/02/22.
//

import SwiftUI

enum ButtonResult {
    case Right
    case Wrong
    case Displaced
    
    var color: Color {
        switch self {
        case .Wrong:
            return Color(.systemGray2)
        case .Displaced:
            return Color(.systemYellow)
        case .Right:
            return Color(.systemGreen)
        }
    }
}

struct ContentView: View {
    @State var isTyping = false;
    @StateObject var vmodel = ViewModelo(rows: 6, columns: 5)
    
    var body: some View {
        ZStack {
            CustomTextField(text: $vmodel.currentString, isFirstResponder: true, onPressReturn: {
                self.enterPressed()
            })
            .frame(width: 1, height: 1)
            .onChange(of: vmodel.currentString) {  new in
                vmodel.typedWords[vmodel.rowInUse] = new.uppercased()
            }
            .opacity(0)
            .keyboardType(.asciiCapable)
            .disableAutocorrection(true)
            
             VStack {
                WordRow(typedWord: $vmodel.typedWords[0], evaluatedStates: $vmodel.evaluatedStates[0])
                WordRow(typedWord: $vmodel.typedWords[1], evaluatedStates: $vmodel.evaluatedStates[1])
                WordRow(typedWord: $vmodel.typedWords[2], evaluatedStates: $vmodel.evaluatedStates[2])
                WordRow(typedWord: $vmodel.typedWords[3], evaluatedStates: $vmodel.evaluatedStates[3])
                WordRow(typedWord: $vmodel.typedWords[4], evaluatedStates: $vmodel.evaluatedStates[4])
                WordRow(typedWord: $vmodel.typedWords[5], evaluatedStates: $vmodel.evaluatedStates[5])
            }
        }
    }
    
    func enterPressed() {
        if vmodel.typedWords[vmodel.rowInUse].count < 5 {
            return
        }
        vmodel.currentString = ""
        vmodel.rowInUse += 1
        performEvaluation()
    }
    
    func performEvaluation() {
        let row = vmodel.rowInUse - 1
        for i in 0...4 {
            if vmodel.typedWords[row][i].compare(vmodel.solution[i]) == .orderedSame {
                vmodel.evaluatedStates[row][i] = .Right
            } else if vmodel.solution.contains(vmodel.typedWords[row][i]) {
                vmodel.evaluatedStates[row][i] = .Displaced
            } else {
                vmodel.evaluatedStates[row][i] = .Wrong
            }
        }
        print(vmodel.typedWords[row])
    }
}

struct WordRow: View {
    @State var isCurrent = false;
    @Binding var typedWord: String
    @Binding var evaluatedStates:  [ButtonResult]
    
    var word: String = ""
    var body: some View {
        HStack {
            LetterButton(result: evaluatedStates[0], letter: typedWord[0])
            LetterButton(result: evaluatedStates[1], letter: typedWord[1])
            LetterButton(result: evaluatedStates[2], letter: typedWord[2])
            LetterButton(result: evaluatedStates[3], letter: typedWord[3])
            LetterButton(result: evaluatedStates[4], letter: typedWord[4])
        }
    }
}



struct LetterButton : View {
    var result: ButtonResult
    var letter: String = ""
    var body: some View {
        Button("\(letter)") {
            print("tapped")
        }
        .modifier(letterButtonModifier())
        .background(result.color)
    }
}

struct letterButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 36, weight: .bold, design: .rounded))
            .foregroundColor(.white)
            .frame(width: 50, height: 50, alignment: .center)
            .padding(10)
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

//TEXT FIELD
struct CustomTextField: UIViewRepresentable {

    class Coordinator: NSObject, UITextFieldDelegate {

        @Binding var text: String
        var onPressReturn: () -> ()
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
            onPressReturn = {}
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            onPressReturn()
            return false
        }
    }

    @Binding var text: String
    var isFirstResponder: Bool = false
    var onPressReturn: () -> ()
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        return textField
    }

    func makeCoordinator() -> CustomTextField.Coordinator {
        let coordinat = Coordinator(text: $text)
        coordinat.onPressReturn = onPressReturn
        
        return coordinat
    }

    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}
