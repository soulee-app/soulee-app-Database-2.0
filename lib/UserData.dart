class UserData {
  // Basic user details
  String? _uid;
  String? _name;
  DateTime? _dob;
  int? _age;
  String? _gender;
  String? _bloodGroup;
  String? _email;
  String? _phone;
  String? _profileImageUrl;
  String? _coverImageUrl;
  String? _avatarUrl;
  String? _fmcToken;

  // Tags from quizzes
  String? _mainTag;
  String? _secondaryTag;

  // Profile-specific details
  String? _coverImage;
  String? _bio;
  bool? _publicProfile;
  String? _nickname;
  String? _currentLocation;
  String? _hometown;
  String? _institute;
  String? _department;
  String? _occupation;

  // Affiliations
  String? _zodiacSign;
  String? _spiritAnimal;
  String? _element;

  // Love Language
  String? _hobby;
  String? _interest;
  String? _datePreference;

  // Life Mirror
  String? _music;
  String? _musicImageUrl;
  String? _musicArtist;

  String? _movie;
  String? _movieImageUrl;

  String? _book;
  String? _bookImageUrl;
  String? _bookAuthor;

  String? _nmovieThought;

  // Account details
  DateTime? _accountCreated;

  // Constructor with parameters
  UserData({
    String? uid,
    String? name,
    DateTime? dob,
    String? gender,
    String? bloodGroup,
    String? email,
    String? phone,
    String? profileImageUrl,
    String? coverImageUrl,
    String? avatarUrl,
    String? fmcToken,
    String? mainTag,
    String? secondaryTag,
    String? coverImage,
    String? bio,
    bool? publicProfile,
    String? nickname,
    String? currentLocation,
    String? hometown,
    String? institute,
    String? department,
    String? occupation,
    String? spiritAnimal,
    String? element,
    String? hobby,
    String? interest,
    String? datePreference,
    String? music,
    String? musicImageUrl,
    String? musicArtist,
    String? movie,
    String? movieImageUrl,
    String? book,
    String? bookImageUrl,
    String? bookAuthor,
    String? nmovieThought,
    DateTime? accountCreated,
  }) {
    _uid = uid;
    _name = name;
    _dob = dob;
    _age = dob != null ? _calculateAge(dob) : null;
    _zodiacSign = zodiacSign;
    _gender = gender;
    _bloodGroup = bloodGroup;
    _email = email;
    _phone = phone;
    _profileImageUrl = profileImageUrl;
    _coverImageUrl = coverImageUrl;
    _avatarUrl = avatarUrl;
    _fmcToken = fmcToken;
    _mainTag = mainTag;
    _secondaryTag = secondaryTag;
    _coverImage = coverImage;
    _bio = bio;
    _publicProfile = publicProfile;
    _nickname = nickname;
    _currentLocation = currentLocation;
    _hometown = hometown;
    _institute = institute;
    _department = department;
    _occupation = occupation;
    _spiritAnimal = spiritAnimal;
    _element = element;
    _hobby = hobby;
    _interest = interest;
    _datePreference = datePreference;
    _music = music;
    _musicImageUrl = musicImageUrl;
    _musicArtist = musicArtist;
    _movie = movie;
    _movieImageUrl = movieImageUrl;
    _book = book;
    _bookImageUrl = bookImageUrl;
    _bookAuthor = bookAuthor;
    _nmovieThought = nmovieThought;
    _accountCreated = accountCreated ?? DateTime.now();
  }

  // Getters
  String? get uid => _uid;
  String? get name => _name;
  DateTime? get dob => _dob;
  int? get age => _age;
  String? get zodiacSign => _zodiacSign;
  String? get gender => _gender;
  String? get bloodGroup => _bloodGroup;
  String? get email => _email;
  String? get phone => _phone;
  String? get profileImageUrl => _profileImageUrl;
  String? get coverImageUrl => _coverImageUrl;
  String? get avatarUrl => _avatarUrl;
  String? get fmcToken => _fmcToken;
  String? get mainTag => _mainTag;
  String? get secondaryTag => _secondaryTag;
  String? get coverImage => _coverImage;
  String? get bio => _bio;
  bool? get publicProfile => _publicProfile;
  String? get nickname => _nickname;
  String? get currentLocation => _currentLocation;
  String? get hometown => _hometown;
  String? get institute => _institute;
  String? get department => _department;
  String? get occupation => _occupation;
  String? get spiritAnimal => _spiritAnimal;
  String? get element => _element;
  String? get hobby => _hobby;
  String? get interest => _interest;
  String? get datePreference => _datePreference;
  String? get music => _music;
  String? get musicImageUrl => _musicImageUrl;
  String? get musicArtist => _musicArtist;
  String? get movie => _movie;
  String? get movieImageUrl => _movieImageUrl;
  String? get book => _book;
  String? get bookImageUrl => _bookImageUrl;
  String? get bookAuthor => _bookAuthor;
  String? get nmovieThought => _nmovieThought;
  DateTime? get accountCreated => _accountCreated;

  // Helper function to calculate age
  int _calculateAge(DateTime dob) {
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.isBefore(DateTime(now.year, dob.month, dob.day))) {
      age--;
    }
    return age;
  }

  // Factory constructor to create UserData from Firestore document
  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      uid: map['uid'],
      name: map['name'],
      dob: map['dob'] != null ? DateTime.parse(map['dob']) : null,
      gender: map['gender'],
      bloodGroup: map['blood_group'],
      email: map['email'],
      phone: map['phone'],
      profileImageUrl: map['profile_image'],
      coverImageUrl: map['cover_image_url'],
      avatarUrl: map['avatar_url'],
      fmcToken: map['fmcToken'],
      mainTag: map['main_tag'],
      secondaryTag: map['secondary_tag'],
      coverImage: map['cover_image'],
      bio: map['bio'],
      publicProfile: map['public_profile'],
      nickname: map['nickname'],
      currentLocation: map['current_loc'],
      hometown: map['hometown'],
      institute: map['institute'],
      department: map['department'],
      occupation: map['occupation'],
      spiritAnimal: map['spirit_animal'],
      element: map['element'],
      hobby: map['hobby'],
      interest: map['interest'],
      datePreference: map['date_preference'],
      music: map['music'],
      musicImageUrl: map['music_image_url'],
      musicArtist: map['music_artist'],
      movie: map['movie'],
      movieImageUrl: map['movie_image_url'],
      book: map['book'],
      bookImageUrl: map['book_image_url'],
      bookAuthor: map['book_author'],
      nmovieThought: map['nmovie_thought'],
      accountCreated: map['account_created'] != null
          ? DateTime.parse(map['account_created'])
          : null,
    );
  }

  // Convert UserData to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'uid': _uid,
      'name': _name,
      'dob': _dob?.toIso8601String(),
      'age': _age,
      'gender': _gender,
      'blood_group': _bloodGroup,
      'email': _email,
      'phone': _phone,
      'profile_image': _profileImageUrl,
      'cover_image_url': _coverImageUrl,
      'avatar_url': _avatarUrl,
      'fmcToken': _fmcToken,
      'main_tag': _mainTag,
      'secondary_tag': _secondaryTag,
      'cover_image': _coverImage,
      'bio': _bio,
      'public_profile': _publicProfile,
      'nickname': _nickname,
      'current_loc': _currentLocation,
      'hometown': _hometown,
      'institute': _institute,
      'department': _department,
      'occupation': _occupation,
      'spirit_animal': _spiritAnimal,
      'element': _element,
      'hobby': _hobby,
      'interest': _interest,
      'date_preference': _datePreference,
      'music': _music,
      'music_image_url': _musicImageUrl,
      'music_artist': _musicArtist,
      'movie': _movie,
      'movie_image_url': _movieImageUrl,
      'book': _book,
      'book_image_url': _bookImageUrl,
      'book_author': _bookAuthor,
      'nmovie_thought': _nmovieThought,
      'account_created': _accountCreated?.toIso8601String(),
    };
  }
}
