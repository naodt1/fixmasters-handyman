class GigModel {
  final String gigId; // Assuming a unique identifier for the gig within the handyman's collection
  final String gigName;
  final String category;

  GigModel({
    required this.gigId,
    required this.gigName,
    required this.category,
  });

  // Factory constructor to create a GigModel from a Firestore DocumentSnapshot
  factory GigModel.fromMap(Map<String, dynamic> data) {
    return GigModel(
      gigId: '', // Assign a placeholder value as the ID might not be directly available in the subcollection document
      gigName: data['gigName'] ?? '',
      category: data['category'] ?? '',
    );
  }
}
