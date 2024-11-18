import 'package:flutter/material.dart';

enum CallType { audio, video }

class CallWidget extends StatefulWidget {
  final String callerName;
  final bool missedCall; // true if the call was missed
  final VoidCallback onAcceptCall;
  final VoidCallback onRejectCall;
  final VoidCallback onCallAgain; // For missed call "Call Again"
  final CallType callType; // Specify whether it's an audio or video call

  const CallWidget({
    super.key,
    required this.callerName,
    required this.missedCall,
    required this.onAcceptCall,
    required this.onRejectCall,
    required this.onCallAgain,
    required this.callType,
  });

  @override
  State<CallWidget> createState() => _CallWidgetState();
}

class _CallWidgetState extends State<CallWidget> {
  @override
  Widget build(BuildContext context) {
    // Show the missed call ListTile if the call was missed
    if (widget.missedCall) {
      return ListTile(
        leading: const Icon(
          Icons.call_missed,
          color: Colors.red,
        ),
        title: Text(
          widget.callType == CallType.audio
              ? 'Missed Audio Call'
              : 'Missed Video Call',
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: const Text('Call again'),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green),
          onPressed: widget.onCallAgain,
        ),
      );
    }

    // Show the normal call UI based on the call type
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: const Color(0xFFD5D1C7),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFFD5D1C7)),
      ),
      child: Column(
        children: [
          // First row: Calling details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.callerName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    Text(
                      widget.callType == CallType.audio
                          ? 'Audio Call'
                          : 'Video Call',
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Second row: Accept and Reject buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Accept Call
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: widget.callType == CallType.audio
                        ? Colors.blue
                        : Colors.green),
                icon: Icon(widget.callType == CallType.audio
                    ? Icons.call
                    : Icons.videocam),
                label: Text(widget.callType == CallType.audio
                    ? 'Accept Audio'
                    : 'Accept Video'),
                onPressed: widget.onAcceptCall,
              ),
              // Reject Call
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.call_end),
                label: const Text('Reject'),
                onPressed: widget.onRejectCall,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
