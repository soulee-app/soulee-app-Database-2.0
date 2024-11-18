import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';

class Post {
  String reaction;
  List<String> comments;
  String profilePic;
  String username;
  String caption;
  String postImage;

  Post({
    this.reaction = '',
    this.comments = const [],
    this.profilePic = '',
    this.username = '',
    this.caption = '',
    this.postImage = '',
  });
}

class FeedScreen extends StatelessWidget {
  final DatabaseManager databaseManager;

  const FeedScreen({super.key, required this.databaseManager});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dynamic Post Reactions & Comments',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(databaseManager: databaseManager),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final DatabaseManager databaseManager;

  const MyHomePage({super.key, required this.databaseManager});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Post> posts = [
    Post(
      username: "Demo User",
      profilePic: 'assets/defImg.png',
      caption: "What a beautiful day!",
      postImage: 'https://via.placeholder.com/300',
    ),
  ];

  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isFabOpen = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final fetchedPosts = await widget.databaseManager.fetchFeedPosts();
      setState(() {
        posts = fetchedPosts.map((postData) {
          return Post(
            username: postData['username'] ?? 'Unknown User',
            profilePic: postData['profilePic'] ?? 'assets/defImg.png',
            caption: postData['caption'] ?? 'What a beautiful day!',
            postImage:
                postData['postImage'] ?? 'https://via.placeholder.com/300',
            comments: List<String>.from(postData['comments'] ?? []),
          );
        }).toList();
      });
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  void _showFloatingReactions(
      BuildContext context, int index, GlobalKey reactButtonKey) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }

    final RenderBox renderBox =
        reactButtonKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + 50,
        top: offset.dy - 100,
        child: Material(
          color: Colors.transparent,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(0, -50),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 6,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _imageReactionOption("assets/flowers/Tulip.png", index),
                  _imageReactionOption("assets/flowers/Shiuli.png", index),
                  _imageReactionOption("assets/flowers/Rui.png", index),
                  _imageReactionOption("assets/flowers/Golap 1.png", index),
                  _imageReactionOption("assets/flowers/Joba.png", index),
                  _imageReactionOption("assets/flowers/Surjo Mukhi.png", index),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _toggleFabMenu() {
    setState(() {
      _isFabOpen = !_isFabOpen;
    });
  }

  Widget _imageReactionOption(String imagePath, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          posts[index].reaction = imagePath;
        });
        _removeOverlay();
      },
      child: AnimatedScale(
        scale: posts[index].reaction == imagePath ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Image.asset(
          imagePath,
          width: 40,
          height: 40,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: screenHeight * 0.01),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(posts.length, (index) {
                  GlobalKey reactButtonKey = GlobalKey();

                  return PostWidget(
                    post: posts[index],
                    index: index,
                    reactButtonKey: reactButtonKey,
                    showFloatingReactions: () =>
                        _showFloatingReactions(context, index, reactButtonKey),
                    removeOverlay: _removeOverlay,
                    navigateToCommentPage: () =>
                        _navigateToCommentPage(context, index),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (_isFabOpen) ...[
            FloatingActionButton.extended(
              onPressed: () {
                print("Post Something Selected");
              },
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.create),
              label: const Text("Post Something"),
              heroTag: 'post_something',
            ),
            const SizedBox(height: 10),
            FloatingActionButton.extended(
              onPressed: () {
                print("Add Memories Selected");
              },
              backgroundColor: Colors.redAccent,
              icon: const Icon(Icons.photo_library),
              label: const Text("Add Memories"),
              heroTag: 'add_memories',
            ),
          ],
          FloatingActionButton(
            onPressed: _toggleFabMenu,
            backgroundColor: Colors.redAccent,
            heroTag: 'main_fab',
            child: Icon(_isFabOpen ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }

  void _navigateToCommentPage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentPage(post: posts[index], postIndex: index),
      ),
    );
  }
}

class PostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final GlobalKey reactButtonKey;
  final VoidCallback showFloatingReactions;
  final VoidCallback removeOverlay;
  final VoidCallback navigateToCommentPage;

  const PostWidget({
    super.key,
    required this.post,
    required this.index,
    required this.reactButtonKey,
    required this.showFloatingReactions,
    required this.removeOverlay,
    required this.navigateToCommentPage,
  });

  @override
  Widget build(BuildContext context) {
    Widget reactionIcon = post.reaction.isEmpty
        ? const Icon(
            Icons.local_florist,
            color: Colors.grey,
          )
        : Image.asset(
            post.reaction,
            width: 30,
            height: 30,
          );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 10,
                left: 10,
                child: CircleAvatar(
                  backgroundImage: post.profilePic.isNotEmpty
                      ? (post.profilePic.startsWith('http')
                          ? NetworkImage(post.profilePic)
                          : AssetImage(post.profilePic)) as ImageProvider
                      : const AssetImage('assets/defImg.png'),
                  radius: 25,
                ),
              ),
              Positioned(
                top: 20,
                left: 70,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '1 hour ago',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 15,
                child: IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    print("More options clicked");
                  },
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.caption),
              const SizedBox(height: 10),
              Image.network(post.postImage),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                key: reactButtonKey,
                icon: reactionIcon,
                onPressed: showFloatingReactions,
              ),
              Text(
                post.reaction.isEmpty ? "No reaction" : '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.insert_comment_rounded),
                onPressed: navigateToCommentPage,
              ),
              Text('${post.comments.length} comments'),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.share_rounded),
                onPressed: () {
                  print("Post shared");
                },
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

class CommentPage extends StatelessWidget {
  final Post post;
  final int postIndex;

  const CommentPage({super.key, required this.post, required this.postIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments for ${post.username}'s post"),
      ),
      body: ListView(
        children: [
          ...post.comments.map((comment) => ListTile(
                title: Text(comment),
              )),
        ],
      ),
    );
  }
}
