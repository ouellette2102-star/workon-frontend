import '/client_part/components_client/filter_options/filter_options_widget.dart';
import '/config/ui_tokens.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/services/missions/mission_models.dart';
import '/services/missions/missions_api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// PR-09: Real search results widget with backend query + filters.
class SearchResultsRealWidget extends StatefulWidget {
  const SearchResultsRealWidget({
    super.key,
    this.initialQuery,
    this.category,
  });

  /// Initial search query from search screen.
  final String? initialQuery;

  /// Category filter (e.g., "Cleaning", "Plumbing").
  final String? category;

  static String routeName = 'SearchResultsReal';
  static String routePath = '/searchResultsReal';

  @override
  State<SearchResultsRealWidget> createState() => _SearchResultsRealWidgetState();
}

class _SearchResultsRealWidgetState extends State<SearchResultsRealWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _api = MissionsApi();
  late TextEditingController _searchController;
  final _searchFocusNode = FocusNode();

  List<Mission> _missions = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Filter state
  String? _selectedCategory;
  String? _selectedSort;
  double _radiusKm = 50;

  // Default location (can be updated with real location)
  double _latitude = 45.5017;  // Montreal default
  double _longitude = -73.5673;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _selectedCategory = widget.category;
    _loadMissions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadMissions() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final query = _searchController.text.trim();
      
      final missions = await _api.fetchNearby(
        latitude: _latitude,
        longitude: _longitude,
        radiusKm: _radiusKm,
        query: query.isNotEmpty ? query : null,
        category: _selectedCategory,
        sort: _selectedSort,
      );

      if (!mounted) return;

      setState(() {
        _missions = missions;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('[SearchResults] Error loading missions: $e');
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _errorMessage = e is MissionsApiException
            ? e.message
            : WkCopy.errorGeneric;
      });
    }
  }

  void _onSearch() {
    _loadMissions();
  }

  void _showFilters() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      context: context,
      builder: (context) => _buildFiltersSheet(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.all(WkSpacing.pagePadding),
                child: Row(
                  children: [
                    // Back button
                    FlutterFlowIconButton(
                      borderRadius: 12.0,
                      buttonSize: 44.0,
                      fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 20.0,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    SizedBox(width: WkSpacing.sm),
                    // Search field
                    Expanded(
                      child: Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          TextFormField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            onFieldSubmitted: (_) => _onSearch(),
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: 'Rechercher...',
                              hintStyle: FlutterFlowTheme.of(context)
                                  .labelMedium
                                  .override(
                                    fontFamily: 'General Sans',
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                  ),
                              filled: true,
                              fillColor: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20,
                              ),
                              suffixIcon: Padding(
                                padding: EdgeInsets.only(right: 45),
                                child: _searchController.text.isNotEmpty
                                    ? IconButton(
                                        icon: Icon(Icons.close, size: 20),
                                        onPressed: () {
                                          _searchController.clear();
                                          _loadMissions();
                                        },
                                      )
                                    : null,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'General Sans',
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          // Filter button
                          Padding(
                            padding: EdgeInsets.only(right: 5),
                            child: FlutterFlowIconButton(
                              borderRadius: 12.0,
                              buttonSize: 40.0,
                              fillColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              icon: Icon(
                                Icons.tune,
                                color: FlutterFlowTheme.of(context).primaryText,
                                size: 20.0,
                              ),
                              onPressed: _showFilters,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Results header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: WkSpacing.pagePadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'General Sans',
                                letterSpacing: 0.0,
                              ),
                          children: [
                            TextSpan(text: 'Résultats'),
                            if (_searchController.text.isNotEmpty) ...[
                              TextSpan(text: ' pour "'),
                              TextSpan(
                                text: _searchController.text,
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              TextSpan(text: '"'),
                            ],
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '${_missions.length} trouvé${_missions.length > 1 ? 's' : ''}',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).primary,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ),

              // Active filters chips
              if (_selectedCategory != null || _selectedSort != null)
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    WkSpacing.pagePadding,
                    WkSpacing.sm,
                    WkSpacing.pagePadding,
                    0,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (_selectedCategory != null)
                          _buildFilterChip(
                            label: _selectedCategory!,
                            onRemove: () {
                              setState(() => _selectedCategory = null);
                              _loadMissions();
                            },
                          ),
                        if (_selectedSort != null)
                          _buildFilterChip(
                            label: _getSortLabel(_selectedSort!),
                            onRemove: () {
                              setState(() => _selectedSort = null);
                              _loadMissions();
                            },
                          ),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: WkSpacing.md),

              // Results list
              Expanded(
                child: _isLoading
                    ? _buildLoadingState(context)
                    : _errorMessage != null
                        ? _buildErrorState(context)
                        : _missions.isEmpty
                            ? _buildEmptyState(context)
                            : _buildResultsList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Padding(
      padding: EdgeInsets.only(right: WkSpacing.sm),
      child: Chip(
        label: Text(label),
        deleteIcon: Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
        labelStyle: TextStyle(
          color: FlutterFlowTheme.of(context).primary,
          fontSize: 12,
        ),
        deleteIconColor: FlutterFlowTheme.of(context).primary,
      ),
    );
  }

  String _getSortLabel(String sort) {
    switch (sort) {
      case 'price_asc':
        return 'Prix ↑';
      case 'price_desc':
        return 'Prix ↓';
      case 'newest':
        return 'Plus récent';
      case 'proximity':
        return 'Distance';
      default:
        return sort;
    }
  }

  Widget _buildLoadingState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: FlutterFlowTheme.of(context).primary,
          ),
          SizedBox(height: WkSpacing.lg),
          Text(
            WkCopy.loading,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'General Sans',
                  color: FlutterFlowTheme.of(context).secondaryText,
                  letterSpacing: 0.0,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: WkStatusColors.cancelled,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              _errorMessage ?? WkCopy.errorGeneric,
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyLarge.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            ElevatedButton.icon(
              onPressed: _loadMissions,
              icon: const Icon(Icons.refresh),
              label: Text(WkCopy.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).primary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: FlutterFlowTheme.of(context).secondaryText,
            ),
            SizedBox(height: WkSpacing.lg),
            Text(
              'Aucun résultat',
              style: FlutterFlowTheme.of(context).headlineSmall.override(
                    fontFamily: 'General Sans',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.sm),
            Text(
              'Essayez avec d\'autres mots-clés ou modifiez les filtres.',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'General Sans',
                    color: FlutterFlowTheme.of(context).secondaryText,
                    letterSpacing: 0.0,
                  ),
            ),
            SizedBox(height: WkSpacing.xl),
            OutlinedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = null;
                  _selectedSort = null;
                });
                _loadMissions();
              },
              icon: const Icon(Icons.clear_all),
              label: Text('Effacer les filtres'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadMissions,
      color: FlutterFlowTheme.of(context).primary,
      child: GridView.builder(
        padding: EdgeInsets.all(WkSpacing.pagePadding),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: WkSpacing.md,
          mainAxisSpacing: WkSpacing.md,
          childAspectRatio: 0.75,
        ),
        itemCount: _missions.length,
        itemBuilder: (context, index) {
          final mission = _missions[index];
          return _buildMissionCard(context, mission);
        },
      ),
    );
  }

  Widget _buildMissionCard(BuildContext context, Mission mission) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          'MissionDetail',
          pathParameters: {'missionId': mission.id},
          extra: {'mission': mission},
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(WkRadius.md),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(WkRadius.md),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.work_outline,
                  size: 40,
                  color: FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(WkSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mission.title,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'General Sans',
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.0,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: WkSpacing.xs),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: FlutterFlowTheme.of(context).secondaryText,
                        ),
                        SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            mission.city.isNotEmpty
                                ? mission.city
                                : 'Non spécifié',
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'General Sans',
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryText,
                                  fontSize: 11,
                                  letterSpacing: 0.0,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      '\$${mission.price.toStringAsFixed(0)}',
                      style: FlutterFlowTheme.of(context).titleSmall.override(
                            fontFamily: 'General Sans',
                            color: FlutterFlowTheme.of(context).primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(WkSpacing.pagePadding),
            child: Row(
              children: [
                FlutterFlowIconButton(
                  borderRadius: 12,
                  buttonSize: 40,
                  fillColor: FlutterFlowTheme.of(context).secondaryBackground,
                  icon: Icon(
                    Icons.close,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 22,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: WkSpacing.md),
                Text(
                  'Filtres',
                  style: FlutterFlowTheme.of(context).titleMedium.override(
                        fontFamily: 'General Sans',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.0,
                      ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _selectedSort = null;
                      _radiusKm = 50;
                    });
                  },
                  child: Text('Réinitialiser'),
                ),
              ],
            ),
          ),
          Divider(height: 1),

          // Filters content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(WkSpacing.pagePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sort
                  Text(
                    'Trier par',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: WkSpacing.sm),
                  Wrap(
                    spacing: WkSpacing.sm,
                    runSpacing: WkSpacing.sm,
                    children: [
                      _buildSortChip('proximity', 'Distance'),
                      _buildSortChip('newest', 'Plus récent'),
                      _buildSortChip('price_asc', 'Prix ↑'),
                      _buildSortChip('price_desc', 'Prix ↓'),
                    ],
                  ),
                  SizedBox(height: WkSpacing.xl),

                  // Categories
                  Text(
                    'Catégorie',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  SizedBox(height: WkSpacing.sm),
                  Wrap(
                    spacing: WkSpacing.sm,
                    runSpacing: WkSpacing.sm,
                    children: [
                      _buildCategoryChip('Cleaning'),
                      _buildCategoryChip('Plumbing'),
                      _buildCategoryChip('Electrical'),
                      _buildCategoryChip('Moving'),
                      _buildCategoryChip('Gardening'),
                      _buildCategoryChip('Painting'),
                    ],
                  ),
                  SizedBox(height: WkSpacing.xl),

                  // Radius
                  Text(
                    'Rayon: ${_radiusKm.toInt()} km',
                    style: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'General Sans',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.0,
                        ),
                  ),
                  Slider(
                    value: _radiusKm,
                    min: 5,
                    max: 100,
                    divisions: 19,
                    activeColor: FlutterFlowTheme.of(context).primary,
                    onChanged: (value) {
                      setState(() => _radiusKm = value);
                    },
                  ),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.all(WkSpacing.pagePadding),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _loadMissions();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Appliquer les filtres',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String value, String label) {
    final isSelected = _selectedSort == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedSort = selected ? value : null;
        });
      },
      selectedColor: FlutterFlowTheme.of(context).primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }

  Widget _buildCategoryChip(String category) {
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(category),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = selected ? category : null;
        });
      },
      selectedColor: FlutterFlowTheme.of(context).primary,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : FlutterFlowTheme.of(context).primaryText,
      ),
    );
  }
}

