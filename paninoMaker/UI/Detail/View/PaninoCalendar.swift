//
//  PaninoCalendar.swift
//  paninoMaker
//
//  Created by Nicola Graziotin on 08/06/25.
//

import SwiftUI
import EventKit

struct PaninoCalendar: View {
    @State private var showCalendarAlert: Bool = false

    var date: Date
    var title: String

    var body: some View {
        Button {
            showCalendarAlert.toggle()
        } label: {
            Text(date.formatted(date: .numeric, time: .omitted))
        }
        .alert("Vuoi aggiungere questo evento al calendario?", isPresented: $showCalendarAlert) {
            Button("Conferma", action: {
                addAllDayEventToCalendar(
                    title: title,
                    description: "Hai creato questo panino.",
                    date: date
                )
            })
            Button("Annulla", role: .cancel) {}
        }
    }
    
    func addAllDayEventToCalendar(title: String, description: String?, date: Date) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.notes = description
                event.isAllDay = true
                event.startDate = date
                event.endDate = date
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Evento a giornata intera aggiunto con successo!")
                } catch let error as NSError {
                    print("Errore durante il salvataggio: \(error)")
                }
            } else {
                print("Accesso al calendario negato o errore: \(String(describing: error))")
            }
        }
    }
}

#Preview {
    PaninoCalendar(date: Date.now, title: "Panino")
}
