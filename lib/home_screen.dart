import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    const Color bgColor = Color(0xFFFDF6E5);
    const Color cardBgColor = Color(0xFFFDF1EC);
    const Color buttonBgColor = Color(0xFFF1E5DA);
    const Color tagBgColor = Color(0xFFF3D6D2);
    const Color dotColor = Color(0xFFC0304D);
    const Color textDark = Color(0xFF1A1A1A);

    return Scaffold(
      backgroundColor: bgColor,

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: bgColor,
          selectedItemColor: textDark,
          unselectedItemColor: textDark.withValues(alpha: 0.5),
          currentIndex: 2, // 'Schedule' is selected
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          selectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.w700, fontSize: 12),
          unselectedLabelStyle: GoogleFonts.lato(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.inbox_outlined), label: "Drafts"),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: "Schedule"),
            BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: "Settings"),
          ],
        ),
      ),

      // MAIN BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. APP BAR / HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Schedule",
                    style: GoogleFonts.lato(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      _buildTopIconButton(Icons.visibility_outlined, buttonBgColor),
                      const SizedBox(width: 8),
                      _buildTopIconButton(Icons.calendar_today_outlined, buttonBgColor),
                      const SizedBox(width: 8),
                      _buildTopIconButton(Icons.remove, buttonBgColor),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),

              // 2. DATE SELECTOR
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                decoration: BoxDecoration(
                  color: cardBgColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildTopIconButton(Icons.chevron_left, buttonBgColor),
                    Column(
                      children: [
                        Text(
                          "Wednesday",
                          style: GoogleFonts.lato(color: textDark, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              "Jul 9, 2023",
                              style: GoogleFonts.lato(color: textDark.withValues(alpha: 0.7), fontSize: 13),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: buttonBgColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Pacific",
                                style: GoogleFonts.lato(color: textDark.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    _buildTopIconButton(Icons.chevron_right, buttonBgColor),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 3. TIMELINE LIST
              // Blank Task slots
              _buildTimelineRow(time: "", child: _buildEmptyTaskCard("Tap to add activity", cardBgColor, textDark)),
              const SizedBox(height: 16),
              _buildTimelineRow(time: "4 PM", child: _buildEmptyTaskCard("Tap to add activity", cardBgColor, textDark), timeBg: buttonBgColor),
              const SizedBox(height: 16),

              // Filled Task slots
              _buildTimelineRow(
                  time: "6 PM", timeBg: const Color(0xFF7A4B54), timeText: Colors.white,
                  child: _buildFilledTaskCard("Dinner & Family Time", "1h", cardBgColor, textDark, dotColor, tagBgColor)
              ),
              const SizedBox(height: 16),

              _buildTimelineRow(
                time: "7 PM", timeBg: buttonBgColor,
                child: Column(
                  children: [
                    _buildFilledTaskCard("Light Walk/Fresh Air", "90m", cardBgColor, textDark, dotColor, tagBgColor),
                    const SizedBox(height: 12),
                    _buildFilledTaskCard("Digital Detox Begins", "15m", cardBgColor, textDark, dotColor, tagBgColor),
                    const SizedBox(height: 12),
                    _buildFilledTaskCard("Reading/Journaling", "45m", cardBgColor, textDark, dotColor, tagBgColor),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              _buildTimelineRow(time: "8 PM", timeBg: buttonBgColor, child: const SizedBox(height: 40)),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS TO KEEP CODE CLEAN ---

  Widget _buildTopIconButton(IconData icon, Color bgColor) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFF1A1A1A)),
    );
  }

  Widget _buildTimelineRow({required String time, required Widget child, Color? timeBg, Color timeText = const Color(0xFF1A1A1A)}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: time.isEmpty ? null : Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: timeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                time,
                style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: timeText),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildEmptyTaskCard(String text, Color bgColor, Color textColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.lato(color: textColor.withValues(alpha: 0.8), fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _buildFilledTaskCard(String title, String duration, Color bgColor, Color textColor, Color dotColor, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 20, width: 20,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: dotColor, width: 1.5)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 8, width: 8,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: GoogleFonts.lato(color: textColor, fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                duration,
                style: GoogleFonts.lato(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 44), // Alignment spacing
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "IC Template",
                  style: GoogleFonts.lato(color: dotColor.withValues(alpha: 0.8), fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
