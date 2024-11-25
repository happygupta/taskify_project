import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskify_project/Screens/home/add_task.dart';
import 'package:taskify_project/service/Completedscreen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Firebase/FIrebase_operation.dart';
import '../listmodel.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  var id;
  var status;

  void markAsCompleted(String id) async {
    await FirebaseFirestore.instance.collection('Details').doc(id).update({
      'status': 'Completed',
    });
    print('Task marked as completed');
  }

  void showsheet(String date, String time, String address, String state, String city, String remark, List mobileno) async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Event Date & Time
              Row(
                children: [
                  Icon(Icons.event, color: Colors.orange, size: 36),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Address Section
              _buildDetailRow(Icons.home_outlined, 'Address', address),
              SizedBox(height: 12),
              _buildDetailRow(Icons.location_city, 'State', state),
              SizedBox(height: 12),
              _buildDetailRow(Icons.location_on, 'City', city),
              SizedBox(height: 20),

              // Mobile Numbers Section
              if (mobileno.isNotEmpty) ...[
                Text(
                  'Mobile Numbers:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  children: mobileno.map((mobile) {
                    return Chip(
                      label: GestureDetector(
                          onTap: () async {
                            final url = Uri.parse('tel:+91$mobile');
                            if (await canLaunchUrl(url)) {
                              launchUrl(url);
                            }
                          },
                          child: Text(mobile.toString())),
                      backgroundColor: Colors.orange.withOpacity(0.2),
                      deleteIcon: Icon(Icons.delete, size: 18),
                      onDeleted: () {
                        // Implement delete functionality
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],

              // Remark Section
              _buildDetailRow(Icons.comment, 'Remark', remark.isNotEmpty ? remark : 'No remarks available.'),
              SizedBox(height: 20),

              // Close Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 24),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            '$title: $value',
            style: TextStyle(fontSize: 16, color: Colors.black87),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Details").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot dst = snapshot.data!.docs[index];
                id = dst['id'];
                status = dst['status'];

                if (status != 'Completed') {
                  return Slidable(
                    key: ValueKey(dst['id']),
                    startActionPane: ActionPane(
                        motion: ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                            onPressed: (_) async {
                              await FirebaseOperation().deletedetails(dst['id']);
                            },
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'Delete',
                          ),
                        ]
                    ),
                    endActionPane: ActionPane(
                        dismissible: DismissiblePane(onDismissed: () {}),
                        motion: ScrollMotion(),
                        children: [
                          SlidableAction(
                            flex: 2,
                            onPressed: (_) {
                              markAsCompleted(dst['id']);
                            },
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            icon: Icons.check_circle,
                            label: 'Completed',
                          ),
                        ]
                    ),

                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: const Icon(
                          Icons.event,
                          color: Colors.orange,
                          size: 32.0,
                        ),
                        title: Row(
                          children: [
                            Text(
                              dst['date'],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              dst['time'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dst['address'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                "${dst['city']}, ${dst['state']}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            // Navigate to the Add Task page and pass the event data
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddTask(
                                  isEdit: true, // Indicate that this is an edit action
                                  eventData: {
                                    'id': dst['id'],
                                    'date': dst['date'],
                                    'time': dst['time'],
                                    'address': dst['address'],
                                    'state': dst['state'],
                                    'city': dst['city'],
                                    'remark': dst['remark'],
                                    'mobile_no': dst['mobile_no'],
                                    'status':dst['status'],
                                  },
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit, color: Colors.orange),
                        ),
                        onTap: () {
                          showsheet(dst['date'], dst['time'], dst['address'], dst['state'], dst['city'], dst['remark'], dst['mobile_no']);
                        },
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            );
          }
          return const Center(child: Text('No upcoming events found.'));
        },
      ),
    );
  }
}
