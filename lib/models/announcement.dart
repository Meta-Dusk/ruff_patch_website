import 'package:flutter/material.dart';

enum AnnouncementType {
  event(label: 'Event', icon: Icons.event, color: Colors.amber),
  update(label: 'Update', icon: Icons.campaign, color: Colors.blue),
  advisory(
    label: 'Advisory',
    icon: Icons.health_and_safety,
    color: Colors.orange,
  ),
  community(
    label: 'Community',
    icon: Icons.volunteer_activism,
    color: Colors.pink,
  );

  final String label;
  final IconData icon;
  final MaterialColor color;

  const AnnouncementType({
    required this.label,
    required this.icon,
    required this.color,
  });
}

class Announcement {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String date;
  final AnnouncementType type;
  final bool isPinned;
  final String? actionLabel;
  final String? actionRoute;

  const Announcement({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.date,
    required this.type,
    this.isPinned = false,
    this.actionLabel,
    this.actionRoute,
  });

  static const List<Announcement> sampleAnnouncements = [
    Announcement(
      id: 'ann-1',
      title: 'City-Wide Free Spay & Neuter Mission Scheduled',
      summary:
          'Free spay and neuter services will be held across select Metro '
          'Manila veterinary offices this upcoming weekend.',
      content:
          'In cooperation with local city veterinary offices, a free spay and '
          'neuter (kapon) mission is scheduled this month. Stray dog '
          'advocates, rescuers, and pet owners are encouraged to book slots '
          'early. Check out our Local Neutering section in Resources for '
          'direct registration links and participating venues.',
      date: 'Oct 28, 2026',
      type: AnnouncementType.event,
      isPinned: true,
      actionLabel: 'View Neutering Info',
      actionRoute: '/resources',
    ),
    Announcement(
      id: 'ann-2',
      title: 'New Chapter Coming: Post-Rescue & Stray Rehabilitation',
      summary:
          'We are expanding our curriculum with practical guides on rescuing, '
          'quarantining, and rehabilitating community stray dogs.',
      content:
          'Thanks to community feedback, our upcoming module chapter will '
          'cover first response for injured strays, parasite management, '
          'behavioral rehabilitation, and preparing rescued dogs for adoption. '
          'Stay tuned for the interactive quiz!',
      date: 'Oct 24, 2026',
      type: AnnouncementType.update,
      actionLabel: 'Browse Modules',
      actionRoute: '/modules',
    ),
    Announcement(
      id: 'ann-3',
      title: 'Rabies Awareness & Vaccination Advisory',
      summary:
          'Keep your pets and community safe by taking advantage of nationwide '
          'local government free anti-rabies drives.',
      content:
          'Rabies remains 100% preventable. LGUs nationwide provide free '
          'anti-rabies shots throughout the year. Remember to keep your pet '
          'vaccinations up to date and report bite incidents immediately to '
          'your nearest health center.',
      date: 'Oct 18, 2026',
      type: AnnouncementType.advisory,
      actionLabel: 'Check Resources',
      actionRoute: '/resources',
    ),
    Announcement(
      id: 'ann-4',
      title: 'Community Adoption Fair This Month',
      summary:
          'Meet rescued aspins and find your newest family member at the '
          'community pet adoption pop-up.',
      content:
          'Local partner shelters are bringing rescued and rehabilitated stray '
          'dogs looking for loving forever homes. Adoption counselors will be '
          'on site to guide prospective pet parents through the adoption '
          'process, home readiness, and essential dog care basics.',
      date: 'Oct 10, 2026',
      type: AnnouncementType.community,
      actionLabel: 'Explore Resources',
      actionRoute: '/resources',
    ),
  ];
}
