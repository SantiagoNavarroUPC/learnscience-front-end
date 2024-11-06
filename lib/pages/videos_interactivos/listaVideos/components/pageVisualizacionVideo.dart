import 'package:flutter/material.dart';
import 'package:flutter_application/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InteractiveVideoPage extends StatefulWidget {
  final String videoUrl;

  InteractiveVideoPage({required this.videoUrl});

  @override
  _InteractiveVideoPageState createState() => _InteractiveVideoPageState();
}

class _InteractiveVideoPageState extends State<InteractiveVideoPage> {
  late YoutubePlayerController _youtubePlayerController;
  final TextEditingController _videoThoughtController = TextEditingController();
  final TextEditingController _videoDislikeController = TextEditingController();
  final TextEditingController _videoLifeApplicationController = TextEditingController();
  bool _isMuted = false;

  @override
  void initState() {
    super.initState();
    final String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _youtubePlayerController.dispose();
    _videoThoughtController.dispose();
    _videoDislikeController.dispose();
    _videoLifeApplicationController.dispose();
    super.dispose();
  }

  void _saveResponses() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Respuestas Guardadas'),
        content: Text('Tus respuestas han sido guardadas.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Visualización de videos',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: YoutubePlayer(
              controller: _youtubePlayerController,
              showVideoProgressIndicator: true,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              children: [
                _buildControlButtons(),
                _buildQuestionSection('¿De qué trata el video?', _videoThoughtController),
                _buildQuestionSection('¿Qué te gustó del video?', _videoDislikeController),
                _buildQuestionSection('¿Cómo lo llevarías a la vida cotidiana?', _videoLifeApplicationController),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ElevatedButton(
                    onPressed: _saveResponses,
                    child: Text('Guardar Respuestas'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: gColorTheme1_600,
                      foregroundColor: gColorTheme1_1,
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionSection(String question, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 2,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Escribe tu respuesta aquí...',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.pause, size: 40, color: gColorTheme1_900),
            onPressed: () => _youtubePlayerController.pause(),
          ),
          IconButton(
            icon: Icon(Icons.play_arrow, size: 40, color: gColorTheme1_900),
            onPressed: () => _youtubePlayerController.play(),
          ),
          IconButton(
            icon: Icon(Icons.replay_10, size: 40, color: gColorTheme1_900),
            onPressed: () {
              _youtubePlayerController.seekTo(
                Duration(seconds: _youtubePlayerController.value.position.inSeconds - 10),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.forward_10, size: 40, color: gColorTheme1_900),
            onPressed: () {
              _youtubePlayerController.seekTo(
                Duration(seconds: _youtubePlayerController.value.position.inSeconds + 10),
              );
            },
          ),
          IconButton(
            icon: Icon(_isMuted ? Icons.volume_off : Icons.volume_up, size: 40, color: gColorTheme1_900),
            onPressed: () {
              setState(() {
                _isMuted ? _youtubePlayerController.unMute() : _youtubePlayerController.mute();
                _isMuted = !_isMuted;
              });
            },
          ),
        ],
      ),
    );
  }
}
