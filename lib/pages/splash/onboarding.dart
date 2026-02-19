// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      badge: 'NEXT GEN PERFORMANCE',
      badgeIcon: Icons.bolt_rounded,
      title: 'Design your body.',
      titleHighlight: 'Defy your limits.',
      subtitle:
          'Create your profile to access elite tracking and coaching tailored to your unique biology.',
      buttonText: 'Get Started',
      showSignIn: true,
      visualType: VisualType.dumbbell,
    ),
    OnboardingData(
      badge: 'REAL-TIME ANALYTICS',
      badgeIcon: Icons.insights_rounded,
      title: 'Track Your',
      titleHighlight: 'Progress',
      subtitle:
          'Visualize your journey with precision metrics. Watch yourself grow stronger every single day.',
      buttonText: 'Next Step',
      showSignIn: false,
      visualType: VisualType.tracking,
    ),
    OnboardingData(
      badge: 'NEXT GEN PERFORMANCE',
      badgeIcon: Icons.bolt_rounded,
      title: 'Elite',
      titleHighlight: 'Coaching',
      subtitle:
          'Connect with world-class trainers and get real-time feedback on your biometric data.',
      buttonText: 'Next',
      showSignIn: false,
      showBackButton: true,
      visualType: VisualType.coaching,
    ),
    OnboardingData(
      badge: 'GLOBAL NETWORK',
      badgeIcon: Icons.groups_rounded,
      title: 'Find Your',
      titleHighlight: 'Tribe.',
      subtitle:
          'Connect with elite athletes, share your progress, and get motivated by a community that refuses to quit.',
      buttonText: 'Get Started',
      showSignIn: true,
      signInText: 'Log In',
      visualType: VisualType.community,
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF4),
      body: Stack(
        children: [
          // Background blobs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00FF66).withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00FF66).withOpacity(0.06),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.change_history_rounded,
                                color: Color(0xFF00FF66),
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'FitTech',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      // Skip
                      GestureDetector(
                        onTap: _skip,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF9CA3AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // PageView
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() => _currentPage = index);
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(_pages[index]);
                    },
                  ),
                ),

                // Bottom section
                _buildBottomSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardingData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Visual
          Expanded(
            flex: 5,
            child: Center(child: _buildVisual(data.visualType)),
          ),

          // Text content
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00FF66).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF00FF66).withOpacity(0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        data.badgeIcon,
                        size: 14,
                        color: const Color(0xFF00CC52),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data.badge,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00CC52),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.manrope(
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF111827),
                      height: 1.15,
                    ),
                    children: [
                      TextSpan(text: '${data.title}\n'),
                      TextSpan(
                        text: data.titleHighlight,
                        style: GoogleFonts.manrope(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF00FF66),
                          height: 1.15,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  data.subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF6B7280),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVisual(VisualType type) {
    switch (type) {
      case VisualType.dumbbell:
        return _buildDumbbellVisual();
      case VisualType.tracking:
        return _buildTrackingVisual();
      case VisualType.coaching:
        return _buildCoachingVisual();
      case VisualType.community:
        return _buildCommunityVisual();
    }
  }

  // ─── Visual 1: Dumbbell / Power ───
  Widget _buildDumbbellVisual() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF66).withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Glow effect
          Positioned(
            top: 40,
            left: 40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00FF66).withOpacity(0.15),
              ),
            ),
          ),
          // Icon representation
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF00FF66).withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.fitness_center_rounded,
                    size: 42,
                    color: Color(0xFF00FF66),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'POWER',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.white.withOpacity(0.6),
                    letterSpacing: 4,
                  ),
                ),
              ],
            ),
          ),
          // Floating dots
          Positioned(
            top: 60,
            right: 50,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF00FF66),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            left: 60,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Visual 2: Tracking / Analytics ───
  Widget _buildTrackingVisual() {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xFF0F2027),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF66).withOpacity(0.12),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Gradient overlay
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 120,
              height: 4,
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: const Color(0xFF00FF66),
              ),
            ),
          ),
          // Pace indicator
          Positioned(
            top: 80,
            left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF00FF66),
                    ),
                    child: const Icon(
                      Icons.bolt_rounded,
                      size: 18,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CURRENT PACE',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          children: [
                            const TextSpan(text: '4:32 '),
                            TextSpan(
                              text: '/km',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Graph line
          Positioned(
            bottom: 50,
            right: 24,
            child: SizedBox(
              width: 120,
              height: 50,
              child: CustomPaint(painter: _GraphPainter()),
            ),
          ),
          // Running man icon
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Icon(
                Icons.directions_run_rounded,
                size: 60,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Visual 3: Coaching / Analytics Chart ───
  Widget _buildCoachingVisual() {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Grid pattern
          Positioned.fill(child: CustomPaint(painter: _GridPainter())),
          // Bar chart
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // BPM label
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '172 BPM',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Bars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildBar(0.30, false),
                    const SizedBox(width: 10),
                    _buildBar(0.50, false),
                    const SizedBox(width: 10),
                    _buildBar(0.75, true),
                    const SizedBox(width: 10),
                    _buildBar(0.95, true, isHighlight: true),
                    const SizedBox(width: 10),
                    _buildBar(0.60, true),
                    const SizedBox(width: 10),
                    _buildBar(0.40, false),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          // Curve overlay
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: CustomPaint(painter: _CurvePainter()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
    double heightFactor,
    bool isGreen, {
    bool isHighlight = false,
  }) {
    final maxHeight = 120.0;
    return Container(
      width: 18,
      height: maxHeight * heightFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: isGreen
            ? isHighlight
                  ? const Color(0xFF00FF66)
                  : const Color(0xFF00FF66).withOpacity(0.5)
            : const Color(0xFFE5E7EB),
        boxShadow: isHighlight
            ? [
                BoxShadow(
                  color: const Color(0xFF00FF66).withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
    );
  }

  // ─── Visual 4: Community ───
  Widget _buildCommunityVisual() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Main profile card
          Container(
            width: 200,
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFF1A1A2E),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              children: [
                // Cover area
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF374151),
                        const Color(0xFF1F2937),
                      ],
                    ),
                  ),
                ),
                // Profile info
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 48,
                        height: 48,
                        margin: const EdgeInsets.only(top: 0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF00FF66),
                            width: 2,
                          ),
                          color: const Color(0xFF374151),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Color(0xFF9CA3AF),
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Alex M.',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.emoji_events_rounded,
                            size: 14,
                            color: Color(0xFF00FF66),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Top 1% Performer',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating card - left
          Positioned(
            top: 30,
            left: 0,
            child: Transform.rotate(
              angle: -0.15,
              child: Container(
                width: 110,
                height: 80,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF3B82F6),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          width: 40,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: const Color(0xFFE5E7EB),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      width: 70,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 45,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: const Color(0xFFE5E7EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating card - right (member count)
          Positioned(
            bottom: 30,
            right: 0,
            child: Transform.rotate(
              angle: 0.08,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Stacked avatars
                    SizedBox(
                      width: 80,
                      height: 32,
                      child: Stack(
                        children: [
                          _buildMiniAvatar(0, const Color(0xFF3B82F6)),
                          _buildMiniAvatar(20, const Color(0xFF8B5CF6)),
                          Positioned(
                            left: 40,
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF00FF66),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+2k',
                                  style: GoogleFonts.inter(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Join 2,400+ Athletes',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(double left, Color color) {
    return Positioned(
      left: left,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.person_rounded, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _buildBottomSection() {
    final data = _pages[_currentPage];
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        children: [
          // Page dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              final isActive = index == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isActive ? 32 : 8,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: isActive
                      ? const Color(0xFF00FF66)
                      : const Color(0xFFD1D5DB),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00FF66).withOpacity(0.4),
                            blurRadius: 8,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Button row
          if (data.showBackButton == true) ...[
            Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: _prevPage,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF6B7280),
                      size: 20,
                    ),
                  ),
                ),
                const Spacer(),
                // Next button (compact)
                SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111827),
                      foregroundColor: Colors.white,
                      elevation: 4,
                      shadowColor: Colors.black.withOpacity(0.2),
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          data.buttonText,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Full width button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF66),
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shadowColor: const Color(0xFF00FF66).withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      data.buttonText,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 20),
                  ],
                ),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Sign In / Log In link
          if (data.showSignIn)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Already have an account? ',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: const Color(0xFF9CA3AF),
                  ),
                ),
                GestureDetector(
                  onTap: _skip,
                  child: Text(
                    data.signInText ?? 'Sign In',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

// ─── Data Models ─────────────────────────

enum VisualType { dumbbell, tracking, coaching, community }

class OnboardingData {
  final String badge;
  final IconData badgeIcon;
  final String title;
  final String titleHighlight;
  final String subtitle;
  final String buttonText;
  final bool showSignIn;
  final String? signInText;
  final bool? showBackButton;
  final VisualType visualType;

  OnboardingData({
    required this.badge,
    required this.badgeIcon,
    required this.title,
    required this.titleHighlight,
    required this.subtitle,
    required this.buttonText,
    required this.showSignIn,
    required this.visualType,
    this.signInText,
    this.showBackButton,
  });
}

// ─── Custom Painters ─────────────────────

class _GraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF66)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.6,
      size.width * 0.4,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.3,
      size.width * 0.75,
      size.height * 0.25,
    );
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.15,
      size.width,
      size.height * 0.1,
    );

    canvas.drawPath(path, paint);

    // Dot at end
    canvas.drawCircle(
      Offset(size.width, size.height * 0.1),
      4,
      Paint()..color = const Color(0xFF00FF66),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF000000).withOpacity(0.03)
      ..strokeWidth = 0.5;

    const spacing = 20.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00FF66).withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width,
      size.height * 0.4,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
