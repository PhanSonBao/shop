import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop/route/route_constants.dart';
import 'package:shop/screens/user_info/views/components/info_row.dart';

class UserInfoScreen extends StatefulWidget {
  final String userId;
  const UserInfoScreen({super.key, required this.userId});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late Future<DocumentSnapshot> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture =
        FirebaseFirestore.instance.collection('Users').doc(widget.userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin tài khoản'),
        centerTitle: true,
        actions: [
          TextButton(
              child: const Text('Sửa', style: TextStyle(fontSize: 16)),
              onPressed: () {
                Navigator.pushNamed(context, editUserInfoScreenRoute, arguments: widget.userId);
              })
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
              child: Text("Không tìm thấy thông tin người dùng."),
            );
          }

          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(user['avatar']),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user['username'],
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user['email'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              InfoRow(
                icon: Icons.person,
                label: 'Tên người dùng',
                value: user['username'],
              ),
              InfoRow(
                icon: Icons.email,
                label: 'Email',
                value: user['email'],
              ),
              InfoRow(
                icon: Icons.phone,
                label: 'Số điện thoại',
                value: user['phone'],
              ),
              InfoRow(
                icon: user['gender'] ? Icons.male : Icons.female,
                label: 'Giới tính',
                value: user['gender'] ? 'Nam' : 'Nữ',
              ),
            ],
          );
        },
      ),
    );
  }
}
