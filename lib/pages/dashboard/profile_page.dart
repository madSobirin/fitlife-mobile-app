import 'dart:convert';
import 'package:fitlife/models/user_model.dart';
import 'package:fitlife/services/auth_services.dart' as auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fitlife/config/config.dart' as cfg;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  UserModel? _user;
  bool _loading = true;
  bool _savingField = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _birthDate;

  final Map<String, bool> _editing = {
    'username': false,
    'phone': false,
    'height': false,
    'weight': false,
  };

  static const Color _bg = Color(0xFFF8FFFA);
  static const Color _primary = Color(0xFF00FF66);
  static const Color _primaryDark = Color(0xFF15803D);
  static const Color _cardBg = Colors.white;
  static const Color _textDark = Color(0xFF111827);
  static const Color _textMuted = Color(0xFF6B7280);
  static const Color _border = Color(0xFFE5E7EB);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fetchProfile();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  // ── Fetch profile dari API /api/profile ──
  Future<void> _fetchProfile() async {
    setState(() => _loading = true);

    try {
      final token = await auth.getToken();
      if (token == null) {
        setState(() => _loading = false);
        return;
      }

      final res = await http.get(
        Uri.parse('${cfg.Config.baseUrl}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final userData = data['user'] ?? data;
        final user = UserModel.fromJson({...userData, 'token': token});

        // Update SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user.toJson()));

        setState(() {
          _user = user;
          _usernameController.text = user.username ?? '';
          _phoneController.text = user.phone ?? '';
          _heightController.text = user.height?.toString() ?? '';
          _weightController.text = user.weight?.toString() ?? '';
          if (user.birthdate != null) {
            _birthDate = DateTime.tryParse(user.birthdate!);
          }
          _loading = false;
        });
        _fadeController.forward();
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  // ── Save field ke API PATCH /api/profile ──
  Future<void> _saveField(String field, dynamic value) async {
    setState(() => _savingField = true);

    try {
      final token = await auth.getToken();
      if (token == null) return;

      // Map field name ke key API sesuai UpdateProfileRequest
      final Map<String, dynamic> body = {};
      switch (field) {
        case 'username':
          body['username'] = value;
          break;
        case 'phone':
          body['phone'] = value;
          break;
        case 'height':
          body['height'] = int.tryParse(value.toString());
          break;
        case 'weight':
          body['weight'] = int.tryParse(value.toString());
          break;
        case 'birthdate':
          body['birthdate'] = DateFormat(
            'yyyy-MM-dd',
          ).format(value as DateTime);
          break;
      }

      final res = await http.patch(
        Uri.parse('${cfg.Config.baseUrl}/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final userData = data['user'] ?? data;
        final user = UserModel.fromJson({...userData, 'token': token});

        // Update local storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', jsonEncode(user.toJson()));

        setState(() {
          _user = user;
          _editing[field] = false;
          _savingField = false;
        });

        if (!mounted) return;
        _showSuccessSnackBar('Berhasil disimpan');
      } else {
        final data = jsonDecode(res.body);
        setState(() {
          _editing[field] = false;
          _savingField = false;
        });
        if (!mounted) return;
        _showErrorSnackBar(data['message'] ?? 'Gagal menyimpan');
      }
    } catch (e) {
      setState(() {
        _editing[field] = false;
        _savingField = false;
      });
      if (!mounted) return;
      _showErrorSnackBar('Terjadi kesalahan koneksi');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              message,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: _primaryDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: ThemeData.light().copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00FF66),
            onPrimary: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() => _birthDate = picked);
      await _saveField('birthdate', picked);
    }
  }

  void _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
              ),
              child: const Center(
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 30,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Keluar Akun?',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Anda akan keluar dari akun ini.\nLogin ulang diperlukan untuk melanjutkan.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: _textMuted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Batal',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: _textMuted,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Keluar',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    if (confirm != true) return;
    await auth.logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/login',
      arguments: {'message': 'Berhasil keluar dari akun'},
    );
  }

  String get _initials {
    final name = _user?.name ?? '';
    final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : FadeTransition(
              opacity: _fadeAnim,
              child: Stack(
                children: [
                  Positioned(
                    top: -80,
                    right: -80,
                    child: Container(
                      width: 260,
                      height: 260,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x1A00FF66),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 160,
                    left: -80,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x0D3B82F6),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              _buildHeader(),
                              const SizedBox(height: 24),
                              _buildAvatarCard(),
                              const SizedBox(height: 20),
                              _buildFieldCard(
                                icon: Icons.person_outline_rounded,
                                label: 'NAMA LENGKAP',
                                value: _user?.name ?? '-',
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildEditableCard(
                                      fieldKey: 'username',
                                      icon: Icons.alternate_email_rounded,
                                      label: 'USERNAME',
                                      controller: _usernameController,
                                      hint: 'Klik untuk mengisi',
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildFieldCard(
                                      icon: Icons.email_outlined,
                                      label: 'EMAIL',
                                      value: _user?.email ?? '-',
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildEditableCard(
                                      fieldKey: 'phone',
                                      icon: Icons.phone_outlined,
                                      label: 'NOMOR TELEPON',
                                      controller: _phoneController,
                                      hint: 'Klik untuk mengisi',
                                      keyboardType: TextInputType.phone,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(child: _buildDateCard()),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildEditableCard(
                                      fieldKey: 'weight',
                                      icon: Icons.monitor_weight_outlined,
                                      label: 'BERAT (KG)',
                                      controller: _weightController,
                                      hint: 'Klik untuk mengisi',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildEditableCard(
                                      fieldKey: 'height',
                                      icon: Icons.height_rounded,
                                      label: 'TINGGI (CM)',
                                      controller: _heightController,
                                      hint: 'Klik untuk mengisi',
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildPasswordCard(),
                              const SizedBox(height: 20),
                              _buildLogoutButton(),
                              const SizedBox(height: 12),
                              Center(
                                child: Text(
                                  'Klik pada field untuk mengedit • Email tidak dapat diubah',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: _textMuted,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Row(
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
            color: _textDark,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatarCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00FF66).withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF00FF66).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFF00FF66).withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    _initials,
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: _primaryDark,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    size: 10,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.name ?? 'User',
                  style: GoogleFonts.manrope(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _user?.email ?? '-',
                  style: GoogleFonts.inter(fontSize: 13, color: _textMuted),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    (_user?.role ?? 'user').toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: _primaryDark),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _primaryDark,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _textDark,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCard({
    required String fieldKey,
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    final isEditing = _editing[fieldKey] ?? false;
    return GestureDetector(
      onTap: isEditing ? null : () => setState(() => _editing[fieldKey] = true),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isEditing ? const Color(0xFFF0FFF4) : _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isEditing ? _primary : _border,
            width: isEditing ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 13, color: _primaryDark),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                if (isEditing)
                  GestureDetector(
                    onTap: _savingField
                        ? null
                        : () => _saveField(fieldKey, controller.text),
                    child: _savingField
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF15803D),
                            ),
                          )
                        : Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: _primaryDark,
                          ),
                  )
                else
                  Icon(Icons.edit_outlined, size: 13, color: _textMuted),
              ],
            ),
            const SizedBox(height: 8),
            isEditing
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    keyboardType: keyboardType,
                    inputFormatters: inputFormatters,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _textDark,
                    ),
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: GoogleFonts.inter(
                        fontSize: 13,
                        color: _textMuted,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  )
                : Text(
                    controller.text.isEmpty ? hint : controller.text,
                    style: GoogleFonts.inter(
                      fontSize: controller.text.isEmpty ? 13 : 14,
                      fontWeight: controller.text.isEmpty
                          ? FontWeight.w400
                          : FontWeight.w600,
                      color: controller.text.isEmpty ? _textMuted : _textDark,
                      fontStyle: controller.text.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: _primaryDark,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'TGL LAHIR',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                Icon(Icons.edit_outlined, size: 13, color: _textMuted),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _birthDate != null
                  ? DateFormat('dd MMM yyyy').format(_birthDate!)
                  : 'Klik untuk mengisi',
              style: GoogleFonts.inter(
                fontSize: _birthDate != null ? 14 : 13,
                fontWeight: _birthDate != null
                    ? FontWeight.w600
                    : FontWeight.w400,
                color: _birthDate != null ? _textDark : _textMuted,
                fontStyle: _birthDate != null
                    ? FontStyle.normal
                    : FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.lock_outline_rounded,
                size: 18,
                color: Color(0xFF15803D),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ubah Password',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                Text(
                  'Perbarui password akun kamu',
                  style: GoogleFonts.inter(fontSize: 12, color: _textMuted),
                ),
              ],
            ),
          ),
          Icon(Icons.edit_outlined, size: 16, color: _textMuted),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: _handleLogout,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.red.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(
              'Keluar dari Akun',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
