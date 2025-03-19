
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../screens/social_network/comment_page.dart';
import '../../models/post_model.dart';

class PostWidget extends StatefulWidget {
  final Post post;

  const PostWidget({super.key, required this.post});

  @override
  PostWidgetState createState() => PostWidgetState();
}

class PostWidgetState extends State<PostWidget> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.isLiked;
    likeCount = widget.post.likeCount;
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
  }

  void navigateToComments() {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CommentPage(post: widget.post), // Passer l'objet Post complet
  ),
);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(widget.post.user.avatar), // Utilisation de l'avatar
              radius: 22,
            ),
            title: Text(
              widget.post.user.name, // Utilisation du nom de l'utilisateur
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              widget.post.timestamp,
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
            contentPadding: EdgeInsets.all(10),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.post.postText,
                style: TextStyle(fontSize: 14, height: 1.5),
                textAlign: TextAlign.left,
              ),
            ),
          ),
          if (widget.post.postImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(widget.post.postImage!),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.thumbsUp,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: toggleLike,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '$likeCount Likes',
                      style: TextStyle(color: isLiked ? Colors.blue : Colors.grey),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.commentDots,
                        color: Colors.grey,
                      ),
                      onPressed: navigateToComments,
                    ),
                    SizedBox(width: 4),
                    Text('Comment', style: TextStyle(color: Colors.grey)),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        FontAwesomeIcons.share,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    SizedBox(width: 4),
                    Text('Share', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
