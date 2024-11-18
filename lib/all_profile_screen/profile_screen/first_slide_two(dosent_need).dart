import 'package:flutter/material.dart';
import 'package:navbar/all_profile_screen/profile_screen/spotify_Api/muisic_home.dart';
import 'package:navbar/all_profile_screen/profile_screen/spotify_Api/spotify_api.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/Text_with_icon.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/affliation_widget.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custome_text_list.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/life_mirror_widget.dart';

import '../../widgest/heading_text.dart';
import 'BooksApi/booksHome.dart';
import 'BooksApi/google_books_api.dart';
import 'model/affliations.dart';
import 'movieApi/movieHome.dart';
import 'movieApi/tmdb_api.dart';

class FirstSlideTwo extends StatefulWidget {
  const FirstSlideTwo({super.key});

  @override
  State<FirstSlideTwo> createState() => _FirstSlideTwoState();
}

class _FirstSlideTwoState extends State<FirstSlideTwo> {
  final SpotifyApi spotifyApi = SpotifyApi();
  final TMDBApi tmdbApi = TMDBApi();
  final GoogleBooksApi googleBooksApi = GoogleBooksApi();

  String? selectedAlbumImageUrl;
  String? selectedMovieImageUrl;
  String? selectedBookImageUrl;

  String? selectedAlbumName;
  String? selectedMovieName;
  String? selectedBookName;

  String? selectedAlbumArtist;
  String? selectedBookAuthor;

  // Open MusicHome and select a song
  void _openMusicHome() async {
    final selectedSong = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MusicHome(spotifyApi: spotifyApi),
      ),
    );
    if (selectedSong != null) {
      setState(() {
        selectedAlbumImageUrl = selectedSong['album']['images'][0]['url'];
        selectedAlbumName = selectedSong['name'];
        selectedAlbumArtist = selectedSong['artists'][0]['name'];
      });
    }
  }

  // Open MovieHome and select a movie
  void _openMovieHome() async {
    final selectedMovie = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieHome(tmdbApi: tmdbApi),
      ),
    );
    if (selectedMovie != null) {
      setState(() {
        selectedMovieImageUrl = selectedMovie['poster_path'];
        selectedMovieName = selectedMovie['title'];
      });
    }
  }

  // Open BookHome and select a book
  void _openBookHome() async {
    final selectedBook = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookHome(googleBooksApi: googleBooksApi),
      ),
    );
    if (selectedBook != null) {
      setState(() {
        selectedBookImageUrl = selectedBook['imageLinks']?['thumbnail'];
        selectedBookName = selectedBook['title'];
        selectedBookAuthor = selectedBook['authors'] != null
            ? selectedBook['authors'][0]
            : 'Unknown Author';
      });
    }
  }

  List<AffiliationData> affiliations = [
    AffiliationData(
      text1: 'Zodiac',
      text2: 'Description',
      image: 'assets/Cancer.png',
    ),
    AffiliationData(
      text1: 'Sprite Animal',
      text2: 'Description',
      image: 'assets/1.jpeg',
    ),
    AffiliationData(
      text1: 'Element',
      text2: 'Description',
      image:
          'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg',
    ),
  ];

  List<AffiliationData> loveLanguage = [
    AffiliationData(
      text1: 'Hobby',
      text2: 'Description',
      image: 'assets/Cancer.png',
    ),
    AffiliationData(
      text1: 'Call of the soul',
      text2: 'Description',
      image: 'assets/1.jpeg',
    ),
    AffiliationData(
      text1: 'Preferences',
      text2: 'Description',
      image:
          'https://gratisography.com/wp-content/uploads/2024/01/gratisography-cyber-kitty-800x525.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> sampleTexts = [];

    final List<Map<String, dynamic>> items = [
      {
        'text': 'RAAT',
        'icon': const IconData(0xe559, fontFamily: 'MaterialIcons')
      },
      {'text': 'KIND', 'icon': Icons.favorite_outlined},
      {'text': 'DHAKA', 'icon': Icons.location_city_rounded},
      {'text': 'JAGA', 'icon': Icons.location_on},
      {'text': 'BRAC UNIVERSITY', 'icon': Icons.cast_for_education},
      {'text': 'CSE', 'icon': Icons.computer},
      {
        'text': 'BRAC',
        'icon': const IconData(0xe089, fontFamily: 'MaterialIcons')
      },
    ];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '❝Add bio + ❞',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: items.map((item) {
                return TextWithIcon(
                  text: item['text'],
                  icon: item['icon'],
                );
              }).toList(),
            ),
            //const CustomSwitchButton(),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const HeadingText(
                    text: 'COMPATIBILITY',
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Row(
                    children: List.generate(
                      4,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2.0),
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const HeadingText(
                    text: '85%',
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadingText(
                  text: 'AFFILATIONS',
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: affiliations.length,
                  itemBuilder: (context, index) {
                    final data = affiliations[index];
                    return AffliationWidget(
                      text1: data.text1,
                      text2: data.text2,
                      image: data.image,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadingText(
                  text: 'LOVE LANGUAGE',
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: loveLanguage.length,
                  itemBuilder: (context, index) {
                    final data = loveLanguage[index];
                    return AffliationWidget(
                      text1: data.text1,
                      text2: data.text2,
                      image: data.image,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
            const SizedBox(height: 15),
            const HeadingText(text: 'LIFE MEMORIES'),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildMemoryBox(
                    label: selectedAlbumName ?? 'Music',
                    subLabel: selectedAlbumArtist,
                    imageUrl: selectedAlbumImageUrl,
                    icon: Icons.music_note,
                    onTap: _openMusicHome,
                  ),
                  _buildMemoryBox(
                    label: selectedMovieName ?? 'Movie',
                    imageUrl: selectedMovieImageUrl != null
                        ? 'https://image.tmdb.org/t/p/w500$selectedMovieImageUrl'
                        : null,
                    icon: Icons.movie,
                    onTap: _openMovieHome,
                  ),
                  _buildMemoryBox(
                    label: selectedBookName ?? 'Book',
                    subLabel: selectedBookAuthor,
                    imageUrl: selectedBookImageUrl,
                    icon: Icons.book,
                    onTap: _openBookHome,
                  ),
                ],
              ),
            ),
            CustomTextList(texts: sampleTexts),
            const SizedBox(height: 20),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HeadingText(text: 'THOUGHTS'),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: SizedBox(
                    height: 135,
                    width: 110,
                    child: LifeMirrorWidget(
                      image:
                          'https://images.rawpixel.com/image_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIzLTA5L3Jhd3BpeGVsX29mZmljZV8zM193YWxscGFwZXJfcGF0dGVybl9vZl9wYXN0ZWxfY29sb3JlZF9wZW5jaWxfdF9kNzIzNTM5YS1iMDJiLTQ0ZmItYjA5Zi1mNzQwNjMxYjM1NTNfMS5qcGc.jpg',
                      isNetworkImage: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemoryBox({
    required String label,
    String? subLabel,
    String? imageUrl,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(255, 220, 63, 63)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: imageUrl != null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : Icon(icon,
                      size: 40, color: const Color.fromARGB(255, 221, 67, 67)),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            if (subLabel != null)
              Text(
                subLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12, color: Color.fromARGB(255, 91, 79, 79)),
              ),
          ],
        ),
      ),
    );
  }
}
