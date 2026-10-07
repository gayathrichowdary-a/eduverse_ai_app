import 'package:flutter/material.dart';
import 'onboarding_class_selection.dart';

// ============================================================
// SHARED STUDENT PROFILE MODEL (STORES ONBOARDING DATA)
// ============================================================
class StudentProfileData {
  static String firstName = 'Alex';
  static String lastName = 'Rivera';
  static String nickname = 'Alex';
  static String gender = 'Male';
  static String dateOfBirth = '01/01/2008';
  static String selectedClass = 'Primary';
  static String city = 'Mumbai';
  static String state = 'Maharashtra';

  static String get fullName => '$firstName $lastName'.trim();
  static String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'A';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : 'R';
    return '$f$l';
  }
}

class OnboardingStudentInformation extends StatefulWidget {
  const OnboardingStudentInformation({super.key});

  @override
  State<OnboardingStudentInformation> createState() =>
      _OnboardingStudentInformationState();
}

class _OnboardingStudentInformationState
    extends State<OnboardingStudentInformation> {
  // ================= SIR'S BRAND COLORS =================
  static const Color navy = Color(0xFF1D3B64);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color brandGradientEnd = Color(0xFFF12C68);
  static const Color textMuted = Color(0xFF667085);
  static const Color cardBorder = Color(0xFFE4E7EC);
  static const Color fieldBg = Color(0xFFF9FAFB);

  // ================= CONTROLLERS =================
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController nicknameController;
  late final TextEditingController dateOfBirthController;
  late final TextEditingController stateController;
  late final TextEditingController cityController;
  late final TextEditingController languageController;
  late final TextEditingController countryController;

  String? selectedGender;

  @override
  void initState() {
    super.initState();
    firstNameController =
        TextEditingController(text: StudentProfileData.firstName);
    lastNameController =
        TextEditingController(text: StudentProfileData.lastName);
    nicknameController =
        TextEditingController(text: StudentProfileData.nickname);
    dateOfBirthController =
        TextEditingController(text: StudentProfileData.dateOfBirth);
    stateController = TextEditingController(text: StudentProfileData.state);
    cityController = TextEditingController(text: StudentProfileData.city);
    languageController = TextEditingController(text: 'English (India)');
    countryController = TextEditingController(text: 'India');
    selectedGender = StudentProfileData.gender;
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nicknameController.dispose();
    dateOfBirthController.dispose();
    stateController.dispose();
    cityController.dispose();
    languageController.dispose();
    countryController.dispose();
    super.dispose();
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final String initial1 = firstNameController.text.trim().isNotEmpty
        ? firstNameController.text.trim()[0].toUpperCase()
        : 'A';
    final String initial2 = lastNameController.text.trim().isNotEmpty
        ? lastNameController.text.trim()[0].toUpperCase()
        : 'R';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= 6-SEGMENT PROGRESS BAR (STEP 1 OF 6) =================
                    Row(
                      children: List.generate(6, (index) {
                        final bool isFirst = index == 0;
                        return Expanded(
                          child: Container(
                            height: 5,
                            margin: EdgeInsets.only(right: index == 5 ? 0 : 6),
                            decoration: BoxDecoration(
                              gradient: isFirst
                                  ? const LinearGradient(
                                      colors: [brandRed, brandGradientEnd],
                                    )
                                  : null,
                              color: isFirst ? null : const Color(0xFFF0F2F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 28),

                    // ================= TITLE =================
                    const Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      "Let's personalize your learning journey",
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ================= PROFILE AVATAR =================
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 94,
                            height: 94,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF1F3),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '$initial1$initial2',
                                style: const TextStyle(
                                  color: brandRed,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: brandRed,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: brandRed.withOpacity(0.35),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ================= FIRST + LAST NAME =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildLabeledField(
                            label: 'First Name',
                            controller: firstNameController,
                            hint: 'Alex',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildLabeledField(
                            label: 'Last Name',
                            controller: lastNameController,
                            hint: 'Rivera',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ================= NICKNAME =================
                    _buildLabeledField(
                      label: 'Nickname',
                      controller: nicknameController,
                      hint: 'How should we call you?',
                      prefixIcon: Icons.sentiment_satisfied_alt_outlined,
                    ),

                    const SizedBox(height: 18),

                    // ================= GENDER + DOB =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildGenderDropdown(),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildLabeledField(
                            label: 'Date of Birth',
                            controller: dateOfBirthController,
                            hint: 'DD/MM/YYYY',
                            prefixIcon: Icons.calendar_today_outlined,
                            readOnly: true,
                            onTap: _selectDate,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // ================= LANGUAGE =================
                    _buildLabeledField(
                      label: 'Preferred Language',
                      controller: languageController,
                      hint: 'English (India)',
                      prefixIcon: Icons.language,
                      readOnly: true,
                    ),

                    const SizedBox(height: 26),

                    // ================= LOCATION =================
                    const Text(
                      'Location Details',
                      style: TextStyle(
                        color: navy,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // ================= COUNTRY =================
                    _buildLabeledField(
                      label: 'Country',
                      controller: countryController,
                      hint: 'India',
                      prefixIcon: Icons.public,
                      readOnly: true,
                    ),

                    const SizedBox(height: 18),

                    // ================= STATE + CITY =================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildLabeledField(
                            label: 'State',
                            controller: stateController,
                            hint: 'Maharashtra',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _buildLabeledField(
                            label: 'City',
                            controller: cityController,
                            hint: 'Mumbai',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // ================= SIR'S CAPSULE PILL CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Color(0xFFF2F4F7), width: 1),
                ),
              ),
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [brandRed, brandGradientEnd],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(30), // Sir's exact pill shape
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // LABELED TEXT FIELD (MATCHING SIR'S CLEAN BORDER & RADIUS)
  // ============================================================
  Widget _buildLabeledField({
    required String label,
    required TextEditingController controller,
    required String hint,
    IconData? prefixIcon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(
            color: navy,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF98A2B3),
              fontSize: 14,
            ),
            filled: true,
            fillColor: fieldBg,
            prefixIcon: prefixIcon == null
                ? null
                : Icon(
                    prefixIcon,
                    color: const Color(0xFF667085),
                    size: 19,
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: cardBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: brandRed,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // GENDER DROPDOWN
  // ============================================================
  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            color: textMuted,
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          initialValue: selectedGender,
          isExpanded: true,
          hint: const Text(
            'Gender',
            style: TextStyle(
              color: Color(0xFF98A2B3),
              fontSize: 14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: textMuted,
            size: 20,
          ),
          style: const TextStyle(
            color: navy,
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: fieldBg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: cardBorder,
                width: 1.0,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: brandRed,
                width: 1.5,
              ),
            ),
          ),
          items: const [
            DropdownMenuItem(value: 'Male', child: Text('Male')),
            DropdownMenuItem(value: 'Female', child: Text('Female')),
            DropdownMenuItem(value: 'Other', child: Text('Other')),
            DropdownMenuItem(
              value: 'Prefer not to say',
              child: Text('Prefer not to say'),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedGender = value;
            });
          },
        ),
      ],
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================
  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1960),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: brandRed,
              onPrimary: Colors.white,
              onSurface: navy,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final year = pickedDate.year.toString();

      setState(() {
        dateOfBirthController.text = '$day/$month/$year';
      });
    }
  }

  // ============================================================
  // CONTINUE: SAVES STUDENT PROFILE AND NAVIGATES FORWARD
  // ============================================================
  void _continue() {
    FocusScope.of(context).unfocus();

    if (firstNameController.text.trim().isNotEmpty) {
      StudentProfileData.firstName = firstNameController.text.trim();
    }
    if (lastNameController.text.trim().isNotEmpty) {
      StudentProfileData.lastName = lastNameController.text.trim();
    }
    if (nicknameController.text.trim().isNotEmpty) {
      StudentProfileData.nickname = nicknameController.text.trim();
    }
    if (dateOfBirthController.text.trim().isNotEmpty) {
      StudentProfileData.dateOfBirth = dateOfBirthController.text.trim();
    }
    if (selectedGender != null) {
      StudentProfileData.gender = selectedGender!;
    }
    if (stateController.text.trim().isNotEmpty) {
      StudentProfileData.state = stateController.text.trim();
    }
    if (cityController.text.trim().isNotEmpty) {
      StudentProfileData.city = cityController.text.trim();
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingClassSelection(),
      ),
    );
  }
}