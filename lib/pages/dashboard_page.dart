import 'package:flutter/material.dart';

import '../widgets/dashboard_tile.dart';
import 'reminders_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void _showComingSoon(
    BuildContext context,
    String section,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$section wird später ergänzt.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 11) {
      return 'Guten Morgen';
    }

    if (hour < 17) {
      return 'Guten Tag';
    }

    return 'Guten Abend';
  }

  String _formatCurrentDate() {
    final now = DateTime.now();

    const weekdays = [
      'Montag',
      'Dienstag',
      'Mittwoch',
      'Donnerstag',
      'Freitag',
      'Samstag',
      'Sonntag',
    ];

    const months = [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];

    final weekday = weekdays[now.weekday - 1];
    final month = months[now.month - 1];

    return '$weekday, ${now.day}. $month ${now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0D12),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                22,
                20,
                22,
                14,
              ),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7357FF),
                            Color(0xFF4A8CFF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, Tom',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _formatCurrentDate(),
                            style: TextStyle(
                              color: Colors.white.withValues(
                                alpha: 0.52,
                              ),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Mitteilungen',
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const RemindersPage(),
                          ),
                        );
                      },
                      style: IconButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF191C24),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(13),
                      ),
                      icon: const Icon(
                        Icons.notifications_none_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                22,
                14,
                22,
                12,
              ),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF25204D),
                        Color(0xFF171A2E),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Deine persönliche Übersicht',
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.65,
                                ),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              'Alles Wichtige an einem Ort.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.15,
                              ),
                            ),
                            const SizedBox(height: 15),
                            FilledButton.icon(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RemindersPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add_alarm_rounded,
                              ),
                              label: const Text(
                                'Erinnerung erstellen',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.dashboard_customize_rounded,
                        color: Color(0xFF9D8CFF),
                        size: 72,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                22,
                16,
                22,
                12,
              ),
              sliver: SliverToBoxAdapter(
                child: Text(
                  'Bereiche',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.92),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                22,
                0,
                22,
                26,
              ),
              sliver: SliverGrid(
                delegate: SliverChildListDelegate(
                  [
                    DashboardTile(
                      title: 'Familie',
                      subtitle: 'Geburtstage und gemeinsame Termine',
                      icon: Icons.family_restroom_rounded,
                      accentColor: const Color(0xFFFF668A),
                      onTap: () {
                        _showComingSoon(context, 'Familie');
                      },
                    ),
                    DashboardTile(
                      title: 'Arbeit',
                      subtitle: 'Aufgaben, Termine und Informationen',
                      icon: Icons.work_outline_rounded,
                      accentColor: const Color(0xFF4A9DFF),
                      onTap: () {
                        _showComingSoon(context, 'Arbeit');
                      },
                    ),
                    DashboardTile(
                      title: 'Feuerwehr',
                      subtitle: 'Dienste, Technik und Organisation',
                      icon:
                          Icons.local_fire_department_rounded,
                      accentColor: const Color(0xFFFF6A4B),
                      onTap: () {
                        _showComingSoon(context, 'Feuerwehr');
                      },
                    ),
                    DashboardTile(
                      title: 'Kalender',
                      subtitle: 'Alle anstehenden Termine',
                      icon: Icons.calendar_month_rounded,
                      accentColor: const Color(0xFF37D6A3),
                      onTap: () {
                        _showComingSoon(context, 'Kalender');
                      },
                    ),
                    DashboardTile(
                      title: 'Erinnerungen',
                      subtitle: 'Persönliche Hinweise planen',
                      icon: Icons.notifications_active_rounded,
                      accentColor: const Color(0xFFFFC857),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const RemindersPage(),
                          ),
                        );
                      },
                    ),
                    DashboardTile(
                      title: 'Einstellungen',
                      subtitle: 'FTee individuell anpassen',
                      icon: Icons.tune_rounded,
                      accentColor: const Color(0xFFA477FF),
                      onTap: () {
                        _showComingSoon(
                          context,
                          'Einstellungen',
                        );
                      },
                    ),
                  ],
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 0.88,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}