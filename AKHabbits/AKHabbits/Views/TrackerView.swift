//
//  ContentView.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import SwiftUI


struct TrackerView: View {
    @State var selectedDate: Date = Date()
    @State var list: [Habbit] = []
    
    var body: some View {
        VStack {
            HStack {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.title2)
                                .bold()
                                .foregroundColor(Color.accentColor)
                                .padding()
                            
                            NavigationLink {
                                AddHabbitToDate() { habbit in
                                    list.append(habbit)
                                    
                                    saveListToUserDefaults()
                                }
                            } label: {
                                HStack {
                                    Text("Add habbit to this date")
                                    Image(systemName: "plus.circle")
                                        .imageScale(.large)
                                }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 10)
                                .background(.blue)
                                .cornerRadius(30)
                                .foregroundColor(.white)
                            }
                            
            }
            
            Divider()
                .frame(height: 1)
            DatePicker("Select Date", selection: $selectedDate, displayedComponents: [.date])
                .padding()
                .datePickerStyle(.graphical)
                .onChange(of: selectedDate) { newValue in
                            list = []
                            loadData()
                }
            
            Divider()
            
            List(list) { habbit in
                HStack {
                    Text(habbit.title)
                        .foregroundColor(.primary)
                        .bold()
                        .font(.title3)
                    Spacer()
                    Text(habbit.type.rawValue)
                        .foregroundColor(.secondary)
                }
                .padding()
                .cornerRadius(20)
            }
            .listStyle(.plain)
            
                
        }
        .onAppear {
             loadData()
        }
        .navigationTitle("AKHabbit")
    }
    
    func loadData() {
        let formattedDate = formatSelectedData()
        
        if let data = UserDefaults.standard.data(forKey: formattedDate),
           let decodedHabits = try? JSONDecoder().decode([Habbit].self, from: data) {
            self.list = decodedHabits
        }
    }
    
    func saveListToUserDefaults() {
        let formattedDate = formatSelectedData()
        
        if let encodedData = try? JSONEncoder().encode(list) {
            UserDefaults.standard.set(encodedData, forKey: formattedDate)
        }
    }
    
    func formatSelectedData() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        return dateFormatter.string(from: selectedDate)
    }
}

struct TrackerView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerView()
    }
}
