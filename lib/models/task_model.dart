class TaskModel {
  String? uid;
  String? userId;
  String? nameTask;
  String? note;
  DateTime? startDate;
  DateTime? endDate;
  String? status;
  String? priority;

  TaskModel(
      {this.uid, this.userId, this.nameTask, this.note, this.startDate, this.endDate, this.status, this.priority});

  // receiving data from cloud
  factory TaskModel.fromMap(map) {
    return TaskModel(
      uid: map["uid"],
      userId: map["userId"],
      nameTask: map["nameTask"],
      note: map["note"],
      startDate: map["startDate"],
      endDate: map["endDate"],
      status: map["status"],
      priority: map["priority"],
    );
  }

  // sending data to cloud
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'userId': userId,
      'nameTask': nameTask,
      'note': note,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'priority': priority,
    };
  }
}
