import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Firebase/FIrebase_operation.dart';
import '../Screens/home/add_task.dart';

class Completedscreen extends StatefulWidget {
  const Completedscreen({super.key});

  @override
  State<Completedscreen> createState() => _CompletedscreenState();
}

class _CompletedscreenState extends State<Completedscreen> {
  var id;
  var status;
  void markAsCompleted(String id) async {
    await FirebaseFirestore.instance
        .collection('Details')
        .doc(id)
        .update({'status': "pending"});
  }

  void showsheet(String date, String time, String address, String state,
      String city, String remark, List mobileno) async {
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
                            print(mobile);
                            final url = Uri.parse('tel:+91$mobile');
                            if (await canLaunchUrl(url)) {
                              launchUrl(url);
                            }
                          },
                          child: Text(mobile.toString())),
                      backgroundColor: Colors.orange.withOpacity(0.1),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],

              // Remark Section
              _buildDetailRow(Icons.comment, 'Remark',
                  remark.isNotEmpty ? remark : 'No remarks available.'),
              SizedBox(height: 20),

              // Close Button
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: Text('Close'),
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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Details")
          .where('status', isEqualTo: 'Completed')
          .snapshots(),
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
              if (status != 'pending') {
                return Slidable(
                  key: ValueKey(dst['id']),
                  startActionPane: ActionPane(
                      motion: ScrollMotion(),
                      dismissible: DismissiblePane(onDismissed: () {}),
                      children: [
                        SlidableAction(
                          onPressed: (_) async {
                            await FirebaseOperation().deletedetails(id);
                          },
                          backgroundColor: Color(0xFFFE4A49),
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                  endActionPane: ActionPane(
                      dismissible: DismissiblePane(onDismissed: () {}),
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          flex: 2,
                          onPressed: (_) {
                            markAsCompleted(dst['id']);
                          },
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          icon: Icons.safety_check,
                          label: 'set as pending',
                        ),
                      ]),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
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
                            Text('status:${dst['status']}')
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
                                isEdit:
                                    true, // Indicate that this is an edit action
                                eventData: {
                                  'id': dst['id'],
                                  'date': dst['date'],
                                  'time': dst['time'],
                                  'address': dst['address'],
                                  'state': dst['state'],
                                  'city': dst['city'],
                                  'remark': dst['remark'],
                                  'mobile_no': dst['mobile_no'],
                                  'status': dst['status'],
                                },
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.edit, color: Colors.orange),
                      ),
                      onTap: () {
                        showsheet(
                            dst['date'],
                            dst['time'],
                            dst['address'],
                            dst['state'],
                            dst['city'],
                            dst['remark'],
                            dst['mobile_no']);
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
        return const Center(child: Text('No Completed events found.'));
      },
    );
  }
}
