struct FlightInfo: Codable {
    let flnr: String
    let date: String?
    let scheduledDepartureLocal: String?
    let scheduledArrivalLocal: String?
    let departureName: String?
    let arrivalName: String?
}
