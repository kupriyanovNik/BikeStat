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

    func planRide(
        title: String,
        rideDate: Date,
        estimatedTime: Int,
        estimatedDistance: Int,
        estimatedComplexity: String
    ) {
        let ride = RideInfoModel(context: viewContext)
        ride.title = title
        ride.isEnded = false
        ride.rideDate = rideDate
        ride.estimatedTime = Int64(estimatedTime)
        ride.estimatedDistance = Int64(estimatedDistance)
        ride.estimatedComplexity = estimatedComplexity

        saveContext()
        fetchPlannedRides()
    }

    func endRide(
        ride: RideInfoModel,
        pulseData: RidePulseInfoModel,
        speedData: RideSpeedInfoModel,
        realComplexity: String,
        realDistance: Int,
        realTime: Int
    ) {
        ride.isEnded = true
        ride.minPulse = Int64(pulseData.min)
        ride.avgPulse = Int64(pulseData.avg)
        ride.maxPulse = Int64(pulseData.max)
        ride.avgSpeed = Int64(speedData.avg)
        ride.maxSpeed = Int64(speedData.max)
        ride.realComplexity = realComplexity
        ride.realDistance = Int64(realDistance)
        ride.realTime = Int64(realTime)

        saveContext()
        fetchPlannedRides()
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
