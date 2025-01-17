//
//  WeatherView.swift
//  WeatherTrackerApp
//
//  Created by Angelber Castro on 16/1/25.
//

import Foundation
import SwiftUI

struct WeatherView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        VStack(spacing: 20) {
            // Search bar
            HStack {
                TextField("Search Location", text: $viewModel.query)
                    .font(.custom("Poppins-Regular", size: 15))
                    .padding(10)
                    .background(Color(.systemGray5))
                    .cornerRadius(10)
            }
            .padding()

            if viewModel.isSearching, let weather = viewModel.weatherResponse {
                // Show the "result card"
                Button(action: {
                    viewModel.selectCity()
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(weather.location.name)
                                .font(.custom("Poppins-Bold", size: 20))
                                .foregroundColor(.black)

                            Text("\(Int(weather.current.tempC))°")
                                .font(.custom("Poppins-Medium", size: 60))
                                .foregroundColor(.black)
                        }

                        Spacer()

                        AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 50, height: 50)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle())
                .padding()

            } else if let weather = viewModel.weatherResponse {
                Spacer()
                // Main view with weather details
                VStack {
                    AsyncImage(url: URL(string: "https:\(weather.current.condition.icon)")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)

                    Text(weather.location.name)
                        .font(.custom("Poppins-Bold", size: 30))

                    Text("\(Int(weather.current.tempC))°")
                        .font(.custom("Poppins-Medium", size: 70))
                }

                // Additional details
                HStack {
                    VStack {
                        Text("Humidity")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.gray)
                        Text("\(weather.current.humidity)%")
                            .font(.custom("Poppins-Medium", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack {
                        Text("UV")
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundColor(.gray)
                        Text(weather.current.uv.formatted(.number.precision(.fractionLength(0...2))))
                            .font(.custom("Poppins-Medium", size: 15))
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack {
                        Text("Feels Like")
                            .font(.custom("Poppins-Medium", size: 10))
                            .foregroundColor(.gray)
                        Text("\(Int(weather.current.feelslikeC))°")
                            .font(.custom("Poppins-Medium", size: 15))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(15)
                .padding(.horizontal)

                Spacer()
            } else {
                Spacer()
                // Initial Message or error
                VStack(spacing: 10) {
                    Text(viewModel.weatherMessage ?? "No City Selected")
                        .font(.custom("Poppins-Bold", size: 30))
                        .multilineTextAlignment(.center)

                    Text("Please Search For A City")
                        .font(.custom("Poppins-Bold", size: 15))
                        .multilineTextAlignment(.center)
                }
                .foregroundColor(.black)
            }

            Spacer()
        }
        .onAppear {
            // Display initial message when view appears
            viewModel.weatherMessage = "No City Selected"
        }
        .background(
            Color.white // Add a background color to detect taps
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    hideKeyboard() // Hide the keyboard on tap outside
                }
        )
    }

    // Helper function to hide the keyboard
    private func hideKeyboard() {
        UIApplication.shared.endEditing()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
