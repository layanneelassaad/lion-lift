import SwiftUI

struct ChatbotView: View {
    @State private var messages: [ChatMessage] = []
    @State private var userInput: String = ""
    @State private var isLoading: Bool = false

    private let openAIKey = ""
    private let openAIURL = "https://api.openai.com/v1/chat/completions"

    var body: some View {
        VStack {
           
            Text("AI Chatbot")
                .font(.title2)
                .fontWeight(.semibold)
                .padding()

            Divider()

           
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(messages, id: \.id) { message in
                        HStack {
                            if message.isUser {
                                Spacer()
                                ChatBubble(text: message.content, isUser: true)
                            } else {
                                ChatBubble(text: message.content, isUser: false)
                                Spacer()
                            }
                        }
                    }
                }
                .padding()
            }

            Spacer()

          
            HStack {
                TextField("Type your message...", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(height: 40)
                    .disabled(isLoading)

                Button(action: sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0, green: 0.22, blue: 0.40))
                        .clipShape(Circle())
                }
                .disabled(userInput.isEmpty || isLoading)
            }
            .padding()
        }
    }

 
    private func sendMessage() {
        let userMessage = ChatMessage(id: UUID(), content: userInput, isUser: true)
        messages.append(userMessage)
        let currentInput = userInput
        userInput = ""
        isLoading = true

        let requestBody: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": currentInput]
            ]
        ]

        guard let url = URL(string: openAIURL) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

   
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                isLoading = false
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let data = data,
                   let response = try? JSONDecoder().decode(OpenAIResponse.self, from: data),
                   let botMessage = response.choices.first?.message.content {
                    messages.append(ChatMessage(id: UUID(), content: botMessage, isUser: false))
                }
            }
        }.resume()
    }
}


struct ChatMessage: Identifiable {
    let id: UUID
    let content: String
    let isUser: Bool
}

struct OpenAIResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable {
            let role: String
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}


struct ChatBubble: View {
    let text: String
    let isUser: Bool

    var body: some View {
        HStack {
            if !isUser {
                Image(systemName: "person.fill") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .padding(.leading, 8)
            }

            Text(text)
                .padding()
                .foregroundColor(isUser ? .black : .black)
                .background(isUser ? Color(red: 155/255, green: 203/255, blue: 235/255) : Color.gray.opacity(0.2))
                .cornerRadius(16)
                .frame(maxWidth: .infinity, alignment: isUser ? .trailing : .leading)
            
            if isUser {
                Spacer()
            }
        }
    }
}



struct ChatbotView_Previews: PreviewProvider {
    static var previews: some View {
        ChatbotView()
    }
}
