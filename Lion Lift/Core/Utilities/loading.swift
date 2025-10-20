import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color(red: 0, green: 0.22, blue: 0.40)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                // Logo
                Image("lion")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 112, height: 112)
                
                Text("Lion Lift")
                    .font(.custom("Poppins", size: 50).weight(.bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
            .previewDevice("iPhone 15 Pro")
    }
}
