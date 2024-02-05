import SwiftUI

struct QuoteView: View {
    let show: String

    @StateObject private var viewModel = ViewModel(controller: FetchController())

    @State private var showCharacterInfo = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.lowerNoSpaces)
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

                VStack {
                    VStack {
                        Spacer(minLength: 140)

                        switch viewModel.status {
                        case let .success(data):
                            Text("\"\(data.quote.quote)\"")
                                .minimumScaleFactor(0.5)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .padding()
                                .background(.black.opacity(0.5))
                                .cornerRadius(25)
                                .padding(.horizontal)

                            ZStack(alignment: .bottom) {
                                AsyncImage(url: data.character.images[0]) { image in
                                    image
                                        .resizable()
                                        .scaledToFit()
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                .cornerRadius(80)
                                .onTapGesture {
                                    showCharacterInfo.toggle()
                                }
                                .sheet(isPresented: $showCharacterInfo) {
                                    CharacterView(show: show, character: data.character)
                                }

                                Text(data.quote.character)
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .frame(maxWidth: /*@START_MENU_TOKEN@*/ .infinity/*@END_MENU_TOKEN@*/)
                                    .background(.ultraThinMaterial)
                            }
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .cornerRadius(80)

                        case .fetching:
                            ProgressView()
                                .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                                .cornerRadius(80)

                        default:
                            EmptyView()
                        }

                        Spacer()
                    }

                    Button {
                        Task {
                            await viewModel.getData(for: show)
                        }

                    } label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .background(Color("\(show.noSpaces)Button"))
                            .cornerRadius(7)
                            .shadow(color: Color("\(show.noSpaces)Shadow"), radius: 2)
                    }

                    Spacer(minLength: 180)
                }
                .frame(width: geo.size.width)
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    QuoteView(show: Constants.bbName)
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
}
