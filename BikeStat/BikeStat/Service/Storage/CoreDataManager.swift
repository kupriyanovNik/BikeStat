//
//  CoreDataManager.swift
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {

    // MARK: - Property Wrappers

    @Published var endedRides: [RideInfoModel] = []
    @Published var plannedRides: [RideInfoModel] = []

    // MARK: - Private Properties 

    private var viewContext: NSManagedObjectContext
    private var rideEntityName = "RideInfoModel"

    // MARK: - Inits

    init() {
        self.viewContext = PersistenceController.shared.viewContext
    }

    // MARK: - Internal Functions

    func fetchEndedRides() {
        let request = NSFetchRequest<RideInfoModel>(entityName: self.rideEntityName)
        request.sortDescriptors = [.init(keyPath: \RideInfoModel.rideDate, ascending: true)]
        let predicate = NSPredicate(format: "isEnded = %@", true)
        request.predicate = predicate

        do {
            self.endedRides = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func fetchPlannedRides() {
        let request = NSFetchRequest<RideInfoModel>(entityName: self.rideEntityName)
        request.sortDescriptors = [.init(keyPath: \RideInfoModel.rideDate, ascending: true)]
        let predicate = NSPredicate(format: "isEnded = %@", false)
        request.predicate = predicate

        do {
            self.plannedRides = try viewContext.fetch(request)
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }

    func addRide(
        time: Int,
        date: Date,
        distance: Int,
        estimatedComplexity: String,
        realComplexity: String,
        pulse: RidePulseInfoModel,
        speed: RideSpeedInfoModel
    ) {
        let ride = RideInfoModel(context: viewContext)
        ride.time = Int64(time)
        ride.rideDate = date
        ride.distance = Int64(distance)
        ride.estimatedComplexity = estimatedComplexity
        ride.realComplexity = realComplexity

        ride.minPulse = Int64(pulse.min)
        ride.avgPulse = Int64(pulse.avg)
        ride.maxPulse = Int64(pulse.max)

        ride.avgSpeed = Int64(speed.avg)
        ride.maxSpeed = Int64(speed.max)

        saveContext()
        fetchEndedRides()
    }

    func removeRide(
        ride: RideInfoModel
    ) {
        viewContext.delete(ride)
        saveContext()
        fetchEndedRides()
    }

    // MARK: - Private Functions

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("DEBUG: \(error.localizedDescription)")
        }
    }
}
