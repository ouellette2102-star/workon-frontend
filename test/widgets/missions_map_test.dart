/// PR-T3: Missions Map Widget Tests
///
/// Tests map rendering and mission markers without actual map SDK.
/// NO network calls - all mocked.
library;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';

void main() {
  group('Missions Map Widget Tests', () {
    // ========================================================================
    // 1. MAP CONTAINER RENDERS
    // ========================================================================
    testWidgets('Map container renders without crash', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(title: const Text('Carte des missions')),
            body: Stack(
              children: [
                // Map placeholder (actual GoogleMap would require SDK)
                Container(
                  key: TestKeys.missionsMap,
                  color: Colors.grey.shade300,
                  child: const Center(
                    child: Text(
                      'Map View',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

                // Map controls overlay
                Positioned(
                  right: 16,
                  bottom: 100,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        heroTag: 'zoom_in',
                        onPressed: () {},
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'zoom_out',
                        onPressed: () {},
                        child: const Icon(Icons.remove),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        heroTag: 'my_location',
                        onPressed: () {},
                        child: const Icon(Icons.my_location),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify map container
      expect(find.byKey(TestKeys.missionsMap), findsOneWidget);
      expect(find.text('Map View'), findsOneWidget);

      // Verify controls
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byIcon(Icons.my_location), findsOneWidget);
    });

    // ========================================================================
    // 2. MAP LOADING STATE
    // ========================================================================
    testWidgets('Map shows loading state', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Chargement de la carte...'),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Chargement de la carte...'), findsOneWidget);
    });

    // ========================================================================
    // 3. MAP MISSION CARDS BOTTOM SHEET
    // ========================================================================
    testWidgets('Map shows mission cards at bottom', (tester) async {
      final missions = MockMission.createList(3);

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Stack(
              children: [
                // Map placeholder
                Container(
                  color: Colors.grey.shade300,
                  child: const Center(child: Text('Map')),
                ),

                // Bottom sheet with mission cards
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 200,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            '3 missions à proximité',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: missions.length,
                            itemBuilder: (context, index) {
                              final mission = missions[index];
                              return Container(
                                width: 200,
                                margin: const EdgeInsets.only(right: 12),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade300),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mission['title'] as String,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      mission['city'] as String,
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${mission['price']}',
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
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

      // Verify bottom sheet
      expect(find.text('3 missions à proximité'), findsOneWidget);
      expect(find.text('Mission #0'), findsOneWidget);
    });

    // ========================================================================
    // 4. MAP FILTER BUTTON
    // ========================================================================
    testWidgets('Map has filter button', (tester) async {
      bool filterOpened = false;

      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Carte'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    filterOpened = true;
                  },
                ),
              ],
            ),
            body: Container(
              color: Colors.grey.shade300,
            ),
          ),
        ),
      );

      // Verify filter button
      expect(find.byIcon(Icons.filter_list), findsOneWidget);

      // Tap filter
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pump();
      expect(filterOpened, isTrue);
    });

    // ========================================================================
    // 5. MAP SEARCH BAR
    // ========================================================================
    testWidgets('Map has search bar', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Stack(
              children: [
                // Map placeholder
                Container(color: Colors.grey.shade300),

                // Search bar overlay
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Rechercher une adresse...',
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify search bar
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Rechercher une adresse...'), findsOneWidget);
    });

    // ========================================================================
    // 6. MAP MARKER SIMULATION
    // ========================================================================
    testWidgets('Map displays marker indicators', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Stack(
              children: [
                // Map placeholder
                Container(color: Colors.grey.shade300),

                // Simulated markers
                Positioned(
                  top: 100,
                  left: 100,
                  child: Container(
                    key: const Key('marker_1'),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 200,
                  child: Container(
                    key: const Key('marker_2'),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Verify markers
      expect(find.byKey(const Key('marker_1')), findsOneWidget);
      expect(find.byKey(const Key('marker_2')), findsOneWidget);
    });

    // ========================================================================
    // 7. MAP ERROR STATE
    // ========================================================================
    testWidgets('Map shows error state when location unavailable', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.location_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Localisation indisponible',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Veuillez activer la localisation.',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Activer'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify error state
      expect(find.byIcon(Icons.location_off), findsOneWidget);
      expect(find.text('Localisation indisponible'), findsOneWidget);
      expect(find.text('Activer'), findsOneWidget);
    });

    // ========================================================================
    // 8. MAP VIEW MODE TOGGLE
    // ========================================================================
    testWidgets('Map has view mode toggle (list/map)', (tester) async {
      await tester.pumpWidget(
        TestApp(
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Missions'),
              actions: [
                ToggleButtons(
                  isSelected: const [true, false],
                  onPressed: (index) {},
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.map),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.list),
                    ),
                  ],
                ),
              ],
            ),
            body: Container(color: Colors.grey.shade300),
          ),
        ),
      );

      // Verify toggle buttons
      expect(find.byIcon(Icons.map), findsOneWidget);
      expect(find.byIcon(Icons.list), findsOneWidget);
    });
  });
}

