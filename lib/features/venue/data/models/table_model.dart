// Basado en el TableResource.java 
class TableModel {
  final int id;
  final String tableNumber;
  final int capacity;
  final String tableType;
  final String tableStatus;

  TableModel({
    required this.id,
    required this.tableNumber,
    required this.capacity,
    required this.tableType,
    required this.tableStatus,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      tableNumber: json['tableNumber'],
      capacity: json['capacity'],
      tableType: json['tableType'],
      tableStatus: json['tableStatus'],
    );
  }
}