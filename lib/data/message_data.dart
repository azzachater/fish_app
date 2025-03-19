import '../models/message_model.dart';
import 'user_data.dart';


final List<Message> recentChats = [
  Message(
    sender: addison,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Addison.jpg',
    time: '01:25',
    text: "typing...",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    sender: jason,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Jason.jpg',
    time: '12:46',
    text: "Will I be in it?",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    sender: deanna,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Deanna.jpg',
    time: '05:26',
    text: "That's so cute.",
    unreadCount: 3,
    isRead: false,
  ),
  Message(
    sender: nathan,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Nathan.jpg',
    time: '12:45',
    text: "Let me see what I can do.",
    unreadCount: 2,
    isRead: false,
  ),
];

final List<Message> allChats = [
  Message(
    sender: virgil,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Virgil.jpg',
    time: '12:59',
    text: "No! I just wanted",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: stanley,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Stanley.jpg',
    time: '10:41',
    text: "You did what?",
    unreadCount: 1,
    isRead: false,
  ),
  Message(
    sender: leslie,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Leslie.jpg',
    time: '05:51',
    text: "just signed up for a tutor",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: judd,
    receiver: currentUser, // Ajout du receiver
    avatar: 'assets/images/users/Judd.jpg',
    time: '10:16',
    text: "May I ask you something?",
    unreadCount: 2,
    isRead: false,
  ),
];

final List<Message> messages = [
  Message(
    sender: addison,
    receiver: currentUser, // Ajout du receiver
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "...",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: currentUser,
    receiver: addison, // Ajout du receiver
    time: '12:05 AM',
    text: "I’m going home.",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: currentUser,
    receiver: addison, // Ajout du receiver
    time: '12:05 AM',
    text: "See, I was right, this doesn’t interest me.",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: addison,
    receiver: currentUser, // Ajout du receiver
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "I sign your paychecks.",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: addison,
    receiver: currentUser, // Ajout du receiver
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "You think we have nothing to talk about?",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: currentUser,
    receiver: addison, // Ajout du receiver
    time: '11:45 PM',
    text: "Well, because I had no intention of being in your office. 20 minutes ago",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: addison,
    receiver: currentUser, // Ajout du receiver
    time: '11:30 PM',
    avatar: addison.avatar,
    text: "I was expecting you in my office 20 minutes ago.",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: jason,
    receiver: currentUser, // Ajout du receiver
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "...",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: currentUser,
    receiver: jason, // Ajout du receiver
    time: '12:05 AM',
    text: "I’m going home.",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: currentUser,
    receiver: jason, // Ajout du receiver
    time: '12:05 AM',
    text: "See, I was right, this doesn’t interest me.",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: jason,
    receiver: currentUser, // Ajout du receiver
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "I sign your paychecks.",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: jason,
    receiver: currentUser, // Ajout du receiver
    time: '11:58 PM',
    avatar: addison.avatar,
    text: "You think we have nothing to talk about?",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: currentUser,
    receiver: jason, // Ajout du receiver
    time: '11:45 PM',
    text: "Well, because I had no intention of being in your office. 20 minutes ago",
    avatar: currentUser.avatar,
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: jason,
    receiver: currentUser, // Ajout du receiver
    time: '11:30 PM',
    avatar: addison.avatar,
    text: "I was expecting you in my office 20 minutes ago.",
    unreadCount: 0,
    isRead: false,
  ),
];


final List<Message> groupMessages = [
  Message(
    sender: addison,
    groupId: '1', // ID du groupe "Fishing Events"
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
    groupId: '2', // Groupe différent (ex : Flutter Devs)
    time: '10:30 AM',
    avatar: currentUser.avatar,
    text: "Bienvenue dans le groupe Flutter Devs !",
    unreadCount: 0,
    isRead: false,
  ),
  Message(
    sender: addison,
    groupId: '2', // ID du groupe "Fishing Events"
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Il y a un nouvel événement !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: currentUser,
    groupId: '0',
    time: '11:30 AM',
    avatar: currentUser.avatar,
    text: "C'est quoi cet événement ?",
    unreadCount: 0,
    isRead: false,
  ),Message(
    sender: addison,
    groupId: '0', // ID du groupe "Fishing Events"
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Il y a un nouvel événement !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: leslie,
    groupId: '0',
    time: '11:30 AM',
    avatar: leslie.avatar,
    text: "C'est quoi cet événement ?",
    unreadCount: 0,
    isRead: false,
  ),Message(
    sender: addison,
    groupId: '3', // ID du groupe "Fishing Events"
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Il y a un nouvel événement !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: judd,
    groupId: '3',
    time: '11:30 AM',
    avatar: judd.avatar,
    text: "C'est quoi cet événement ?",
    unreadCount: 0,
    isRead: false,
  ),Message(
    sender: addison,
    groupId: '4', // ID du groupe "Fishing Events"
    time: '12:09 AM',
    avatar: addison.avatar,
    text: "Il y a un nouvel événement !",
    unreadCount: 0,
    isRead: true,
  ),
  Message(
    sender: jason,
    groupId: '4',
    time: '11:30 AM',
    avatar: jason.avatar,
    text: "C'est quoi cet événement ?",
    unreadCount: 0,
    isRead: false,
  ),
];

void markMessageAsRead(int index) {
  final Message message = recentChats[index];
  final Message updatedMessage = message.copyWith(isRead: true, unreadCount: 0);
  recentChats[index] = updatedMessage;
}