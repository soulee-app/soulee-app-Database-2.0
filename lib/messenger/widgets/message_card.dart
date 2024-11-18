import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:gallery_saver_updated/gallery_saver.dart';

import '../api/apis.dart';
import '../helper/atachmentwidget.dart';
import '../helper/callwidget.dart';
import '../helper/dialogs.dart';
import '../helper/my_date_util.dart';
import '../../../main.dart';
import '../models/message.dart';

// for showing single message details
class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
        onLongPress: () => _showBottomSheet(isMe),
        child: isMe ? _greenMessage() : _blueMessage());
  }

  // sender or another user message
  Widget _blueMessage() {
    //update last read message if sender and receiver are different
    if (widget.message.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          //t
          child: Container(
            padding: EdgeInsets.all(
              widget.message.type == Type.image
                  ? mq.width * .03
                  : mq.width * .04,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD5D1C7),
              border: Border.all(color: const Color(0xFFD5D1C7)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: _buildMessageContent(widget.message),
          ),
        ),

        //message time
        Padding(
          padding: EdgeInsets.only(right: mq.width * .04),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(fontSize: 13, color: Color(0xFFD5D1C7)),
          ),
        ),
      ],
    );
  }

  // our or user message
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //message time
        Row(
          children: [
            //for adding some space
            SizedBox(width: mq.width * .04),

            //double tick blue icon for message read
            if (widget.message.read.isNotEmpty)
              const Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),

            //for adding some space
            const SizedBox(width: 2),

            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(fontSize: 13, color: Color(0xFFD5D1C7)),
            ),
          ],
        ),

        //message content
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == Type.image
                ? mq.width * .03
                : mq.width * .04),
            margin: EdgeInsets.symmetric(
              horizontal: mq.width * .04,
              vertical: mq.height * .01,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFD5D1C7),
              border: Border.all(color: const Color(0xFFD5D1C7)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: _buildMessageContent(widget.message),
          ),
        ),
      ],
    );
  }

  // bottom sheet for modifying message details
  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              //black divider
              Container(
                height: 4,
                margin: EdgeInsets.symmetric(
                    vertical: mq.height * .015, horizontal: mq.width * .4),
                decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),

              widget.message.type == Type.text
                  ?
                  //copy option
                  _OptionItem(
                      icon: const Icon(Icons.copy_all_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Copy Text',
                      onTap: () async {
                        await Clipboard.setData(
                                ClipboardData(text: widget.message.msg))
                            .then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);

                          Dialogs.showSnackbar(context, 'Text Copied!');
                        });
                      })
                  :
                  //save option
                  _OptionItem(
                      icon: const Icon(Icons.download_rounded,
                          color: Colors.blue, size: 26),
                      name: 'Save Image',
                      onTap: () {}
                      // async {
                      //   try {
                      //     log('Image Url: ${widget.message.msg}');
                      //     await GallerySaver.saveImage(widget.message.msg,
                      //             albumName: 'Soulee')
                      //         .then((success) {
                      //       //for hiding bottom sheet
                      //       Navigator.pop(context);
                      //       if (success != null && success) {
                      //         Dialogs.showSnackbar(
                      //             context, 'Image Successfully Saved!');
                      //       }
                      //     },
                      //     );
                      //   } catch (e) {
                      //     log('ErrorWhileSavingImg: $e');
                      //   }
                      // }
                      ),

              //separator or divider
              if (isMe)
                Divider(
                  color: Colors.black54,
                  endIndent: mq.width * .04,
                  indent: mq.width * .04,
                ),

              //edit option
              if (widget.message.type == Type.text && isMe)
                _OptionItem(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 26),
                    name: 'Edit Message',
                    onTap: () {
                      //for hiding bottom sheet
                      Navigator.pop(context);

                      _showMessageUpdateDialog();
                    }),

              //delete option
              if (isMe)
                _OptionItem(
                    icon: const Icon(Icons.delete_forever,
                        color: Colors.red, size: 26),
                    name: 'Delete Message',
                    onTap: () async {
                      await APIs.deleteMessage(widget.message).then((value) {
                        //for hiding bottom sheet
                        Navigator.pop(context);
                      });
                    }),

              //separator or divider
              Divider(
                color: Colors.black54,
                endIndent: mq.width * .04,
                indent: mq.width * .04,
              ),

              //sent time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),

              //read time
              _OptionItem(
                  icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                  name: widget.message.read.isEmpty
                      ? 'Read At: Not seen yet'
                      : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.read)}',
                  onTap: () {}),
            ],
          );
        });
  }

  //dialog for updating message content
  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.blue,
                    size: 28,
                  ),
                  Text(' Update Message')
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                      APIs.updateMessage(widget.message, updatedMsg);
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ))
              ],
            ));
  }
}

//custom options card (for copy, edit, delete, etc.)
class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(),
      child: Padding(
        padding: EdgeInsets.only(
            left: mq.width * .05,
            top: mq.height * .015,
            bottom: mq.height * .015),
        child: Row(children: [
          icon,
          Flexible(
              child: Text('    $name',
                  style: const TextStyle(
                      fontSize: 15, color: Colors.black54, letterSpacing: 0.5)))
        ]),
      ),
    );
  }
}

class VoiceMessageWidget extends StatefulWidget {
  final String audioUrl;

  const VoiceMessageWidget({super.key, required this.audioUrl});

  @override
  _VoiceMessageWidgetState createState() => _VoiceMessageWidgetState();
}

class _VoiceMessageWidgetState extends State<VoiceMessageWidget> {
  final AudioPlayer player = AudioPlayer();
  bool isPlaying = false; // Track playback state

  @override
  void dispose() {
    player.dispose(); // Dispose of the player to free resources
    super.dispose();
  }

  String formatDuration(Duration duration) {
    return '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress indicator for audio playback
        StreamBuilder<Duration>(
          stream: player.positionStream,
          builder: (context, positionSnapshot) {
            final position = positionSnapshot.data ?? Duration.zero;

            return StreamBuilder<Duration?>(
              stream: player.durationStream,
              builder: (context, durationSnapshot) {
                final duration = durationSnapshot.data ?? Duration.zero;

                // Calculate the progress as a fraction of total duration
                final progress = duration.inSeconds > 0
                    ? position.inSeconds / duration.inSeconds
                    : 0.0;

                return Column(
                  children: [
                    // Linear progress bar
                    LinearProgressIndicator(
                      value: progress, // Value between 0.0 and 1.0
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    // Duration display and play/pause button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatDuration(position)} / ${formatDuration(duration)}',
                          style: const TextStyle(
                              fontSize: 12, color: Colors.black54),
                        ),
                        IconButton(
                          icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow,
                            size: 30,
                            color: Colors.black87,
                          ),
                          onPressed: () async {
                            if (isPlaying) {
                              await player.pause(); // Pause the audio
                            } else {
                              try {
                                await player.setUrl(
                                    widget.audioUrl); // Set the audio source
                                await player.play(); // Play the audio
                              } catch (e) {
                                print(
                                    'Error playing audio: $e'); // Handle error
                              }
                            }
                            setState(() {
                              isPlaying = !isPlaying; // Toggle playback state
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// Function to build message content based on type
Widget _buildMessageContent(Message message) {
  switch (message.type) {
    case Type.text:
      return Text(
        message.msg,
        style: const TextStyle(
          fontSize: 15,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      );
    case Type.image:
      return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: CachedNetworkImage(
          imageUrl: message.msg,
          fit: BoxFit.cover,
          placeholder: (context, url) => const Padding(
            padding: EdgeInsets.all(8.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          errorWidget: (context, url, error) =>
              const Icon(Icons.image, size: 70),
        ),
      );
    case Type.voice:
      return VoiceMessageWidget(audioUrl: message.msg);
    case Type.attachment:
    case Type.attachment:
    case Type.attachment:
      return AttachmentWidget(
        name: message.fileName ??
            'Unknown File', // Provide a default name if fileName is null
        type: message.msg.split('?')[0].contains('.')
            ? message.msg
                .split('?')[0]
                .split('.')
                .last
                .toUpperCase() // Extracting extension safely
            : 'UNKNOWN', // Default type if no extension found
        url: message.msg, // Assuming this holds the download URL
      );
    case Type.audioCall:
      bool isCallActive = false; // Track call state
      return CallWidget(
        callerName: message.fromId,
        missedCall: !isCallActive, // Set to true if call is missed
        callType: CallType.audio,
        onAcceptCall: () {
          isCallActive = true; // Call has started
          // Add any additional logic for starting the call
        },
        onCallAgain: () {},
        onRejectCall: () {
          isCallActive = false; // Call is rejected
          // Handle missed call logic, e.g., setting missedCall to true
        },
      );

    case Type.videoCall:
      bool isVideoCallActive = false; // Track video call state
      return CallWidget(
        callerName: message.fromId,
        missedCall: !isVideoCallActive, // Set to true if call is missed
        callType: CallType.video,
        onCallAgain: () {
          // Logic to handle calling again
        },
        onRejectCall: () {
          isVideoCallActive = false; // Video call is rejected
          // Handle missed call logic, e.g., setting missedCall to true
        },
        onAcceptCall: () {
          isVideoCallActive = true; // Video call has started
          // Add any additional logic for starting the video call
        },
      );

    default:
      return Container(); // Handle unsupported types
  }
}
