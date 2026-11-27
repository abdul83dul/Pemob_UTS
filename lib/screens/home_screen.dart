import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class HomeScreen extends StatefulWidget {
  final TaskProvider provider;

  const HomeScreen({super.key, required this.provider});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showTaskFormModal({TaskModel? existingTask}) {
    final isEditing = existingTask != null;
    final titleCtrl = TextEditingController(text: existingTask?.title ?? '');
    final courseCtrl = TextEditingController(text: existingTask?.course ?? '');
    final descCtrl = TextEditingController(text: existingTask?.description ?? '');
    DateTime selectedDate =
        existingTask?.deadline ?? DateTime.now().add(const Duration(days: 3));
    bool isFavorite = existingTask?.isFavorite ?? false;
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final previewTask = TaskModel(
              id: 'preview',
              title: '',
              course: '',
              description: '',
              deadline: selectedDate,
            );

            return Container(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 4.5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isEditing ? 'Edit Tugas UTS' : 'Tambah Tugas Baru',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setModalState(() => isFavorite = !isFavorite);
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              color: isFavorite
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF94A3B8),
                              size: 26,
                            ),
                            tooltip: 'Tandai Prioritas',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: titleCtrl,
                        decoration: InputDecoration(
                          labelText: 'Judul Tugas',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Judul tugas wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: courseCtrl,
                        decoration: InputDecoration(
                          labelText: 'Mata Kuliah',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Nama mata kuliah wajib diisi'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: descCtrl,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Catatan Tugas',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setModalState(() => selectedDate = picked);
                          }
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: previewTask.softBackgroundColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: previewTask.statusColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_month_rounded,
                                color: previewTask.statusColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tanggal Deadline',
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: Color(0xFF475569),
                                      ),
                                    ),
                                    Text(
                                      '${_formatDate(selectedDate)} (${previewTask.deadlineLabel})',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: previewTask.statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                'Ubah',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E1B4B),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              if (isEditing) {
                                widget.provider.updateTask(
                                  id: existingTask.id,
                                  title: titleCtrl.text,
                                  course: courseCtrl.text,
                                  description: descCtrl.text,
                                  deadline: selectedDate,
                                  isFavorite: isFavorite,
                                );
                              } else {
                                widget.provider.addTask(
                                  title: titleCtrl.text,
                                  course: courseCtrl.text,
                                  description: descCtrl.text,
                                  deadline: selectedDate,
                                  isFavorite: isFavorite,
                                );
                              }
                              Navigator.pop(context);
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isEditing
                                        ? 'Tugas berhasil diperbarui'
                                        : 'Tugas baru berhasil ditambahkan',
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1B4B),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          icon: Icon(isEditing ? Icons.save_rounded : Icons.add_rounded),
                          label: Text(
                            isEditing ? 'Simpan Perubahan' : 'Simpan Tugas',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(TaskModel task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Hapus Tugas?'),
        content: Text('Tugas "${task.title}" akan dihapus dari daftar lokal.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.provider.deleteTask(task.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tugas telah dihapus'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        final tasks = widget.provider.filteredTasks;

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6FA),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showTaskFormModal(),
            backgroundColor: const Color(0xFF1E1B4B),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Tambah Tugas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _buildHeroHeader(),

                // Search Bar & Filter Favorit
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: widget.provider.setSearchQuery,
                            style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                            decoration: InputDecoration(
                              hintText: 'Cari judul tugas atau mata kuliah...',
                              hintStyle: const TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 13.5,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: Color(0xFF64748B),
                                size: 20,
                              ),
                              suffixIcon: widget.provider.searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close_rounded, size: 18),
                                      onPressed: () {
                                        _searchController.clear();
                                        widget.provider.setSearchQuery('');
                                      },
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: widget.provider.toggleOnlyFavorite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 46,
                          width: 46,
                          decoration: BoxDecoration(
                            color: widget.provider.onlyFavorite
                                ? const Color(0xFFFEF3C7)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: widget.provider.onlyFavorite
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFFE2E8F0),
                              width: 1.3,
                            ),
                          ),
                          child: Icon(
                            widget.provider.onlyFavorite
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: widget.provider.onlyFavorite
                                ? const Color(0xFFD97706)
                                : const Color(0xFF64748B),
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Segmented Tab: Tugas Aktif vs Arsip Selesai
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0).withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildSegmentTab(
                            title: 'Tugas Aktif',
                            count: widget.provider.activeCount,
                            icon: Icons.assignment_outlined,
                            isSelected: !widget.provider.showArchive,
                            onTap: () => widget.provider.setShowArchive(false),
                          ),
                        ),
                        Expanded(
                          child: _buildSegmentTab(
                            title: 'Arsip Selesai',
                            count: widget.provider.archivedCount,
                            icon: Icons.inventory_2_outlined,
                            isSelected: widget.provider.showArchive,
                            onTap: () => widget.provider.setShowArchive(true),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // BAR SORTIR / FILTER STATUS DEADLINE (Semua, Lewat DL, Mepet, Aman)
                if (!widget.provider.showArchive) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 36,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildDeadlineFilterChip(
                          label: 'Semua Status',
                          status: null,
                          activeColor: const Color(0xFF1E1B4B),
                        ),
                        const SizedBox(width: 8),
                        _buildDeadlineFilterChip(
                          label: 'Lewat DL (${widget.provider.overdueCount})',
                          status: DeadlineStatus.overdue,
                          activeColor: const Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 8),
                        _buildDeadlineFilterChip(
                          label: 'Mepet (${widget.provider.urgentCount})',
                          status: DeadlineStatus.urgent,
                          activeColor: const Color(0xFFD97706),
                        ),
                        const SizedBox(width: 8),
                        _buildDeadlineFilterChip(
                          label: 'Aman (${widget.provider.safeCount})',
                          status: DeadlineStatus.safe,
                          activeColor: const Color(0xFF059669),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 10),

                // Daftar Tugas (Vertical ListView)
                Expanded(
                  child: tasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(18, 2, 18, 86),
                          itemCount: tasks.length,
                          itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDeadlineFilterChip({
    required String label,
    required DeadlineStatus? status,
    required Color activeColor,
  }) {
    final isSelected = widget.provider.selectedStatus == status;

    return GestureDetector(
      onTap: () => widget.provider.setSelectedStatus(status),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? activeColor : activeColor.withValues(alpha: 0.4),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (status != null) ...[
              Container(
                width: 7.5,
                height: 7.5,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : activeColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    final percent = (widget.provider.completionRate * 100).round();

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 12, 18, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1B4B), Color(0xFF312E81), Color(0xFF4338CA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF312E81).withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -25,
            top: -30,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tugas UTS Ku',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Catat deadline & kelola arsip tugas kuliahmu',
                            style: TextStyle(
                              color: Color(0xFFC7D2FE),
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: CircularProgressIndicator(
                            value: widget.provider.completionRate,
                            strokeWidth: 4.5,
                            backgroundColor: Colors.white.withValues(alpha: 0.18),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF34D399),
                            ),
                          ),
                        ),
                        Text(
                          '$percent%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                // 3 Kartu Status di Header (Bisa diklik untuk langsung sortir)
                Row(
                  children: [
                    _buildStatusChip(
                      label: 'Aman',
                      count: widget.provider.safeCount,
                      dotColor: const Color(0xFF34D399),
                      status: DeadlineStatus.safe,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      label: 'Mepet',
                      count: widget.provider.urgentCount,
                      dotColor: const Color(0xFFFBBF24),
                      status: DeadlineStatus.urgent,
                    ),
                    const SizedBox(width: 8),
                    _buildStatusChip(
                      label: 'Lewat DL',
                      count: widget.provider.overdueCount,
                      dotColor: const Color(0xFFF87171),
                      status: DeadlineStatus.overdue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip({
    required String label,
    required int count,
    required Color dotColor,
    required DeadlineStatus status,
  }) {
    final isSelected = widget.provider.selectedStatus == status;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.provider.setSelectedStatus(status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.26)
                : Colors.white.withValues(alpha: 0.11),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.14),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  '$label ($count)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSegmentTab({
    required String title,
    required int count,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF1E1B4B) : const Color(0xFF64748B),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF1E1B4B) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF1E1B4B)
                    : const Color(0xFFCBD5E1).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xFF475569),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(
            color: task.statusColor.withValues(alpha: 0.35),
            width: 1.4,
          ),
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 6,
                decoration: BoxDecoration(
                  color: task.statusColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(17),
                    bottomLeft: Radius.circular(17),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: task.imageUrl.isNotEmpty
                          ? Image.network(
                              task.imageUrl,
                              width: 68,
                              height: 88,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildFallbackArtwork(task),
                            )
                          : _buildFallbackArtwork(task),
                    ),
                    if (task.isCompleted)
                      Container(
                        width: 68,
                        height: 88,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F172A).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Text(
                                task.course,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF334155),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          InkWell(
                            onTap: () => widget.provider.toggleFavorite(task.id),
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                task.isFavorite
                                    ? Icons.star_rounded
                                    : Icons.star_outline_rounded,
                                size: 20,
                                color: task.isFavorite
                                    ? const Color(0xFFF59E0B)
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _showTaskFormModal(existingTask: task),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 18,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => _confirmDelete(task),
                            child: const Padding(
                              padding: EdgeInsets.all(2),
                              child: Icon(
                                Icons.delete_outline_rounded,
                                size: 19,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        task.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          decoration:
                              task.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: task.softBackgroundColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.event_available_rounded,
                                    size: 13,
                                    color: task.statusColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${_formatDate(task.deadline)} • ${task.deadlineLabel}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: task.statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              widget.provider.toggleTaskCompletion(task.id);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    task.isCompleted
                                        ? 'Tugas dipindahkan ke Arsip Selesai'
                                        : 'Tugas dikembalikan ke Daftar Aktif',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: task.isCompleted
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFF059669),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    task.isCompleted
                                        ? Icons.undo_rounded
                                        : Icons.check_rounded,
                                    size: 14,
                                    color: task.isCompleted
                                        ? const Color(0xFF475569)
                                        : Colors.white,
                                  ),
                                  const SizedBox(width: 3),
                                  Text(
                                    task.isCompleted ? 'Pulihkan' : 'Selesai',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: task.isCompleted
                                          ? const Color(0xFF475569)
                                          : Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackArtwork(TaskModel task) {
    return Container(
      width: 68,
      height: 88,
      decoration: BoxDecoration(
        color: task.softBackgroundColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: task.statusColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(task.fallbackIcon, color: task.statusColor, size: 28),
          const SizedBox(height: 4),
          Text(
            task.isCompleted ? 'ARSIP' : 'TUGAS',
            style: TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: task.statusColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String emptyTitle = 'Belum ada tugas di Tugas UTS Ku';
    String emptySub =
        'Tekan tombol "+ Tambah Tugas" di kanan bawah untuk mencatat tugas kuliah secara manual.';

    if (widget.provider.showArchive) {
      emptyTitle = 'Arsip tugas selesai masih kosong';
      emptySub =
          'Centang tombol "Selesai" pada tugas aktif untuk mengarsipkannya di sini.';
    } else if (widget.provider.selectedStatus != null) {
      emptyTitle = 'Tidak ada tugas pada kategori status ini';
      emptySub = 'Pilih "Semua Status" untuk menampilkan seluruh tugas aktif.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                widget.provider.showArchive
                    ? Icons.inventory_2_outlined
                    : Icons.note_add_outlined,
                size: 48,
                color: const Color(0xFF4338CA),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              emptyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              emptySub,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}