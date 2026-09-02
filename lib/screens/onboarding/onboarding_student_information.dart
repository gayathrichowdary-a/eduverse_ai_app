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
  // ================= COLORS =================

  static const Color navy = Color(0xFF1D3B64);
  static const Color subtitleBlue = Color(0xFF4D86AD);
  static const Color brandRed = Color(0xFFEF3340);
  static const Color lightBlue = Color(0xFFA6DDE3);

  // ================= CONTROLLERS =================

  final TextEditingController firstNameController =
      TextEditingController();

  final TextEditingController lastNameController =
      TextEditingController();

  final TextEditingController nicknameController =
      TextEditingController();

  final TextEditingController dateOfBirthController =
      TextEditingController();

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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    padding: const EdgeInsets.fromLTRB(
                      46,
                      18,
                      46,
                      35,
                    ),

                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),

                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,

                        children: [

                          // ================= PROGRESS BAR =================

                          Row(
                            children: [

                              Container(
                                width: 90,
                                height: 12,

                                decoration: BoxDecoration(
                                  color: brandRed,
                                  borderRadius:
                                      BorderRadius.circular(20),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Container(
                                  height: 12,

                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F2F4),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 38),

                          // ================= TITLE =================

                          const Text(
                            'Tell us about yourself',

                            style: TextStyle(
                              color: navy,
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          const SizedBox(height: 14),

                          const Text(
                            "Let's personalize your learning journey",

                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 25,
                            ),
                          ),

                          const SizedBox(height: 38),

                          // ================= PROFILE =================

                          Center(
                            child: SizedBox(
                              width: 210,
                              height: 190,

                              child: Stack(
                                clipBehavior: Clip.none,

                                children: [

                                  Center(
                                    child: Container(
                                      width: 190,
                                      height: 190,

                                      decoration:
                                          const BoxDecoration(
                                        color: Color(0xFFFCEAEC),
                                        shape: BoxShape.circle,
                                      ),

                                      child: const Center(
                                        child: Text(
                                          'AR',

                                          style: TextStyle(
                                            color: brandRed,
                                            fontSize: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  Positioned(
                                    right: 0,
                                    bottom: 22,

                                    child: Container(
                                      width: 58,
                                      height: 58,

                                      decoration:
                                          const BoxDecoration(
                                        color: brandRed,
                                        shape: BoxShape.circle,
                                      ),

                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 42),

                          // ================= FIRST + LAST NAME =================

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Expanded(
                                child: _buildLabeledField(
                                  label: 'First Name',
                                  controller:
                                      firstNameController,
                                  hint: 'Alex',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Expanded(
                                child: _buildLabeledField(
                                  label: 'Last Name',
                                  controller:
                                      lastNameController,
                                  hint: 'Rivera',
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          // ================= NICKNAME =================

                          _buildLabeledField(
                            label: 'Nickname',
                            controller: nicknameController,
                            hint: 'How should we call you?',
                            prefixIcon: Icons.face_outlined,
                          ),

                          const SizedBox(height: 35),

                          // ================= GENDER + DOB =================

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Expanded(
                                child: _buildGenderDropdown(),
                              ),

                              const SizedBox(width: 30),

                              Expanded(
                                child: _buildLabeledField(
                                  label: 'Date of Birth',
                                  controller:
                                      dateOfBirthController,
                                  hint: 'DD/MM/YYYY',
                                  prefixIcon:
                                      Icons.calendar_today_outlined,
                                  readOnly: true,
                                  onTap: _selectDate,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 35),

                          // ================= LANGUAGE =================

                          _buildLabeledField(
                            label: 'Preferred Language',
                            controller: TextEditingController(
                              text: 'English (India)',
                            ),
                            hint: '',
                            prefixIcon: Icons.language,
                            readOnly: true,
                          ),

                          const SizedBox(height: 35),

                          // ================= LOCATION =================

                          const Text(
                            'Location Details',

                            style: TextStyle(
                              color: subtitleBlue,
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 30),

                          // ================= COUNTRY =================

                          _buildLabeledField(
                            label: 'Country',
                            controller: TextEditingController(
                              text: 'India',
                            ),
                            hint: '',
                            prefixIcon: Icons.public,
                            readOnly: true,
                          ),

                          const SizedBox(height: 35),

                          // ================= STATE + CITY =================

                          Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [

                              Expanded(
                                child: _buildLabeledField(
                                  label: 'State',
                                  controller: stateController,
                                  hint: 'Maharashtra',
                                ),
                              ),

                              const SizedBox(width: 30),

                              Expanded(
                                child: _buildLabeledField(
                                  label: 'City',
                                  controller: cityController,
                                  hint: 'Mumbai',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // ================= FIXED CONTINUE BUTTON =================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                46,
                18,
                46,
                28,
              ),

              decoration: const BoxDecoration(
                color: Colors.white,

                border: Border(
                  top: BorderSide(
                    color: Color(0xFFE9EDF0),
                    width: 1,
                  ),
                ),
              ),

              child: SizedBox(
                height: 92,

                child: ElevatedButton(
                  onPressed: _continue,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandRed,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      Text(
                        'Continue',

                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      SizedBox(width: 18),

                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 30,
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
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        SizedBox(
          height: 80,

          child: TextField(
            controller: controller,
            readOnly: readOnly,
            onTap: onTap,

            style: const TextStyle(
              color: navy,
              fontSize: 22,
            ),

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: const TextStyle(
                color: lightBlue,
                fontSize: 25,
              ),

              prefixIcon: prefixIcon == null
                  ? null
                  : Icon(
                      prefixIcon,
                      color: navy,
                      size: 30,
                    ),

              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(20),

                borderSide: const BorderSide(
                  color: navy,
                  width: 2,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(20),

                borderSide: const BorderSide(
                  color: brandRed,
                  width: 2,
                ),
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
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: DropdownButtonFormField<String>(
            value: selectedGender,
            isExpanded: true,
            hint: const Text(
              'Gender',
              style: TextStyle(
                color: lightBlue,
                fontSize: 25,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            icon: const Icon(
              Icons.arrow_drop_down,
              color: subtitleBlue,
              size: 35,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: navy,
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: const BorderSide(
                  color: brandRed,
                  width: 2,
                ),
              ),
            ),
            items: const [
              DropdownMenuItem(
                value: 'Male',
                child: Text(
                  'Male',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'Female',
                child: Text(
                  'Female',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'Other',
                child: Text(
                  'Other',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              DropdownMenuItem(
                value: 'Prefer not to say',
                child: Text(
                  'Prefer not to say',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                selectedGender = value;
              });
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectDate() async {
    final DateTime? pickedDate =
        await showDatePicker(
      context: context,

      initialDate: DateTime(2005),

      firstDate: DateTime(1950),

      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final day = pickedDate.day
          .toString()
          .padLeft(2, '0');

      final month = pickedDate.month
          .toString()
          .padLeft(2, '0');

      final year = pickedDate.year.toString();

      setState(() {
        dateOfBirthController.text =
            '$day/$month/$year';
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
        builder: (context) =>
            const OnboardingClassSelection(),
      ),
    );
  }
}