// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  bool isLoading = true;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final uid = auth.currentUser!.uid;
    final doc = await firestore.collection('users').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      firstNameController.text = data['first_name'] ?? '';
      lastNameController.text = data['last_name'] ?? '';
    }
    setState(() => isLoading = false);
  }

  Future<void> saveProfile() async {
    final uid = auth.currentUser!.uid;
    await firestore.collection('users').doc(uid).update({
      'first_name': firstNameController.text.trim(),
      'last_name': lastNameController.text.trim(),
    });
    setState(() => isEditing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  isEditing
                      ? Column(
                          children: [
                            TextField(
                              controller: firstNameController,
                              decoration: const InputDecoration(labelText: 'First Name'),
                            ),
                            TextField(
                              controller: lastNameController,
                              decoration: const InputDecoration(labelText: 'Last Name'),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: saveProfile,
                                  child: const Text('Save'),
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed: () {
                                    setState(() => isEditing = false);
                                  },
                                  child: const Text('Cancel'),
                                ),
                              ],
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First Name: ${firstNameController.text}', style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 8),
                            Text('Last Name: ${lastNameController.text}', style: const TextStyle(fontSize: 18)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => setState(() => isEditing = true),
                              child: const Text('Edit Profile'),
                            ),
                          ],
                        ),
                ],
              ),
            ),
    );
  }
}
