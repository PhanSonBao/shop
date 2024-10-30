import 'package:flutter/material.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Address"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: const Icon(Icons.filter_list, color: Colors.grey),
                hintText: "Find an address...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Add new address button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.black),
                title: const Text(
                  "Add new address",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  // Handle add new address
                },
              ),
            ),
            const SizedBox(height: 16),
            // Address List
            Expanded(
              child: ListView(
                children: const [
                  // "My home" card
                  AddressesCard(
                    title: "My home",
                    address: "Sophi Nowakowska, Zabiniec 12/222,\n31–215 Cracow, Poland",
                    phone: "+79 123 456 789",
                    isDefault: true,
                    locationIconColor: Colors.purple,
                  ),
                  // "Office" card
                  AddressesCard(
                    title: "Office",
                    address: "Rio Nowakowska, Zabiniec 12/222,\n31–215 Cracow, Poland",
                    phone: "+79 123 456 789",
                    isDefault: false,
                    locationIconColor: Colors.red,
                  ),
                  // "Grandmother's home" card
                  AddressesCard(
                    title: "Grandmother’s home",
                    address: "Rio Nowakowska, Zabiniec 12/222,\n31–215 Cracow, Poland",
                    phone: "+79 123 456 789",
                    isDefault: false,
                    locationIconColor: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddressesCard extends StatelessWidget {
  final String title;
  final String address;
  final String phone;
  final bool isDefault;
  final Color locationIconColor;

  const AddressesCard({super.key, 
    required this.title,
    required this.address,
    required this.phone,
    this.isDefault = false,
    this.locationIconColor = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDefault ? Colors.purple : Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Icon and title
          Column(
            children: [
              CircleAvatar(
                backgroundColor: isDefault ? Colors.purple.shade100 : Colors.grey.shade200,
                child: Icon(Icons.home, color: isDefault ? Colors.purple : Colors.green),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Address details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDefault ? Colors.purple : Colors.black,
                      ),
                    ),
                    if (isDefault)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.purple,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Default",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          // Map Icon
          CircleAvatar(
            backgroundColor: locationIconColor.withOpacity(0.2),
            child: Icon(Icons.location_on, color: locationIconColor),
          ),
        ],
      ),
    );
  }
}
