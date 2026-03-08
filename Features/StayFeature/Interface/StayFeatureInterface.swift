import Foundation

public protocol StayFeatureRouting {
    func showStaySearch()
    func showStayDetail(stayId: String)
    func showBookingConfirmation(stayId: String, checkIn: Date, checkOut: Date)
}
