import 'package:flutter/material.dart';

enum DeadlineStatus { safe, urgent, overdue, completed }

class TaskModel {
  final String id;
  final String title;
  final String course;
  final String description;
  final String imageUrl;
  final DateTime deadline;
  bool isCompleted;
  bool isFavorite;

  TaskModel({
    required this.id,
    required this.title,
    required this.course,
    required this.description,
    this.imageUrl = '',
    required this.deadline,
    this.isCompleted = false,
    this.isFavorite = false,
  });

  TaskModel copyWith({
    String? title,
    String? course,
    String? description,
    String? imageUrl,
    DateTime? deadline,
    bool? isCompleted,
    bool? isFavorite,
  }) {
    return TaskModel(
      id: id,
      title: title ?? this.title,
      course: course ?? this.course,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      deadline: deadline ?? this.deadline,
      isCompleted: isCompleted ?? this.isCompleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  int get daysRemaining {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(deadline.year, deadline.month, deadline.day);
    return due.difference(today).inDays;
  }

  DeadlineStatus get status {
    if (isCompleted) return DeadlineStatus.completed;
    if (daysRemaining < 0) return DeadlineStatus.overdue; // Lewat DL -> Merah
    if (daysRemaining <= 2) return DeadlineStatus.urgent; // Mepet (0-2 hari) -> Kuning
    return DeadlineStatus.safe; // Masih lama (>2 hari) -> Hijau
  }

  Color get statusColor {
    switch (status) {
      case DeadlineStatus.safe:
        return const Color(0xFF059669);
      case DeadlineStatus.urgent:
        return const Color(0xFFD97706);
      case DeadlineStatus.overdue:
        return const Color(0xFFDC2626);
      case DeadlineStatus.completed:
        return const Color(0xFF64748B);
    }
  }

  Color get softBackgroundColor {
    switch (status) {
      case DeadlineStatus.safe:
        return const Color(0xFFECFDF5);
      case DeadlineStatus.urgent:
        return const Color(0xFFFFFBEB);
      case DeadlineStatus.overdue:
        return const Color(0xFFFEF2F2);
      case DeadlineStatus.completed:
        return const Color(0xFFF1F5F9);
    }
  }

  IconData get fallbackIcon {
    switch (status) {
      case DeadlineStatus.safe:
        return Icons.assignment_turned_in_outlined;
      case DeadlineStatus.urgent:
        return Icons.hourglass_bottom_rounded;
      case DeadlineStatus.overdue:
        return Icons.warning_amber_rounded;
      case DeadlineStatus.completed:
        return Icons.task_alt_rounded;
    }
  }

  String get deadlineLabel {
    if (isCompleted) return 'Selesai • Diarsipkan';
    if (daysRemaining < 0) {
      return 'Terlambat ${daysRemaining.abs()} hari';
    } else if (daysRemaining == 0) {
      return 'Deadline Hari Ini';
    } else if (daysRemaining == 1) {
      return 'Besok Deadline';
    } else if (daysRemaining <= 2) {
      return 'Mepet ($daysRemaining hari lagi)';
    } else {
      return 'Aman ($daysRemaining hari lagi)';
    }
  }
}