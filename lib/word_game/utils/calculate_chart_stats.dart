import 'package:shared_preferences/shared_preferences.dart';

// Function to set the chart statistics based on the current game row
Future<void> setChartStats({required int currentRow}) async {
  // Initialize the distribution array with zeros for 6 rows
  List<int> distribution = [0, 0, 0, 0, 0, 0];

  // Retrieve existing stats from SharedPreferences
  List<int> existingStats =
      await getStats() ?? distribution; // Default to zeros if null

  // Check to avoid out of bounds for the currentRow
  if (currentRow > 0 && currentRow <= 6) {
    existingStats[currentRow - 1]++; // Increment the appropriate row
  }

  // Save the updated distribution back to SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('row', currentRow);
  await prefs.setStringList(
      'chart', existingStats.map((e) => e.toString()).toList());
}

// Function to get the chart statistics from SharedPreferences
Future<List<int>?> getStats() async {
  final prefs = await SharedPreferences.getInstance();
  final stats = prefs.getStringList('chart');

  // Return parsed stats or an empty list if null
  if (stats != null) {
    return stats.map((e) => int.parse(e)).toList(); // Parse strings to integers
  } else {
    return [0, 0, 0, 0, 0, 0]; // Return a list of zeros if no stats exist
  }
}
