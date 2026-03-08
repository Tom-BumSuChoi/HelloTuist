import Foundation

public protocol FlightFeatureRouting {
    func showFlightSearch()
    func showFlightDetail(flightId: String)
    func showBookingConfirmation(flightId: String)
}
