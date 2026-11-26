import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../models/schedule.dart';

class ScheduleAddScreen extends StatefulWidget {
  final Schedule? initialSchedule;
  final void Function(
    String title,
    String location,
    String departureLocation,
    DateTime date,
    String startTime,
    int bufferMinutes,
    MobilityMode mobilityMode,
    String memo,
  )
  onSave;
  const ScheduleAddScreen({
    super.key,
    required this.onSave,
    this.initialSchedule,
  });

  @override
  State<ScheduleAddScreen> createState() => _ScheduleAddScreenState();
}

class _ScheduleAddScreenState extends State<ScheduleAddScreen> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _departureController = TextEditingController();
  final _bufferController = TextEditingController();
  final _memoController = TextEditingController();

  int? _selectedBufferMinutes = 10;
  MobilityMode _selectedMobilityMode = MobilityMode.walking;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedStartTime = const TimeOfDay(hour: 9, minute: 0);

  // [핫픽스 2] 로딩 상태 관리 변수 (중복 클릭 및 연타 방어용)
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final schedule = widget.initialSchedule;

    if (schedule != null) {
      _titleController.text = schedule.title;
      _locationController.text = schedule.location;
      _departureController.text = schedule.departureLocation;

      _selectedDate = schedule.date;

      final timeParts = schedule.startTime.split(':');
      if (timeParts.length == 2) {
        _selectedStartTime = TimeOfDay(
          hour: int.tryParse(timeParts[0]) ?? 9,
          minute: int.tryParse(timeParts[1]) ?? 0,
        );
      }

      _selectedBufferMinutes = schedule.bufferMinutes;
      _selectedMobilityMode = schedule.mobilityMode;
      _memoController.text = schedule.memo;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _departureController.dispose();
    _bufferController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: OnTimeColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedStartTime,
    );

    if (picked != null) {
      setState(() {
        _selectedStartTime = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.'
        '${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }

  InputDecoration _inputDecoration({required String hintText, IconData? icon}) {
    return InputDecoration(
      hintText: hintText,
      prefixIcon: icon == null ? null : Icon(icon),
    );
  }

  // [핫픽스 1 & 2 통합] 공백 방어 및 로딩 스피너 저장 처리 함수
  Future<void> _handleSave() async {
    if (_isSaving) return; // 이미 저장 중이면 연타 차단

    final title = _titleController.text.trim();
    final location = _locationController.text.trim();
    final departure = _departureController.text.trim();
    final bufferMinutes =
        _selectedBufferMinutes ??
        (int.tryParse(_bufferController.text.trim()) ?? 0);
    final memo = _memoController.text.trim();

    // 1. 공백 입력 방어 (.trim() 후 빈 문자열인지 검사)
    if (title.isEmpty || location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ 일정 이름과 장소를 모두 입력해 주세요! (공백만 입력 불가)'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      return; // 저장 중단
    }

    // 2. 로딩 스피너 활성화 (버튼 비활성화 및 빙글빙글 아이콘 표시)
    setState(() {
      _isSaving = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 400));

      widget.onSave(
        title,
        location,
        departure,
        _selectedDate,
        _formatTime(_selectedStartTime),
        bufferMinutes,
        _selectedMobilityMode,
        memo,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnTimeColors.background,
      appBar: AppBar(
        title: Text(
          widget.initialSchedule == null ? '일정 등록' : '일정 수정',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: OnTimeColors.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.initialSchedule == null
                    ? '새로운 일정을 등록해주세요.'
                    : '기존 일정을 원하는 내용으로 수정해주세요.',
                style: const TextStyle(
                  fontSize: 15,
                  color: OnTimeColors.darkBrown,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '일정 이름',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                maxLength: 30, // [핫픽스 3] 극단적 장문 폭탄 방어 (최대 30자)
                decoration: _inputDecoration(
                  hintText: '예: 데이터베이스 수업',
                  icon: Icons.event_note_outlined,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '장소',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                maxLength: 50, // [핫픽스 3] 극단적 장문 폭탄 방어 (최대 50자)
                decoration: _inputDecoration(
                  hintText: '예: 공학관 301호',
                  icon: Icons.location_on_outlined,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '일정 날짜',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),

              _SelectionTile(
                icon: Icons.calendar_today_outlined,
                value: _formatDate(_selectedDate),
                onTap: _selectDate,
              ),

              const SizedBox(height: 16),

              const Text(
                '수업 시작시간',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),

              _SelectionTile(
                icon: Icons.schedule,
                value: _formatTime(_selectedStartTime),
                onTap: _selectStartTime,
              ),

              const SizedBox(height: 16),

              const Text(
                '출발지',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _departureController,
                maxLength: 50, // [핫픽스 3] 극단적 장문 폭탄 방어 (최대 50자)
                decoration: _inputDecoration(
                  hintText: '예: 현재 위치 또는 집 주소',
                  icon: Icons.trip_origin,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '목적지',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),

              const SizedBox(height: 16),

              const Text(
                '여유 시간',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final minutes in [5, 10, 15, 20])
                    ChoiceChip(
                      label: Text('$minutes분'),
                      selected: _selectedBufferMinutes == minutes,
                      onSelected: (_) {
                        setState(() {
                          _selectedBufferMinutes = minutes;
                          _bufferController.clear();
                        });
                      },
                    ),
                  ChoiceChip(
                    label: const Text('직접 입력'),
                    selected: _selectedBufferMinutes == null,
                    onSelected: (_) {
                      setState(() {
                        _selectedBufferMinutes = null;
                      });
                    },
                  ),
                ],
              ),

              if (_selectedBufferMinutes == null) ...[
                const SizedBox(height: 10),
                TextField(
                  controller: _bufferController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration(
                    hintText: '여유 시간을 입력해주세요',
                    icon: Icons.more_time,
                  ).copyWith(suffixText: '분'),
                ),
              ],
              // ==============================
              // 이동수단
              // ==============================

              const SizedBox(height: 16),

              const Text(
                '이동수단',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('🚶 도보'),
                    selected: _selectedMobilityMode == MobilityMode.walking,
                    onSelected: (_) {
                      setState(() {
                        _selectedMobilityMode = MobilityMode.walking;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('🚲 자전거'),
                    selected: _selectedMobilityMode == MobilityMode.bicycle,
                    onSelected: (_) {
                      setState(() {
                        _selectedMobilityMode = MobilityMode.bicycle;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('🛴 킥보드'),
                    selected: _selectedMobilityMode == MobilityMode.kickboard,
                    onSelected: (_) {
                      setState(() {
                        _selectedMobilityMode = MobilityMode.kickboard;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('🚗 자동차'),
                    selected: _selectedMobilityMode == MobilityMode.driving,
                    onSelected: (_) {
                      setState(() {
                        _selectedMobilityMode = MobilityMode.driving;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const Text(
                '메모',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: OnTimeColors.darkBrown,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _memoController,
                maxLines: 4,
                maxLength: 200, // [핫픽스 3] 극단적 장문 폭탄 방어 (최대 200자)
                decoration: _inputDecoration(
                  hintText: '필요한 내용을 입력해주세요.',
                  icon: Icons.notes_outlined,
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // 로딩 중(_isSaving == true)일 때는 버튼 클릭 비활성화(null)
                  onPressed: _isSaving ? null : _handleSave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: OnTimeColors.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: OnTimeColors.primary.withOpacity(0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isSaving
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              '저장 중...',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          widget.initialSchedule == null ? '일정 저장' : '변경사항 저장',
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
  }
}

// ============================================================
// 날짜 / 시간 선택 타일
// ============================================================

class _SelectionTile extends StatelessWidget {
  final IconData icon;
  final String value;
  final VoidCallback onTap;

  const _SelectionTile({
    required this.icon,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: OnTimeColors.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: OnTimeColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: OnTimeColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: OnTimeColors.darkBrown,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
