//
//  AddHabbitToDate.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import SwiftUI

struct AddHabbitToDate: View {
    @State var data = HabbitList()
    
    @State var name = ""
    @State var type = HabbitType.custom
    @State var selectedHabbit: Habbit?
    
    var onDismiss: (Habbit) -> Void
    
    var body: some View {
        VStack {
            VStack(spacing: 20) {
                Text("Create new habit")
                    .font(.title)
                    .bold()
                TextField("Habit name:", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.secondary, lineWidth: 1)
                    )
                
                HStack {
                    Text("Habit Type:")
                    Spacer()
                    Picker(selection: $type, label: Text("Habit Type")) {
                        ForEach(HabbitType.allCases, id: \.self) { habitType in
                            Text(habitType.rawValue)
                        }
                    }
                    .pickerStyle(.menu)
                }
                Button {
                    data.setNewHabbit(habbit: Habbit(title: name, type: type))
                } label: {
                    Text("Create new habit")
                        .padding(.horizontal, 30)
                        .padding(.vertical)
                        .background(.blue)
                        .cornerRadius(30)
                        .foregroundColor(.white)
                        .padding(.bottom)
                }
                
            }.padding()
            
            Text("Select habit from list")
                .font(.title)
                .bold()
            
            List(data.list) { habbit in
                HStack {
                    Text(habbit.title)
                        .foregroundColor(habbit == selectedHabbit ? .white : .primary)
                        .bold()
                        .font(.title3)
                    Spacer()
                    Text(habbit.type.rawValue)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(habbit == selectedHabbit ? Color.blue.opacity(0.8) : .clear)
                .cornerRadius(20)
                .onTapGesture {
                    selectedHabbit = habbit
                }
            }
            .listStyle(.inset)
            
        } .onAppear {
            selectedHabbit = data.list.first
        }
        .onDisappear {
            if let habbit = selectedHabbit {
                self.onDismiss(habbit)
            }
        }
    }
}

struct AddHabbitToDate_Previews: PreviewProvider {
    static var previews: some View {
        AddHabbitToDate(onDismiss: { _ in })
    }
}
