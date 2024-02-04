import SwiftUI

struct QuoteView: View {
    @StateObject private var viewModel = ViewModel(controller: FetchController())

    let show: String

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(show.lowercased().filter { $0 != " " })
                    .resizable()
                    .frame(width: geo.size.width * 2.7, height: geo.size.height * 1.2)

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
                            .frame(width: geo.size.width / 1.1, height: geo.size.height / 1.8)
                            .cornerRadius(80)
                    }
                    Spacer()

                    Button {
                        Task {
                            await viewModel.getData(for: show)
                        }

                    } label: {
                        Text("Get Random Quote")
                            .font(.title)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.breakingBadGreen)
                            .cornerRadius(7)
                            .shadow(color: .breakingBadYellow, radius: 2)
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
    QuoteView(show: "Breaking Bad")
        .preferredColorScheme(/*@START_MENU_TOKEN@*/ .dark/*@END_MENU_TOKEN@*/)
}
