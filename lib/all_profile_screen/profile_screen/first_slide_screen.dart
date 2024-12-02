import 'package:flutter/material.dart';
import 'package:navbar/DatabaseManager.dart';
import 'package:navbar/all_profile_screen/profile_screen/BooksApi/booksHome.dart';
import 'package:navbar/all_profile_screen/profile_screen/movieApi/movieHome.dart';
import 'package:navbar/all_profile_screen/profile_screen/slider_animation/ImageSlider_date.dart';
import 'package:navbar/all_profile_screen/profile_screen/slider_animation/ImageSlider_hobby.dart';
import 'package:navbar/all_profile_screen/profile_screen/slider_animation/ImageSlider_splace.dart';
import 'package:navbar/all_profile_screen/profile_screen/slider_animation/imageSlider_soulcall.dart';
import 'package:navbar/all_profile_screen/profile_screen/spirite_animal/animal_selection.dart';
import 'package:navbar/all_profile_screen/profile_screen/spotify_Api/muisic_home.dart';
import 'package:navbar/all_profile_screen/profile_screen/spotify_Api/spotify_api.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/Text_with_icon.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/affliation_widget.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custom_switch_button.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/custome_text_list.dart';
import 'package:navbar/all_profile_screen/profile_screen/widgets/life_mirror_widget.dart';
import '../../widgest/heading_text.dart';
import 'BooksApi/google_books_api.dart';
import 'model/affliations.dart';
import 'movieApi/tmdb_api.dart';

class FirstSlideScreen extends StatefulWidget {
  final DatabaseManager databaseManager;

  const FirstSlideScreen({super.key, required this.databaseManager});

  @override
  State<FirstSlideScreen> createState() => _FirstSlideScreenState();
}

class _FirstSlideScreenState extends State<FirstSlideScreen> {
  final SpotifyApi spotifyApi = SpotifyApi();
  final TMDBApi tmdbApi = TMDBApi();
  final GoogleBooksApi googleBooksApi = GoogleBooksApi();

  // Variables for user data
  String? selectedAlbumImageUrl;
  String? selectedMovieImageUrl;
  String? selectedBookImageUrl;
  String? selectedAlbumName;
  String? selectedMovieName;
  String? selectedBookName;
  String? selectedAlbumArtist;
  String? selectedBookAuthor;

  String _bio = "Add bio";
  String _zodiacSign = "Zodiac";
  String _zodiacImagePath = 'assets/zodiac/Zodiac.jpg';
  List<String> sampleTexts = [];

  List<AffiliationData> affiliations = [];
  List<AffiliationData> loveLanguage = [];

  // Music-related variables
  String _music = "Unknown Song";
  String _musicArtist = "Unknown Artist";
  String _musicImageUrl = 'assets/default_music_image.jpg';

// Movie-related variables
  String _movie = "Unknown Movie";
  String _movieImageUrl = 'assets/default_movie_image.jpg';

// Book-related variables
  String _book = "Unknown Book";
  String _bookAuthor = "Unknown Author";
  String _bookImageUrl = 'assets/default_book_image.jpg';


  final TextEditingController _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Fetch the latest user data from the database
      final userId = widget.databaseManager.auth.currentUser?.uid;
      if (userId == null) throw Exception('User is not authenticated.');

      final userDoc = await widget.databaseManager.firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('User document does not exist.');
      }

      final userData = userDoc.data();

      setState(() {
        _bio = userData?['bio'] ?? "Add bio";
        _zodiacSign = userData?['zodiac_sign'] ?? "Zodiac";
        _zodiacImagePath = _getZodiacImagePath(_zodiacSign);

        // Update affiliations
        affiliations = [
          AffiliationData(
            text1: _zodiacSign,
            text2: 'Zodiac Sign',
            image: _zodiacImagePath,
          ),
          AffiliationData(
            text1: userData?['spiritAnimal'] ?? 'Spirit Animal',
            text2: 'Spirit Animal',
            image: 'assets/Profile/Spirit Animal.png',
          ),
          AffiliationData(
            text1: userData?['element'] ?? 'Element',
            text2: 'Element',
            image: 'assets/Profile/Element.png',
          ),
        ];

        // Update love languages
        loveLanguage = [
          AffiliationData(
            text1: userData?['hobby'] ?? 'Hobby',
            text2: 'Hobby',
            image: 'assets/Profile/Hobby.png',
          ),
          AffiliationData(
            text1: userData?['interest'] ?? 'Call of the Soul',
            text2: 'Call Of Soul',
            image: 'assets/Profile/Call Soul.png',
          ),
          AffiliationData(
            text1: userData?['datePreference'] ?? 'Preferences',
            text2: 'Preference',
            image: 'assets/Profile/Preferences.png',
          ),
        ];

        // Fetch and update music, movie, and book data
        _music = userData?['music'] ?? 'Unknown Song';
        _musicArtist = userData?['musicArtist'] ?? 'Unknown Artist';
        _musicImageUrl = userData?['musicImageUrl'] ?? 'assets/default_music_image.jpg';

        _movie = userData?['movie'] ?? 'Unknown Movie';
        _movieImageUrl = userData?['movieImageUrl'] ?? 'assets/default_movie_image.jpg';

        _book = userData?['book'] ?? 'Unknown Book';
        _bookAuthor = userData?['bookAuthor'] ?? 'Unknown Author';
        _bookImageUrl = userData?['bookImageUrl'] ?? 'assets/default_book_image.jpg';
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }




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

        // Update user data in the database
        widget.databaseManager.updateUserProfileMusic(
          albumName: selectedAlbumName,
          artistName: selectedAlbumArtist,
          albumImageUrl: selectedAlbumImageUrl,
        );
      });
    }
  }

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

        // Update user data in the database
        widget.databaseManager.updateUserProfileMovie(
          movieName: selectedMovieName,
          movieImageUrl: selectedMovieImageUrl,
        );
      });
    }
  }

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

        // Update user data in the database
        widget.databaseManager.updateUserProfileBook(
          bookName: selectedBookName,
          bookAuthor: selectedBookAuthor,
          bookImageUrl: selectedBookImageUrl,
        );
      });
    }
  }

  Future<void> _saveBio(String bio) async {
    try {
      await widget.databaseManager.updateUserProfileBio(bio);
      setState(() {
        _bio = bio;
      });
    } catch (e) {
      print("Error saving bio: $e");
    }
  }

  void _editBio() {
    _bioController.text = _bio;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Bio'),
          content: TextField(
            controller: _bioController,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter your bio',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _saveBio(_bioController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  String _getZodiacImagePath(String zodiacSign) {
    final zodiacImages = {
      "Aries": 'assets/zodiac/Aries.jpg',
      "Taurus": 'assets/zodiac/Taurus.jpg',
      "Gemini": 'assets/zodiac/Gemini.jpg',
      "Cancer": 'assets/zodiac/Cancer.jpg',
      "Leo": 'assets/zodiac/Leo.jpg',
      "Virgo": 'assets/zodiac/Virgo.jpg',
      "Libra": 'assets/zodiac/Libra.jpg',
      "Scorpio": 'assets/zodiac/Scorpio.jpg',
      "Sagittarius": 'assets/zodiac/Sagittarius.jpg',
      "Capricorn": 'assets/zodiac/Capricorn.jpg',
      "Aquarius": 'assets/zodiac/Aquarius.jpg',
      "Pisces": 'assets/zodiac/Pisces.jpg',
    };

    return zodiacImages[zodiacSign] ?? 'assets/zodiac/Zodiac.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {'text': 'RAAT', 'icon': Icons.home},
      {'text': 'KIND', 'icon': Icons.favorite},
      {'text': 'DHAKA', 'icon': Icons.location_city},
      {'text': 'JAGA', 'icon': Icons.place},
      {'text': 'BRAC UNIVERSITY', 'icon': Icons.school},
      {'text': 'CSE', 'icon': Icons.computer},
      {'text': 'BRAC', 'icon': Icons.business},
    ];

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _editBio,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '❝ $_bio ❞',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              alignment: WrapAlignment.center,
              children: items.map((item) {
                return TextWithIcon(text: item['text'], icon: item['icon']);
              }).toList(),
            ),
            const CustomSwitchButton(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeadingText(text: 'AFFILIATIONS'),
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
                    return GestureDetector(
                      onTap: () {
                        if (data.text1 == "Element") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImagesliderSplace(),
                            ),
                          );
                        } else if (data.text1 == "Spirit Animal") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AnimalSelectionApp(),
                            ),
                          );
                        }
                      },
                      child: AffliationWidget(
                        text1: index == 0 ? _zodiacSign : data.text1,
                        text2: data.text2,
                        image: index == 0 ? _zodiacImagePath : data.image,
                      ),
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
                const HeadingText(text: 'LOVE LANGUAGE'),
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
                    return GestureDetector(
                      onTap: () {
                        if (data.text1 == "Hobby") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImagesliderHobby(),
                            ),
                          );
                        } else if (data.text1 == "Call of the soul") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImagesliderSoulcall(),
                            ),
                          );
                        } else if (data.text1 == "Preferences") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ImagesliderDate(),
                            ),
                          );
                        }
                      },
                      child: AffliationWidget(
                        text1: data.text1,
                        text2: data.text2,
                        image: data.image,
                      ),
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ),
              ],
            ),
            const HeadingText(text: 'LIFE MEMORIES'),
            _buildLifeMemoriesSection(),
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

  Widget _buildAffiliationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeadingText(
          text: 'AFFILIATIONS',
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
              text1: index == 0 ? _zodiacSign : data.text1,
              text2: data.text2,
              image: index == 0 ? _zodiacImagePath : data.image,
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }

  Widget _buildLoveLanguageSection() {
    return Column(
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
    );
  }

  Widget _buildLifeMemoriesSection() {
    return Padding(
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
