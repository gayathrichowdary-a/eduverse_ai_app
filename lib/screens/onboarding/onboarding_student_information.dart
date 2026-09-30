import 'package:flutter/material.dart';
import 'onboarding_class_selection.dart';

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
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController stateController =
      TextEditingController(text: 'Maharashtra');
  final TextEditingController cityController =
      TextEditingController(text: 'Mumbai');

  String? selectedGender;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nicknameController.dispose();
    dateOfBirthController.dispose();
    stateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ================= SCROLLABLE CONTENT =================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ================= PROGRESS BAR =================
                    Row(
                      children: [
                        Container(
                          width: 70,
                          height: 6,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [brandRed, brandGradientEnd],
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ================= TITLE =================
                    const Text(
                      'Tell us about yourself',
                      style: TextStyle(
                        color: navy,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
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

                    const SizedBox(height: 24),

                    // ================= PROFILE AVATAR =================
                    Center(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: 96,
                            height: 96,
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFF1F3),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                'AR',
                                style: TextStyle(
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
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: brandRed.withOpacity(0.3),
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
                      prefixIcon: Icons.face_outlined,
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
                      controller:
                          TextEditingController(text: 'English (India)'),
                      hint: '',
                      prefixIcon: Icons.language,
                      readOnly: true,
                    ),

                    const SizedBox(height: 24),

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
                      controller: TextEditingController(text: 'India'),
                      hint: '',
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

            // ================= FIXED CONTINUE BUTTON =================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 16),
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
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: brandRed.withOpacity(0.3),
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
                      borderRadius: BorderRadius.circular(16),
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
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
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
  // LABELED TEXT FIELD
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
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            color: navy,
            fontSize: 14,
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
                    color: textMuted,
                    size: 18,
                  ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 13,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: cardBorder,
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: brandRed,
                width: 1.6,
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
            color: navy,
            fontSize: 13,
            fontWeight: FontWeight.w600,
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
            fontSize: 14,
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
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: brandRed,
                width: 1.6,
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
      initialDate: DateTime(2005),
      firstDate: DateTime(1950),
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
  // CONTINUE
  // ============================================================
  void _continue() {
    FocusScope.of(context).unfocus();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OnboardingClassSelection(),
      ),
    );
  }
}