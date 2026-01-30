class ChoreConstants {
  static const String apiEndpointCreateChore = "chores/add";
  static const String apiEndpointGetChoreById = "chores";
  static const String apiEndpointGetUsersChores = "chores?userId=";
  static const String apiEndpointGetHouseholdChores = "chores/householdChores";
  static const String apiEndpointGetHouseholdUnverifiedChores =
      "chores/householdChores/unverified";
  static const String apiEndpointUpdateChore = "chores/update";
  static const String apiEndpointMarkChoreAsDone = "chores/markAsDone?choreId=";
  static const String apiEndpointVerifyChore = "chores/verify?choreId=";
}
