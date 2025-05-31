import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomEditProfile extends StatelessWidget {
  const CustomEditProfile({super.key});
  static const String id = 'custom_edit_profile';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final firstNameController = TextEditingController(
      text: user?.displayName?.split(' ').first ?? '',
    );
    final lastNameController = TextEditingController(
      text: (user?.displayName?.split(' ').length ?? 0) > 1
          ? user?.displayName?.split(' ').last
          : '',
    );
    final phoneController = TextEditingController(
      text: user?.phoneNumber ?? '',
    );

    Future<void> saveProfile() async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String displayName = firstNameController.text.trim();
        if (lastNameController.text.trim().isNotEmpty) {
          displayName += ' ${lastNameController.text.trim()}';
        }

        // Update Firebase Auth display name
        await user.updateDisplayName(displayName);

        // Update Firestore user data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': displayName, // Changed from firstName/lastName to name
          'phoneNumber': phoneController.text.trim(),
          'email': user.email,
          'uid': user.uid,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        // Reload user to get updated data
        await user.reload();

        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context); // Return to previous screen after successful update
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('PROFILE'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('FIRST NAME',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(hintText: 'Enter first name'),
            ),
            const SizedBox(height: 20),
            const Text('LAST NAME',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(hintText: 'Enter last name'),
            ),
            const SizedBox(height: 20),
            const Text('PHONE NUMBER',
                style: TextStyle(fontSize: 12, color: Colors.grey)),
            IntlPhoneField(
              controller: phoneController,
              initialCountryCode: 'US',
              decoration: const InputDecoration(hintText: '(201) 555-0123'),
              disableLengthCheck: true,
              dropdownIconPosition: IconPosition.trailing,
              showDropdownIcon: true,
              onChanged: (phone) {
                phoneController.text = phone.completeNumber;
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                onPressed: saveProfile,
                child:
                    const Text('SAVE', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
