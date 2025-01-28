//
//  WelcomeView.swift
//  MoneyTracker
//
//  Created by Jan Dub on 04.06.2024.
//

import Foundation
import SwiftUI
import MapKit
import Charts

struct WelcomeView: View {
    @StateObject var statisticsViewModel: StatisticsViewModel
    @State var percent: CGFloat = 0
    @State private var animatedWidth: CGFloat = 0
    
    var body: some View {
        let maxYValue =  statisticsViewModel.puchasesByDatesTuples.map { $0.sum }.max() ?? 10.0
        
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        Section(
                            content: {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .frame(width: UIScreen.screenWidth - 40, height: 10)
                                        .foregroundColor(Color.black.opacity(0.1))
                                    
                                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .frame(width: statisticsViewModel.calculateWidth(val: (UIScreen.screenWidth - 40)), height: 10)
                                        .foregroundColor(statisticsViewModel.getBarColor())
                                        .onAppear {
                                            withAnimation(.spring()) {
                                                animatedWidth = statisticsViewModel.calculateWidth(val: (UIScreen.screenWidth - 40))
                                            }
                                        }
                                }
                                //.withAnimation(.spring()) {}
                            },
                            footer: {
                                Text("\(statisticsViewModel.getPurchasesPriceSumStr()) Kč / \(statisticsViewModel.getLimitStr()) Kč")
                            }
                        )
                    }
                   // .cornerRadius(10)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                    Spacer()
                    
                    VStack {
                        Section {
                            HStack {
                                Text("Limit (\(statisticsViewModel.limitPurchasesTupple.stringLimit) Kč): " )
                                
                                Spacer()
                                
                                if(statisticsViewModel.limitPurchasesTupple.limit >= statisticsViewModel.limitPurchasesTupple.sum) {
                                    Text("nepřekročen")
                                        .foregroundColor(Color.green)
                                    
                                } else {
                                    Text("překročen")
                                        .foregroundColor(Color.red)
                                }
                            }
                            .padding(.horizontal, 5)
                        }
                        .padding(13)
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
                    
                    VStack {
                        List {
                            Section(
                                content: {
                                    NavigationLink {
                                        MapWithPointsView(purchases: statisticsViewModel.getPurchasesByCoordinates())
                                    }
                                    label: {
                                        Text("Přehled nákupů na mapě:")
                                    }
                                }
                            )
                        }
                        .frame(height: 100)
                    }
                    
                    VStack {
                        Section(
                            content: {
                                Chart {
                                    ForEach(statisticsViewModel.puchasesByDatesTuples, id: \.day) { data in
                                        LineMark(x: .value("Den", "\(data.day)."),
                                                 y: .value("Suma", data.sum))
                                        .interpolationMethod(.catmullRom)
                                        
                                        PointMark(x: .value("Den", "\(data.day)."),
                                                  y: .value("Suma", data.sum))
                                        .annotation(position: .top) {
                                            Text("\(data.sum > 0.0 ? String(data.sum) : "")")
                                        }
                                    }
                                }
                                .chartYScale(domain: 0...maxYValue)
                                .aspectRatio(1, contentMode: .fit)
                                .padding()
    
                            },
                            header: {
                                Text("Útraty v jednotlivých dnech:")
                                    .padding()
                            }
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                    
                    VStack {
                        Section(
                            content: {
                                if(statisticsViewModel.storesByVisitsTuples.count > 0) {
                                    Chart(statisticsViewModel.storesByVisitsTuples) { data in
                                        SectorMark(
                                            angle: .value(
                                                Text(verbatim: String(format: "%f", data.sum)),
                                                data.sum
                                            )
                                        )
                                        .annotation(position: .overlay, alignment: .center) {
                                            VStack {
                                                Text("\(data.store)")
                                                Text("\(data.sum)")
                                            }
                                        }
                                        
                                        .foregroundStyle(
                                            by: .value(
                                                Text(verbatim: "test"),
                                                data.store
                                            )
                                        )
                                    }
                                    .animation(.snappy, value: statisticsViewModel.storesByVisitsTuples)
                                    .chartLegend(.hidden)
                                    .aspectRatio(0.85, contentMode: .fit)
                                    .padding()
                                } else {
                                    Text("Nenavštíveny žádné obchody.")
                                        .padding(62)
                                }
                            },
                            header: {
                                Text("Návštěvnost v obchodech:")
                                    .padding()
                            }
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(20)
                }
                
            }
            .navigationBarTitle("Aktuální statistiky")
          
            .background(Color(red: 242.0 / 255.0, green: 242 / 255.0, blue: 248 / 255.0))
            
            .onAppear() {
                withAnimation(.spring()) {
                    statisticsViewModel.changeStatistics(num: 0)
                }
            }
        }
    }
}

extension UIScreen {
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
