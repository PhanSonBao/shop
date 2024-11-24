import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/constants.dart';

class EditUserInfoScreen extends StatefulWidget {
  final String userId;
  const EditUserInfoScreen({super.key, required this.userId});

  @override
  State<EditUserInfoScreen> createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late ValueNotifier<bool> _genderController;

  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture =
        FirebaseFirestore.instance.collection('Users').doc(widget.userId).get();
  }

  // Function to update user data in Firestore
  Future<void> _updateUserData() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.userId)
            .update({
          'username': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'gender': _genderController.value,
        });

        // Navigate back or show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User information updated successfully!')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa hồ sơ'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _updateUserData,
            child: const Text('Lưu',
                style: TextStyle(color: Colors.blueAccent, fontSize: 16)),
          )
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("User information not found."),
            );
          }

          final user = snapshot.data!;
          _nameController = TextEditingController(text: user['username']);
          _emailController = TextEditingController(text: user['email']);
          _phoneController = TextEditingController(text: user['phone']);
          _genderController = ValueNotifier<bool>(user['gender']);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture & Edit button
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(user['avatar']),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              // Implement profile picture change functionality
                            },
                            child: const CircleAvatar(
                              backgroundColor: primaryColor,
                              radius: 20,
                              child: Icon(Icons.edit, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Implement "Edit Photo" functionality
                      },
                      child: const Text(
                        'Sửa ảnh đại diện',
                        style: TextStyle(color: primaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Số điện thoại không được để trống';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text('Giới tính:', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Radio<bool>(
                            value: true,
                            groupValue: _genderController.value,
                            onChanged: (value) {
                              setState(() {
                                _genderController.value = value!;
                              });
                            },
                          ),
                          const Text('Nam'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      // Female Radio Button
                      Row(
                        children: [
                          Radio<bool>(
                            value: false,
                            groupValue: _genderController.value,
                            onChanged: (value) {
                              setState(() {
                                _genderController.value = value!;
                              });
                            },
                          ),
                          const Text('Nữ'), // "Nữ" = Female Female
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
