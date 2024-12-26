import 'dart:convert';

List<RoommateProfile> roommateProfileFromJson(String str) =>
    List<RoommateProfile>.from(
        json.decode(str).map((x) => RoommateProfile.fromJson(x)));

String roommateProfileToJson(List<RoommateProfile> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RoommateProfile {
  final int id;
  final int roomNumber;
  final DateTime startDate;
  final String seater;
  final String totalDuration;
  final String foodStatus;
  final String totalFeesPerMonth;
  final String totalAmount;
  final String registrationNumber;
  final String firstName;
  final String lastName;
  final String email;
  final String uuid;
  final String profilePic;
  final String gender;
  final String contactNumber;
  final String emergencyContactNumber;
  final String prefferedCourse;
  final String guardianName;
  final String relation;
  final String guardianContact;
  final String state;
  final String city;
  final String address;
  final String postalCode;
  final DateTime entryDate;

  RoommateProfile({
    required this.id,
    required this.roomNumber,
    required this.startDate,
    required this.seater,
    required this.totalDuration,
    required this.foodStatus,
    required this.totalFeesPerMonth,
    required this.totalAmount,
    required this.registrationNumber,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uuid,
    required this.profilePic,
    required this.gender,
    required this.contactNumber,
    required this.emergencyContactNumber,
    required this.prefferedCourse,
    required this.guardianName,
    required this.relation,
    required this.guardianContact,
    required this.state,
    required this.city,
    required this.address,
    required this.postalCode,
    required this.entryDate,
  });

  factory RoommateProfile.fromJson(Map<String, dynamic> json) =>
      RoommateProfile(
        id: json["id"],
        roomNumber: json["Room_Number"],
        startDate: DateTime.parse(json["Start_Date"]),
        seater: json["Seater"],
        totalDuration: json["Total_Duration"],
        foodStatus: json["Food_Status"],
        totalFeesPerMonth: json["Total_Fees_Per_Month"],
        totalAmount: json["Total_Amount"],
        registrationNumber: json["Registration_Number"],
        firstName: json["First_Name"],
        lastName: json["Last_Name"],
        email: json["Email"],
        uuid: json["uuid"],
        profilePic: json["Profile_Pic"],
        gender: json["Gender"],
        contactNumber: json["Contact_Number"],
        emergencyContactNumber: json["Emergency_Contact_Number"],
        prefferedCourse: json["Preffered_Course"],
        guardianName: json["Guardian_Name"],
        relation: json["Relation"],
        guardianContact: json["Guardian_Contact"],
        state: json["State"],
        city: json["City"],
        address: json["Address"],
        postalCode: json["Postal_Code"],
        entryDate: DateTime.parse(json["entry_date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "Room_Number": roomNumber,
        "Start_Date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "Seater": seater,
        "Total_Duration": totalDuration,
        "Food_Status": foodStatus,
        "Total_Fees_Per_Month": totalFeesPerMonth,
        "Total_Amount": totalAmount,
        "Registration_Number": registrationNumber,
        "First_Name": firstName,
        "Last_Name": lastName,
        "Email": email,
        "uuid": uuid,
        "Profile_Pic": profilePic,
        "Gender": gender,
        "Contact_Number": contactNumber,
        "Emergency_Contact_Number": emergencyContactNumber,
        "Preffered_Course": prefferedCourse,
        "Guardian_Name": guardianName,
        "Relation": relation,
        "Guardian_Contact": guardianContact,
        "State": state,
        "City": city,
        "Address": address,
        "Postal_Code": postalCode,
        "entry_date": entryDate.toIso8601String(),
      };
}
