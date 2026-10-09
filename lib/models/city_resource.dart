class CityResource {
  final String cityName;
  final String details;
  final String website;
  final String contact;
  final List<String> requirements;

  const CityResource({
    required this.cityName,
    required this.details,
    required this.website,
    required this.contact,
    required this.requirements,
  });

  static const List<CityResource> neuteringResources = [
    CityResource(
      cityName: "Apayao City",
      details:
          "Free neutering services available every "
          "first Friday of the month at the City Vet Office.",
      website: "www.apayao.gov.ph/vet",
      contact: "(074) 123-4567",
      requirements: [
        "Barangay Clearance",
        "Valid ID",
        "Pet must be healthy and fasted",
      ],
    ),
    CityResource(
      cityName: "Bacoor City",
      details:
          "Ongoing LGU campaign. "
          "Register online through the Bacoor City portal.",
      website: "www.bacoor.gov.ph/services",
      contact: "(046) 481-4100",
      requirements: ["Proof of Bacoor Residency", "Pet Vaccination Card"],
    ),
    CityResource(
      cityName: "Mandaluyong City",
      details:
          "Walk-in services available at the "
          "City Veterinary Department on weekdays.",
      website: "www.mandaluyong.gov.ph",
      contact: "(02) 8532-5001",
      requirements: [
        "Voter's ID or Barangay Certificate",
        "Pet must be at least 6 months old",
      ],
    ),
  ];
}
