import '../models/enterprise.dart';
import '../models/coach.dart';
import '../models/assessment.dart';
import '../models/session.dart';

class SeedData {
  static List<Coach> coaches = [
    Coach(
      id: 'c001',
      name: 'Abebe Kebede',
      email: 'abebe.k@mesmer.et',
      phone: '+251 912 345 678',
      region: 'Addis Ababa - Bole',
      profileImage: 'assets/profiles/abebe.jpg',
      enterprisesCount: 24,
      sessionsThisMonth: 42,
      performanceScore: 94,
      specializations: ['Finance', 'Business Planning'],
    ),
    Coach(
      id: 'c002',
      name: 'Meron Tadesse',
      email: 'meron.t@mesmer.et',
      phone: '+251 923 456 789',
      region: 'Addis Ababa - Kirkos',
      profileImage: 'assets/profiles/meron.jpg',
      enterprisesCount: 21,
      sessionsThisMonth: 38,
      performanceScore: 91,
      specializations: ['Marketing', 'Sales'],
    ),
    Coach(
      id: 'c003',
      name: 'Tekle Berhan',
      email: 'tekle.b@mesmer.et',
      phone: '+251 934 567 890',
      region: 'Oromia - Bishoftu',
      profileImage: 'assets/profiles/tekle.jpg',
      enterprisesCount: 18,
      sessionsThisMonth: 31,
      performanceScore: 87,
      specializations: ['Operations', 'Quality Control'],
    ),
  ];

  static List<Enterprise> enterprises = [
    Enterprise(
      id: 'e001',
      businessName: 'Meron Cafe & Bakery',
      ownerName: 'Meron Tadesse',
      sector: 'Food & Beverage',
      location: 'Bole, Addis Ababa',
      phone: '+251 911 234 567',
      status: 'Active',
      registrationDate: DateTime(2025, 1, 15),
      scores: {
        'finance': 45,
        'marketing': 70,
        'operations': 50,
        'hr': 80,
        'governance': 35,
      },
      priorities: [
        'No bookkeeping system',
        'Expired business license',
        'Oven needs repair',
      ],
      imageUrl: 'assets/enterprises/cafe.jpg',
    ),
    Enterprise(
      id: 'e002',
      businessName: 'Tadesse General Store',
      ownerName: 'Tadesse Wolde',
      sector: 'Retail',
      location: 'Kirkos, Addis Ababa',
      phone: '+251 922 345 678',
      status: 'Active',
      registrationDate: DateTime(2025, 1, 22),
      scores: {
        'finance': 65,
        'marketing': 45,
        'operations': 70,
        'hr': 40,
        'governance': 55,
      },
      priorities: [
        'No digital marketing',
        'Staff training needed',
        'Inventory management',
      ],
      imageUrl: 'assets/enterprises/store.jpg',
    ),
    Enterprise(
      id: 'e003',
      businessName: 'Zenash Tailoring',
      ownerName: 'Zenash Haile',
      sector: 'Garment',
      location: 'Bishoftu, Oromia',
      phone: '+251 933 456 789',
      status: 'Active',
      registrationDate: DateTime(2025, 2, 5),
      scores: {
        'finance': 80,
        'marketing': 60,
        'operations': 75,
        'hr': 85,
        'governance': 70,
      },
      priorities: [
        'Expand customer base',
        'New sewing machines',
        'Social media presence',
      ],
      imageUrl: 'assets/enterprises/tailor.jpg',
    ),
    Enterprise(
      id: 'e004',
      businessName: 'Birhanu Farms',
      ownerName: 'Birhanu Alemu',
      sector: 'Agriculture',
      location: 'Sebeta, Oromia',
      phone: '+251 944 567 890',
      status: 'Graduated',
      registrationDate: DateTime(2024, 11, 10),
      scores: {
        'finance': 90,
        'marketing': 75,
        'operations': 85,
        'hr': 70,
        'governance': 80,
      },
      priorities: [
        'Export certification',
        'Irrigation system',
      ],
      imageUrl: 'assets/enterprises/farm.jpg',
    ),
    Enterprise(
      id: 'e005',
      businessName: 'Future Tech Solutions',
      ownerName: 'Samuel Ayele',
      sector: 'Technology',
      location: 'Piassa, Addis Ababa',
      phone: '+251 955 678 901',
      status: 'Active',
      registrationDate: DateTime(2025, 2, 18),
      scores: {
        'finance': 55,
        'marketing': 80,
        'operations': 60,
        'hr': 45,
        'governance': 50,
      },
      priorities: [
        'Hire more developers',
        'Financial management',
        'Office expansion',
      ],
      imageUrl: 'assets/enterprises/tech.jpg',
    ),
  ];

  static List<Assessment> assessments = [
    Assessment(
      id: 'a001',
      enterpriseId: 'e001',
      enterpriseName: 'Meron Cafe & Bakery',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      date: DateTime(2025, 1, 20),
      type: 'Baseline',
      scores: {
        'finance': 35,
        'marketing': 65,
        'operations': 40,
        'hr': 75,
        'governance': 30,
      },
      strengths: [
        'Good location',
        'Loyal customers',
        'Quality products',
      ],
      weaknesses: [
        'No financial records',
        'License expired',
        'Equipment old',
      ],
      recommendations: [
        'Start bookkeeping training',
        'Renew business license',
        'Repair oven',
      ],
      status: 'Completed',
    ),
    Assessment(
      id: 'a002',
      enterpriseId: 'e001',
      enterpriseName: 'Meron Cafe & Bakery',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      date: DateTime(2025, 3, 15),
      type: 'Quarterly',
      scores: {
        'finance': 45,
        'marketing': 70,
        'operations': 50,
        'hr': 80,
        'governance': 35,
      },
      strengths: [
        'Started bookkeeping',
        'Customer loyalty',
        'Staff retention',
      ],
      weaknesses: [
        'License still expired',
        'Oven issues persist',
        'No online presence',
      ],
      recommendations: [
        'Complete license renewal',
        'Equipment maintenance plan',
        'Create Facebook page',
      ],
      status: 'Completed',
    ),
    Assessment(
      id: 'a003',
      enterpriseId: 'e002',
      enterpriseName: 'Tadesse General Store',
      coachId: 'c002',
      coachName: 'Meron Tadesse',
      date: DateTime(2025, 2, 10),
      type: 'Baseline',
      scores: {
        'finance': 60,
        'marketing': 40,
        'operations': 65,
        'hr': 35,
        'governance': 50,
      },
      strengths: [
        'Good supplier relationships',
        'Reasonable prices',
        'Clean store',
      ],
      weaknesses: [
        'No marketing strategy',
        'Staff untrained',
        'Manual inventory',
      ],
      recommendations: [
        'Basic sales training for staff',
        'Simple loyalty program',
        'Inventory tracking system',
      ],
      status: 'Completed',
    ),
    Assessment(
      id: 'a004',
      enterpriseId: 'e003',
      enterpriseName: 'Zenash Tailoring',
      coachId: 'c003',
      coachName: 'Tekle Berhan',
      date: DateTime(2025, 2, 28),
      type: 'Baseline',
      scores: {
        'finance': 75,
        'marketing': 55,
        'operations': 70,
        'hr': 80,
        'governance': 65,
      },
      strengths: [
        'High quality work',
        'Skilled staff',
        'Good reputation',
      ],
      weaknesses: [
        'Limited customer reach',
        'Old machines',
        'No website',
      ],
      recommendations: [
        'Social media marketing',
        'Equipment upgrade plan',
        'Customer referral program',
      ],
      status: 'Completed',
    ),
    Assessment(
      id: 'a005',
      enterpriseId: 'e005',
      enterpriseName: 'Future Tech Solutions',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      date: DateTime(2025, 3, 1),
      type: 'Baseline',
      scores: {
        'finance': 50,
        'marketing': 75,
        'operations': 55,
        'hr': 40,
        'governance': 45,
      },
      strengths: [
        'Technical expertise',
        'Good portfolio',
        'Growing demand',
      ],
      weaknesses: [
        'Cash flow issues',
        'Small team',
        'No HR processes',
      ],
      recommendations: [
        'Financial management training',
        'Hire 2 junior developers',
        'Create employee handbook',
      ],
      status: 'Completed',
    ),
  ];

  static List<CoachingSession> sessions = [
    CoachingSession(
      id: 's001',
      enterpriseId: 'e001',
      enterpriseName: 'Meron Cafe & Bakery',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      scheduledDate: DateTime(2025, 3, 10, 10, 0),
      actualDate: DateTime(2025, 3, 10, 10, 15),
      type: 'Regular Follow-up',
      notes: 'Discussed bookkeeping progress. Meron has started using a simple notebook. Reviewed income and expenses for February.',
      recommendations: [
        'Separate business and personal cash',
        'Record all daily sales',
        'Track expenses by category',
      ],
      photoCount: 2,
      followUpRequired: true,
      nextSessionDate: DateTime(2025, 3, 24, 10, 0),
    ),
    CoachingSession(
      id: 's002',
      enterpriseId: 'e001',
      enterpriseName: 'Meron Cafe & Bakery',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      scheduledDate: DateTime(2025, 3, 24, 10, 0),
      actualDate: null,
      type: 'Regular Follow-up',
      notes: '',
      recommendations: [],
      photoCount: 0,
      followUpRequired: false,
      nextSessionDate: null,
    ),
    CoachingSession(
      id: 's003',
      enterpriseId: 'e002',
      enterpriseName: 'Tadesse General Store',
      coachId: 'c002',
      coachName: 'Meron Tadesse',
      scheduledDate: DateTime(2025, 3, 12, 14, 30),
      actualDate: DateTime(2025, 3, 12, 14, 45),
      type: 'Training',
      notes: 'Conducted basic sales training for Tadesse and his two employees. Covered customer greeting, product knowledge, and upselling.',
      recommendations: [
        'Practice greeting every customer',
        'Suggest complementary products',
        'Weekly sales meeting',
      ],
      photoCount: 4,
      followUpRequired: true,
      nextSessionDate: DateTime(2025, 3, 26, 14, 30),
    ),
    CoachingSession(
      id: 's004',
      enterpriseId: 'e003',
      enterpriseName: 'Zenash Tailoring',
      coachId: 'c003',
      coachName: 'Tekle Berhan',
      scheduledDate: DateTime(2025, 3, 15, 11, 0),
      actualDate: DateTime(2025, 3, 15, 11, 20),
      type: 'Troubleshooting',
      notes: 'Inspected sewing machines. One machine needs maintenance. Discussed options for machine repair vs. replacement.',
      recommendations: [
        'Schedule machine maintenance',
        'Research new machine prices',
        'Consider financing options',
      ],
      photoCount: 3,
      followUpRequired: true,
      nextSessionDate: DateTime(2025, 3, 29, 11, 0),
    ),
    CoachingSession(
      id: 's005',
      enterpriseId: 'e005',
      enterpriseName: 'Future Tech Solutions',
      coachId: 'c001',
      coachName: 'Abebe Kebede',
      scheduledDate: DateTime(2025, 3, 18, 15, 0),
      actualDate: DateTime(2025, 3, 18, 15, 10),
      type: 'Assessment',
      notes: 'Completed financial health assessment. Samuel needs help with pricing strategy and cash flow management.',
      recommendations: [
        'Review project pricing model',
        'Create cash flow projection',
        'Open separate business account',
      ],
      photoCount: 1,
      followUpRequired: true,
      nextSessionDate: DateTime(2025, 4, 1, 15, 0),
    ),
    CoachingSession(
      id: 's006',
      enterpriseId: 'e004',
      enterpriseName: 'Birhanu Farms',
      coachId: 'c003',
      coachName: 'Tekle Berhan',
      scheduledDate: DateTime(2025, 2, 28, 9, 30),
      actualDate: DateTime(2025, 2, 28, 9, 45),
      type: 'Graduation',
      notes: 'Final session. Birhanu has successfully implemented all recommendations. Business is stable and growing. Graduated from program.',
      recommendations: [
        'Join farmers cooperative',
        'Explore export opportunities',
      ],
      photoCount: 5,
      followUpRequired: false,
      nextSessionDate: null,
    ),
  ];

  static Map<String, List<Map<String, dynamic>>> progressHistory = {
    'e001': [
      {'date': DateTime(2025, 1, 20), 'score': 38},
      {'date': DateTime(2025, 2, 15), 'score': 42},
      {'date': DateTime(2025, 3, 15), 'score': 48},
      {'date': DateTime(2025, 4, 10), 'score': 52},
      {'date': DateTime(2025, 5, 5), 'score': 55},
      {'date': DateTime(2025, 6, 1), 'score': 58},
    ],
    'e002': [
      {'date': DateTime(2025, 1, 22), 'score': 45},
      {'date': DateTime(2025, 2, 20), 'score': 48},
      {'date': DateTime(2025, 3, 20), 'score': 52},
      {'date': DateTime(2025, 4, 17), 'score': 55},
      {'date': DateTime(2025, 5, 15), 'score': 59},
      {'date': DateTime(2025, 6, 10), 'score': 62},
    ],
    'e003': [
      {'date': DateTime(2025, 2, 5), 'score': 65},
      {'date': DateTime(2025, 3, 5), 'score': 68},
      {'date': DateTime(2025, 4, 2), 'score': 71},
      {'date': DateTime(2025, 5, 1), 'score': 74},
      {'date': DateTime(2025, 5, 29), 'score': 77},
      {'date': DateTime(2025, 6, 25), 'score': 80},
    ],
  };

  static Map<String, dynamic> dashboardStats = {
    'totalEnterprises': 5,
    'activeEnterprises': 4,
    'graduatedEnterprises': 1,
    'sessionsThisMonth': 12,
    'assessmentsThisMonth': 3,
    'averageProgressScore': 68,
    'topPerformingSector': 'Garment',
    'needsAttentionCount': 2,
  };

  static List<Map<String, dynamic>> notifications = [
    {
      'id': 'n001',
      'title': 'Session Tomorrow',
      'message': 'Coaching session with Meron Cafe at 10:00 AM',
      'time': '1 hour ago',
      'type': 'reminder',
      'isRead': false,
    },
    {
      'id': 'n002',
      'title': 'Assessment Due',
      'message': 'Quarterly assessment for Tadesse Store is due this week',
      'time': '3 hours ago',
      'type': 'warning',
      'isRead': false,
    },
    {
      'id': 'n003',
      'title': 'Progress Alert',
      'message': 'Zenash Tailoring improved by 12% this month!',
      'time': 'Yesterday',
      'type': 'success',
      'isRead': true,
    },
    {
      'id': 'n004',
      'title': 'Loan Reminder',
      'message': 'Future Tech Solutions loan payment due in 3 days',
      'time': 'Yesterday',
      'type': 'reminder',
      'isRead': true,
    },
    {
      'id': 'n005',
      'title': 'New Feature',
      'message': 'Report generator is now available',
      'time': '2 days ago',
      'type': 'info',
      'isRead': true,
    },
  ];

  static List<CoachingSession> getUpcomingSessions() {
    return sessions
        .where((s) => !s.isCompleted)
        .toList()
      ..sort((a, b) => a.scheduledDate.compareTo(b.scheduledDate));
  }

  static List<CoachingSession> getCompletedSessions() {
    return sessions
        .where((s) => s.isCompleted)
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  static List<Assessment> getAssessmentsForEnterprise(String enterpriseId) {
    return assessments
        .where((a) => a.enterpriseId == enterpriseId)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  static List<CoachingSession> getSessionsForEnterprise(String enterpriseId) {
    return sessions
        .where((s) => s.enterpriseId == enterpriseId)
        .toList()
      ..sort((a, b) => b.scheduledDate.compareTo(a.scheduledDate));
  }

  static Enterprise? getEnterpriseById(String id) {
    try {
      return enterprises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  static Coach? getCoachById(String id) {
    try {
      return coaches.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}