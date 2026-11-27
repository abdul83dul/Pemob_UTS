import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskProvider extends ChangeNotifier {
  // Daftar tugas dimulai dalam keadaan kosong saat pertama kali diinstal
  final List<TaskModel> _tasks = [];

  String _searchQuery = '';
  String _selectedCourse = 'Semua';
  DeadlineStatus? _selectedStatus; // null = Semua Status, atau safe / urgent / overdue
  bool _showArchive = false;
  bool _onlyFavorite = false;

  String get searchQuery => _searchQuery;
  String get selectedCourse => _selectedCourse;
  DeadlineStatus? get selectedStatus => _selectedStatus;
  bool get showArchive => _showArchive;
  bool get onlyFavorite => _onlyFavorite;

  // READ: Filter berdasarkan Tab Aktif/Arsip, Status Deadline (Aman/Mepet/Lewat DL), Matkul, Pencarian, & Favorit
  List<TaskModel> get filteredTasks {
    return _tasks.where((task) {
      final matchesArchive = task.isCompleted == _showArchive;
      final matchesSearch =
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.course.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCourse =
          _selectedCourse == 'Semua' || task.course == _selectedCourse;
      final matchesFav = !_onlyFavorite || task.isFavorite;

      // Filter status deadline hanya berlaku di tab Tugas Aktif
      final matchesStatus = _showArchive ||
          _selectedStatus == null ||
          task.status == _selectedStatus;

      return matchesArchive &&
          matchesSearch &&
          matchesCourse &&
          matchesFav &&
          matchesStatus;
    }).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
  }

  int get totalCount => _tasks.length;
  int get activeCount => _tasks.where((t) => !t.isCompleted).length;
  int get archivedCount => _tasks.where((t) => t.isCompleted).length;
  double get completionRate => totalCount == 0 ? 0 : archivedCount / totalCount;

  int get overdueCount =>
      _tasks.where((t) => !t.isCompleted && t.status == DeadlineStatus.overdue).length;
  int get urgentCount =>
      _tasks.where((t) => !t.isCompleted && t.status == DeadlineStatus.urgent).length;
  int get safeCount =>
      _tasks.where((t) => !t.isCompleted && t.status == DeadlineStatus.safe).length;

  void setSelectedStatus(DeadlineStatus? status) {
    // Jika menekan status yang sudah aktif, kembalikan ke 'Semua Status'
    if (_selectedStatus == status) {
      _selectedStatus = null;
    } else {
      _selectedStatus = status;
    }
    _showArchive = false; // Otomatis buka tab Tugas Aktif saat memilih filter status DL
    notifyListeners();
  }

  void addTask({
    required String title,
    required String course,
    required String description,
    required DateTime deadline,
    bool isFavorite = false,
  }) {
    final newTask = TaskModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.trim(),
      course: course.trim(),
      description: description.trim().isEmpty
          ? 'Tidak ada catatan tambahan.'
          : description.trim(),
      deadline: deadline,
      isFavorite: isFavorite,
    );
    _tasks.add(newTask);
    _showArchive = false;
    notifyListeners();
  }

  void updateTask({
    required String id,
    required String title,
    required String course,
    required String description,
    required DateTime deadline,
    required bool isFavorite,
  }) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        title: title.trim(),
        course: course.trim(),
        description: description.trim().isEmpty
            ? 'Tidak ada catatan tambahan.'
            : description.trim(),
        deadline: deadline,
        isFavorite: isFavorite,
      );
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCourse(String course) {
    _selectedCourse = course;
    notifyListeners();
  }

  void setShowArchive(bool archive) {
    _showArchive = archive;
    if (archive) {
      _selectedStatus = null; // Reset filter status DL saat melihat arsip
    }
    notifyListeners();
  }

  void toggleOnlyFavorite() {
    _onlyFavorite = !_onlyFavorite;
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      notifyListeners();
    }
  }

  void toggleFavorite(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index].isFavorite = !_tasks[index].isFavorite;
      notifyListeners();
    }
  }
}