import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:navbar/main_screens/games_screen.dart';
import '../api/apis.dart';
import '../helper/my_date_util.dart';
import '../../main.dart';
import '../models/chat_user.dart';
import '../models/message.dart';
import '../widgets/message_card.dart';
import '../widgets/profile_image.dart';
import 'ai_screen.dart';
import 'view_profile_screen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart'; // To get temporary directory path
import 'package:flutter_sound/flutter_sound.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //for storing all messages
  List<Message> _list = [];
  bool isSwitched = false;

  //for handling message text changes
  final _textController = TextEditingController();

  //showEmoji -- for storing value of showing or hiding emoji
  //isUploading -- for checking if image is uploading or not?
  bool _showEmoji = false, _isUploading = false;

  bool _isRecording = false;
  late FlutterSoundRecorder _recorder;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await _recorder.openRecorder();
  }

  Future<void> _startRecording() async {
    final Directory tempDir = await getTemporaryDirectory();
    _recordedFilePath = '${tempDir.path}/voice_message.m4a';

    await _recorder.startRecorder(
      toFile: _recordedFilePath,
      codec: Codec.aacMP4, // Or use another codec if needed
    );

    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
    });

    // Send the recorded audio
    if (_recordedFilePath != null) {
      setState(() => _isUploading = true);
      await APIs.sendVoice(widget.user, File(_recordedFilePath!));
      setState(() => _isUploading = false);
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: PopScope(
        canPop: false,

        onPopInvoked: (_) {
          if (_showEmoji) {
            setState(() => _showEmoji = !_showEmoji);
            return;
          }

          // some delay before pop
          Future.delayed(const Duration(milliseconds: 300), () {
            try {
              if (Navigator.canPop(context)) Navigator.pop(context);
            } catch (e) {
              log('ErrorPop: $e');
            }
          });
        },

        //
        child: Scaffold(
          //app bar
          appBar: AppBar(
            automaticallyImplyLeading: false,
            flexibleSpace: _appBar(),
            toolbarHeight: 100,
            backgroundColor: Colors.black,
          ),

          backgroundColor: Colors.black,

          //body
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        //if data is loading
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();

                        //if some or all data is loaded then show it
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;
                          _list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (_list.isNotEmpty) {
                            return ListView.builder(
                              reverse: true,
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: mq.height * .01),
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return MessageCard(message: _list[index]);
                              },
                            );
                          } else {
                            return const Center(
                              child: Text(
                                'Say Hii! 👋',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white),
                              ),
                            );
                          }
                      }
                    },
                  ),
                ),

                //progress indicator for showing uploading
                if (_isUploading)
                  const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                          child: CircularProgressIndicator(strokeWidth: 2))),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Buttons(
                            imagePath: 'assetsm/suggestions_predictions.png',
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AiScreen()));
                            },
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Buttons(
                                    imagePath: 'assetsm/nsfw.png',
                                    onTap: () {}),
                                Transform.scale(
                                  scale:
                                      0.7, // Adjust the scale factor to make the switch smaller
                                  child: Switch(
                                    activeColor: Colors.black,
                                    inactiveTrackColor: Colors.grey,
                                    value: isSwitched,
                                    onChanged: (value) {
                                      setState(() {
                                        isSwitched = value;
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Buttons(imagePath: 'assetsm/set.png', onTap: () {})
                        ],
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.blue),
                          child: Image.asset(
                            'assetsm/themes.png',
                            height: 30,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.00),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Buttons(
                                    imagePath: 'assetsm/books.png',
                                    onTap: () {}),
                                const SizedBox(
                                  width: 4,
                                ),
                                Buttons(
                                    imagePath: 'assetsm/music.png',
                                    onTap: () {}),
                                const SizedBox(
                                  width: 4,
                                ),
                                Buttons(
                                    imagePath: 'assetsm/movies.png',
                                    onTap: () {})
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white),
                            child: Row(
                              children: [
                                Buttons(
                                    imagePath: 'assetsm/quiz.png',
                                    onTap: () {}),
                                Buttons(
                                    imagePath: 'assetsm/games.png',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const GameScreeen()),
                                      );
                                    })
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.blue),
                        child: IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() => _showEmoji = !_showEmoji);
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.yellow,
                            )),
                      ),
                    ],
                  ),
                ),
                //chat input filed
                _chatInput(),

                //show emojis on keyboard emoji button click & vice versa
                if (_showEmoji)
                  SizedBox(
                    height: mq.height * .35,
                    child: EmojiPicker(
                      textEditingController: _textController,
                      config: const Config(),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return SafeArea(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //user profile picture

                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ProfileImage(
                        size: mq.height * .06,
                        url:
                            list.isNotEmpty ? list[0].image : widget.user.image,
                      ),
                    ),

                    //for adding some space
                    const SizedBox(width: 10),

                    //user name & last seen time
                    Column(
                      children: [
                        //user name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: mq.width * 0.4,
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: const Color(0xFFD5D1C7),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: list.isNotEmpty
                                          ? CircleAvatar(
                                              radius: 5,
                                              backgroundColor: list[0].isOnline
                                                  ? Colors.red
                                                  : Colors.grey,
                                            )
                                          : Text(
                                              MyDateUtil.getLastActiveTime(
                                                  context: context,
                                                  lastActive:
                                                      widget.user.lastActive),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54),
                                            ),
                                    ),
                                    Expanded(
                                      // Use Expanded here to take remaining space
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0,
                                            bottom: 4,
                                            left: 4,
                                            right: 12),
                                        child: Text(
                                          (list.isNotEmpty
                                              ? list[0].name
                                              : widget.user.name),
                                          style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500),
                                          maxLines:
                                              1, // Display only one line of text
                                          overflow: TextOverflow
                                              .ellipsis, // Add "..." if text overflows
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 70,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                        size: 25,
                                      ),
                                      FittedBox(
                                        fit: BoxFit
                                            .scaleDown, // Ensures the switch fits inside the container
                                        child: Switch(
                                          inactiveTrackColor: Colors.grey,
                                          activeColor: Colors.black,
                                          value: isSwitched,
                                          materialTapTargetSize:
                                              MaterialTapTargetSize
                                                  .shrinkWrap, // Reduce the size of the touch area
                                          onChanged: (value) {
                                            setState(() {
                                              isSwitched = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Container(
                                  width: 50,
                                  height: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  child: const Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Icon(
                                          Icons.calendar_month_outlined,
                                          color: Colors.black,
                                          size: 16,
                                        ),
                                      ),
                                      Text(
                                        '1 Day',
                                        style: TextStyle(
                                            fontSize: 8, color: Colors.black),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Icon(
                                  Icons.info,
                                  color: Colors.red,
                                ),
                              ],
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //last seen time of user

                            Container(
                              child: list.isNotEmpty
                                  ? list[0].isOnline
                                      ? Container(
                                          width: mq.width * .3,
                                          height: mq.height * .05,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                            image: AssetImage(
                                                'assetsm/cloud.png'), // Replace with your image path
                                            fit: BoxFit
                                                .cover, // Adjust how the image fits within the container
                                          )),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  // Initiating the audio call
                                                  await APIs.startAudioCall(
                                                      widget.user);
                                                },
                                                icon: Image.asset(
                                                  'assetsm/call.png', // Replace with your image path
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  // Initiating the video call
                                                  await APIs.startVideoCall(
                                                      widget.user);
                                                },
                                                icon: Image.asset(
                                                  'assetsm/video_call.png', // Replace with your image path
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : SizedBox(
                                          width: mq.width * .3,
                                          height: mq.height * .05,
                                          child: Text(
                                              MyDateUtil.getLastActiveTime(
                                                  context: context,
                                                  lastActive:
                                                      list[0].lastActive),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.white)),
                                        )
                                  : Text(
                                      MyDateUtil.getLastActiveTime(
                                          context: context,
                                          lastActive: widget.user.lastActive),
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),

                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFFD5D1C7),
                              ),
                              child: Row(
                                children: [
                                  Image.asset('assetsm/msg.png'),
                                  Text(
                                    _list.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.ios_share_rounded,
                                      color: Colors.black,
                                      size: 18,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Container(
                              height: 40,
                              width: mq.width * 0.3,
                              color: Colors.white,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // bottom chat input field
  Widget _chatInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, left: 8.00, right: 8.00),
      child: Row(
        children: [
          Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                GestureDetector(
                  onLongPressStart: (_) async {
                    await _startRecording();
                  },
                  onLongPressEnd: (_) async {
                    await _stopRecording();
                  },
                  child: Buttons(
                    imagePath: 'assetsm/microphone.png',
                    onTap: () {}, // Disable tap while recording
                  ),
                ),
                Buttons(
                  imagePath: 'assetsm/images.png',
                  onTap: () async {
                    final ImagePicker picker = ImagePicker();

                    // Picking multiple images
                    final List<XFile> images =
                        await picker.pickMultiImage(imageQuality: 70);

                    // uploading & sending image one by one
                    for (var i in images) {
                      log('Image Path: ${i.path}');
                      setState(() => _isUploading = true);
                      await APIs.sendChatImage(widget.user, File(i.path));
                      setState(() => _isUploading = false);
                    }
                  },
                ),
                Buttons(
                  imagePath: 'assetsm/attachment.png',
                  onTap: () async {
                    // Picking files (can include any type of file)
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      allowMultiple: true,
                      type: FileType
                          .any, // You can restrict to specific types if needed
                    );

                    if (result != null) {
                      // If files were selected, proceed with uploading them
                      List<PlatformFile> files = result.files;

                      for (var file in files) {
                        log('File Path: ${file.path}');
                        if (file.path != null) {
                          // Ensure path is not null and then proceed to send the file
                          setState(() => _isUploading = true);
                          await APIs.sendAttachmentFile(
                              widget.user, File(file.path!));
                          setState(() => _isUploading = false);
                        }
                      }
                    } else {
                      log('No files selected');
                    }
                  },
                )
              ],
            ),
          ),
          const SizedBox(
            width: 4,
          ),
          //input field & buttons
          Expanded(
            child: Card(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Row(
                children: [
                  //emoji button

                  Expanded(
                      child: TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onTap: () {
                      if (_showEmoji) setState(() => _showEmoji = !_showEmoji);
                    },
                    decoration: const InputDecoration(
                        hintText: 'Type Something...',
                        hintStyle: TextStyle(color: Colors.black),
                        border: InputBorder.none),
                  )),

                  //pick image from gallery button

                  //adding some space
                  SizedBox(width: mq.width * .02),
                ],
              ),
            ),
          ),

          //send message button
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  //on first message (add user to my_user collection of chat user)
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  //simply send message
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.blue,
            child: const Icon(Icons.send, color: Colors.white, size: 28),
          )
        ],
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final String imagePath; // Path for the image
  final VoidCallback onTap; // Widget to navigate to

  const Buttons({
    required this.imagePath,
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Image.asset(
            imagePath,
            width: 35,
          ),
        ),
      ),
    );
  }
}
