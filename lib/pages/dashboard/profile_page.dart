import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onBack;
  const ProfilePage({super.key, required this.onBack});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isEdit = false;

  String image =
      "https://i.pravatar.cc/150";

  final nameController = TextEditingController(text: "Aya User");
  final emailController = TextEditingController(text: "aya@email.com");
  final phoneController = TextEditingController(text: "08123456789");
  final heightController = TextEditingController(text: "170");
  final weightController = TextEditingController(text: "60");

  DateTime? birthDate = DateTime(2000, 1, 1);

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: birthDate ?? DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => birthDate = picked);
    }
  }

  Widget buildField(String label, TextEditingController controller,
      {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          enabled: isEdit,
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.withOpacity(0.08),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: widget.onBack,
                child: const Icon(Icons.arrow_back_ios_new),
              ),
              const SizedBox(width: 10),
              Text(
                "Profile",
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 20),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(image),
                ),

                if (isEdit)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFF1AB673),
                        shape: BoxShape.circle,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 25),
          buildField("Nama Lengkap", nameController),
          buildField("Email", emailController),
          buildField("No Telepon", phoneController),
          Text("Tanggal Lahir",
              style: GoogleFonts.poppins(
                  fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: isEdit ? pickDate : null,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                birthDate != null
                    ? DateFormat("dd MMM yyyy").format(birthDate!)
                    : "Pilih tanggal",
              ),
            ),
          ),

          const SizedBox(height: 14),

          buildField("Tinggi Badan (cm)", heightController,
              isNumber: true),
          buildField("Berat Badan (kg)", weightController,
              isNumber: true),

          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1AB673),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });

                if (!isEdit) {
                  print("Data disimpan");
                }
              },
              child: Text(
                isEdit ? "Simpan" : "Edit Profile",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600),
              ),
            ),
          )
        ],
      ),
    );
  }
}