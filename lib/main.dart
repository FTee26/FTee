import 'package:flutter/material.dart';

void main() {
  runApp(const FTeeApp());
}

class FTeeApp extends StatelessWidget {
  const FTeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FTee',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF10131A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4C8DFF),
          secondary: Color(0xFF7C5CFF),
          surface: Color(0xFF1A1F2B),
        ),
      ),
      home: const DashboardPage(),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  void showMessage(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title wurde geöffnet'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tiles = [
      DashboardTile(
        title: 'Familie',
        subtitle: 'Gemeinsame Infos',
        icon: Icons.family_restroom,
        color: const Color(0xFFE56AA6),
        onTap: () => showMessage(context, 'Familie'),
      ),
      DashboardTile(
        title: 'Arbeit',
        subtitle: 'Termine und Aufgaben',
        icon: Icons.work_rounded,
        color: const Color(0xFF4C8DFF),
        onTap: () => showMessage(context, 'Arbeit'),
      ),
      DashboardTile(
        title: 'Feuerwehr',
        subtitle: 'Einsatz und Organisation',
        icon: Icons.local_fire_department_rounded,
        color: const Color(0xFFFF6B4A),
        onTap: () => showMessage(context, 'Feuerwehr'),
      ),
      DashboardTile(
        title: 'Kalender',
        subtitle: 'Alle Termine',
        icon: Icons.calendar_month_rounded,
        color: const Color(0xFF35C98F),
        onTap: () => showMessage(context, 'Kalender'),
      ),
      DashboardTile(
        title: 'Einstellungen',
        subtitle: 'FTee anpassen',
        icon: Icons.settings_rounded,
        color: const Color(0xFF9C7CFF),
        onTap: () => showMessage(context, 'Einstellungen'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'FTee',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Deine persönliche Übersicht',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: tiles.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemBuilder: (context, index) => tiles[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF1A1F2B),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: color.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.10),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const Spacer(),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.58),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Öffnen',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: color,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}