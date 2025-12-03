import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mobile_frontend/config/theme/app_colors.dart';
import 'package:mobile_frontend/features/dashboard/domain/entities/encounter.dart' as ent;
import 'package:mobile_frontend/features/dashboard/presentation/bloc/encounter/encounter_bloc.dart';

class SearchEncountersScreen extends StatefulWidget {
  final int learnerId;
  const SearchEncountersScreen({super.key, required this.learnerId});

  @override
  State<SearchEncountersScreen> createState() => _SearchEncountersScreenState();
}

class _SearchEncountersScreenState extends State<SearchEncountersScreen> {
  final TextEditingController _topicController = TextEditingController();
  DateTime? _selectedDate;

  // Datos
  final List<Map<String, dynamic>> _languages = [
    {'id': 1, 'label': 'English', 'icon': '🇬🇧'},
    {'id': 2, 'label': 'Español', 'icon': '🇪🇸'},
    {'id': 3, 'label': 'Français', 'icon': '🇫🇷'},
  ];

  final List<Map<String, dynamic>> _levels = [
    {'id': 1, 'label': 'A1'},
    {'id': 2, 'label': 'A2'},
    {'id': 3, 'label': 'B1'},
    {'id': 4, 'label': 'B2'},
    {'id': 5, 'label': 'C1'},
  ];

  int? _selectedLanguageId;
  int? _selectedLevelId;
  List<ent.Encounter> _results = [];
  int _page = 0;
  final int _size = 10;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  @override
  void dispose() {
    _topicController.dispose();
    super.dispose();
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: kPrimaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      _startSearch();
    }
  }

  void _startSearch() {
    print('🔍 Iniciando búsqueda con:');
    print('  - languageId: $_selectedLanguageId');
    print('  - levelId: $_selectedLevelId');
    print('  - topic: ${_topicController.text}');
    print('  - date: $_selectedDate');

    setState(() {
      _results = [];
      _page = 0;
      _hasMore = true;
    });

    final dateStr = _selectedDate?.toIso8601String().split('T')[0];

    context.read<EncounterBloc>().add(SearchEncountersRequested(
      date: dateStr,
      languageId: _selectedLanguageId,
      cefrLevelId: _selectedLevelId,
      topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
      page: 0,
      size: _size,
    ));
  }

  void _loadMore() {
    if (!_hasMore || _isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    final nextPage = _page + 1;
    final dateStr = _selectedDate?.toIso8601String().split('T')[0];

    context.read<EncounterBloc>().add(SearchEncountersRequested(
      date: dateStr,
      languageId: _selectedLanguageId,
      cefrLevelId: _selectedLevelId,
      topic: _topicController.text.trim().isEmpty ? null : _topicController.text.trim(),
      page: nextPage,
      size: _size,
    ));
  }

  void _clearFilters() {
    setState(() {
      _selectedDate = null;
      _selectedLanguageId = null;
      _selectedLevelId = null;
      _topicController.clear();
      _results = [];
      _page = 0;
      _hasMore = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDefault,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Cabecera
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Explorar Encuentros",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    // Buscador
                    TextField(
                      controller: _topicController,
                      onSubmitted: (_) => _startSearch(),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Buscar por tema (ej. Negocios)',
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.tune, color: kPrimaryBlue),
                          onPressed: _clearFilters,
                          tooltip: "Limpiar filtros",
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filtros horizontales
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Fecha
                    _buildFilterChip(
                      label: _selectedDate == null
                          ? 'Cualquier fecha'
                          : DateFormat('d MMM').format(_selectedDate!),
                      icon: Icons.calendar_today,
                      isSelected: _selectedDate != null,
                      onTap: _pickDate,
                    ),
                    const SizedBox(width: 8),

                    // Idiomas
                    ..._languages.map((lang) {
                      final id = lang['id'] as int?;
                      final label = lang['label'] as String? ?? '';
                      final icon = lang['icon'] as String? ?? '';
                      final isSelected = _selectedLanguageId == id;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterChip(
                          label: "$icon $label",
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedLanguageId = isSelected ? null : id);
                            _startSearch();
                          },
                        ),
                      );
                    }),

                    // Niveles
                    ..._levels.map((lvl) {
                      final id = lvl['id'] as int?;
                      final label = lvl['label'] as String? ?? '';
                      final isSelected = _selectedLevelId == id;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildFilterChip(
                          label: "Nivel $label",
                          isSelected: isSelected,
                          onTap: () {
                            setState(() => _selectedLevelId = isSelected ? null : id);
                            _startSearch();
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            const SliverPadding(padding: EdgeInsets.only(bottom: 16)),

            // Lista de resultados
            BlocConsumer<EncounterBloc, EncounterState>(
              listener: (context, state) {
                print('📱 Estado del BLoC: ${state.runtimeType}');

                if (state is EncounterSearchSuccess) {
                  print('✅ Resultados recibidos: ${state.encounters.length} encounters');

                  if (_isLoadingMore) {
                    setState(() {
                      _results.addAll(state.encounters);
                      _page += 1;
                      _isLoadingMore = false;
                      if (state.encounters.length < _size) _hasMore = false;
                    });
                  } else {
                    setState(() {
                      _results = state.encounters;
                      _page = 0;
                      _hasMore = state.encounters.length >= _size;
                    });
                  }

                  print('📊 Total en pantalla: ${_results.length}');
                }

                if (state is EncounterFailure) {
                  print('❌ Error: ${state.message}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                print('🏗️ Builder ejecutado - Estado: ${state.runtimeType}, Resultados: ${_results.length}');

                if (state is EncounterLoading && _results.isEmpty && !_isLoadingMore) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
                  );
                }

                if (_results.isEmpty && state is! EncounterLoading) {
                  return SliverFillRemaining(
                    child: _buildEmptyState(),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= _results.length) {
                        if (_hasMore && !_isLoadingMore) {
                          // Trigger para cargar más
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _loadMore();
                          });
                        }
                        return _isLoadingMore
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator(color: kPrimaryBlue)),
                              )
                            : const SizedBox.shrink();
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: _buildEncounterCard(_results[index]),
                      );
                    },
                    childCount: _results.length + (_hasMore ? 1 : 0),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    IconData? icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryBlue.withAlpha((0.1 * 255).round()) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? kPrimaryBlue : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: isSelected ? kPrimaryBlue : Colors.grey.shade700),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? kPrimaryBlue : Colors.grey.shade800,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEncounterCard(ent.Encounter encounter) {
    final day = DateFormat('dd').format(encounter.scheduledAt);
    final month = DateFormat('MMM').format(encounter.scheduledAt).toUpperCase();
    final time = DateFormat('HH:mm').format(encounter.scheduledAt);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.03 * 255).round()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // Fecha
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: kPrimaryBlue.withAlpha((0.08 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: kPrimaryBlue)),
                Text(month, style: const TextStyle(fontSize: 10, color: kPrimaryBlue)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(encounter.topic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "${encounter.language} • ${encounter.level}",
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                    ),
                    const Spacer(),
                    Icon(Icons.access_time, size: 14, color: Colors.grey.shade400),
                    const SizedBox(width: 4),
                    Text(time, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          children: const [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text("No encontramos resultados", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}