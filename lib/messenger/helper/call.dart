import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

import '../api/apis.dart';
import '../models/chat_user.dart';

class CallPage extends StatefulWidget {
  final ChatUser chatUser;
  final bool isVideoCall;
  final String callId;

  const CallPage({
    required this.chatUser,
    required this.isVideoCall,
    required this.callId,
    super.key,
  });

  @override
  _CallPageState createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool _isMuted = false;
  bool _isCameraSwitched = false;
  late RTCPeerConnection _peerConnection;

  @override
  void initState() {
    super.initState();
    initRenderers();
    _startCall();
  }

  Future<void> initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  Future<void> _startCall() async {
    // Initialize WebRTC and create peer connection
    _peerConnection = await _createPeerConnection();

    // Start ringing, accept/reject logic (30 seconds timeout)
    _setupCallTimeout();
    _setupSignaling();
  }

  Future<RTCPeerConnection> _createPeerConnection() async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };
    final constraints = {
      'mandatory': {},
      'optional': [],
    };

    final pc = await createPeerConnection(configuration, constraints);

    pc.onIceCandidate = (candidate) {
      // Send candidate to Firestore for signaling
      APIs.sendIceCandidate(widget.chatUser, candidate.toMap());
    };

    pc.onTrack = (track) {
      if (track.track.kind == 'video') {
        _remoteRenderer.srcObject = track.streams[0];
      }
    };

    return pc;
  }

  Future<void> _setupSignaling() async {
    // Listen to Firebase signaling for offer/answer and ICE candidates
    APIs.listenForSignaling(widget.callId, _peerConnection);
  }

  void _setupCallTimeout() {
    Future.delayed(const Duration(seconds: 30), () {
      if (mounted) {
        // End call if not accepted within 30 seconds
        _endCall();
      }
    });
  }

  void _endCall() {
    APIs.endCall(widget.callId);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _peerConnection.dispose();
    super.dispose();
  }

  // UI for the Call Screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isVideoCall ? 'Video Call' : 'Audio Call'),
        actions: [
          IconButton(
            icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
            onPressed: _toggleMute,
          ),
          IconButton(
            icon: const Icon(Icons.switch_camera),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          widget.isVideoCall
              ? RTCVideoView(_remoteRenderer)
              : const Center(child: Text("Audio Call in Progress")),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _endCall,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.call_end),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Toggle microphone mute
  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _localRenderer.srcObject?.getAudioTracks().first.enabled = !_isMuted;
    });
  }

  // Switch between front and rear cameras
  void _switchCamera() async {
    final videoTrack = _localRenderer.srcObject?.getVideoTracks().first;
    if (videoTrack != null) {
      await Helper.switchCamera(videoTrack);
      setState(() {
        _isCameraSwitched = !_isCameraSwitched;
      });
    }
  }
}
