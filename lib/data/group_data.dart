import 'user_data.dart';
import '../models/group_model.dart';
//import '../models/message_model.dart';

final List<Group> recentGroups = [
  Group(
    id:'0' ,
    name: 'Fish Camp',
    avatar: 'assets/images/groups/group1.png',
    members: [addison, angel, deanna],
    admin: addison,
    unreadCount: 2,
    isRead:false,
    time: '12:30 PM',
  ),
  Group(
    id:'1' ,
    name: 'fishing events',
    avatar: 'assets/images/groups/group2.png',
    members: [jason, judd, leslie],
    admin: addison,
    unreadCount: 5,
    isRead:false,
    time: '11:00 AM',
  ),
  // Add more groups as needed
];
final List<Group> allGroups = [
  Group(
    id:'2',
    name: 'Flutter Devs',
    avatar: 'assets/images/groups/group1.png',
    members: [addison, angel, deanna],
    admin: addison,
    unreadCount: 2,
    isRead:false,
    time: '12:30 PM',
  ),
  Group(
    id:'3',
    name: 'Dart Enthusiasts',
    avatar: 'assets/images/groups/group2.png',
    members: [addison, angel, deanna],
    admin: addison,
    unreadCount: 5,
    isRead:false,
    time: '11:00 AM',
  ),
  Group(
    id:'4',
    name: 'fishing lovers',
    avatar: 'assets/images/groups/group2.png',
    members: [addison, angel, deanna],
    admin: addison,
    unreadCount: 0,
    isRead: true,
    time: '13:00 AM',
  ),
  // Add more groups as needed
];

/*final List<Message> groupMessages = [
  Message(
    sender: addison,
    groupId: '1', // ID du groupe
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Il y a un nouvel événement !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: currentUser,
    groupId: '1',
    time: '11:30 AM',
    avatar: currentUser.avatar,
    text: "C'est quoi cet événement ?",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: jason,
    groupId: '1',
    time: '11:12 AM',
    avatar: jason.avatar,
    text: "Salut tout le monde !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: currentUser,
    groupId: '2', // Un autre groupe
    time: '10:30 AM',
    avatar: currentUser.avatar,
    text: "Bienvenue dans le groupe !",
    unreadCount: 0,
    isRead: false,
  ),
];
*/