//
//  Habbits.swift
//  AKHabbits
//
//  Created by Анна Перехрест  on 2023/09/19.
//

import Foundation
enum HabbitType: String, CaseIterable, Codable {
    case healthy
    case unhealthy
    case mental
    case cleaning
    case custom
}

struct Habbit: Identifiable, Equatable, Hashable, Codable {
    var id: UUID
    var title: String
    var type: HabbitType
    
    init(title: String, type: HabbitType) {
        self.id = UUID()
        self.title = title
        self.type = type
    }
}


struct HabbitList {
    var list: [Habbit]  = [
        Habbit(title: "Drinking", type: .unhealthy),
        Habbit(title: "Smoking", type: .unhealthy),
        Habbit(title: "Running", type: .healthy),
        Habbit(title: "Meditation", type: .mental),
        Habbit(title: "Cleaning room", type: .cleaning),
        Habbit(title: "Vocal trainig", type: .custom),
        Habbit(title: "programming", type: .custom)
    ]
    
    mutating func setNewHabbit(habbit: Habbit) {
        list.append(habbit)
    }
}
