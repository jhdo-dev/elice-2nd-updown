import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersCollection = FirebaseFirestore.instance.collection('users');
final roomsCollection = FirebaseFirestore.instance.collection('rooms');
final messagesCollection = FirebaseFirestore.instance.collection('messages');
final participantsCollection =
    FirebaseFirestore.instance.collection('participants');
final fbAuth = FirebaseAuth.instance;
