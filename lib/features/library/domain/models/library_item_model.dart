class LibraryItemModel {
  final String id;
  final String title;
  final String description;
  final String author;
  final String topCategory;
  final String middleCategory;
  final String subCategory;
  final String topCategoryIcon;
  final String middleCategoryIcon;
  final String subCategoryIcon;
  final String coverImage;
  final String contentFile;
  final String? externalLink;
  final String ageRestriction;
  final int viewCount;
  final int downloadCount;
  final int shareCount;
  final bool isFavorite;

  LibraryItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.topCategory,
    required this.middleCategory,
    required this.subCategory,
    required this.topCategoryIcon,
    required this.middleCategoryIcon,
    required this.subCategoryIcon,
    required this.coverImage,
    required this.contentFile,
    this.externalLink,
    required this.ageRestriction,
    required this.viewCount,
    required this.downloadCount,
    required this.shareCount,
    required this.isFavorite,
  });

  factory LibraryItemModel.fromJson(Map<String, dynamic> json) {
    return LibraryItemModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      author: json['author'] ?? '',
      topCategory: json['top_category'] ?? '',
      middleCategory: json['middle_category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      topCategoryIcon: json['top_category_icon'] ?? '',
      middleCategoryIcon: json['middle_category_icon'] ?? '',
      subCategoryIcon: json['sub_category_icon'] ?? '',
      coverImage: json['cover_image'] ?? '',
      contentFile: json['content_file'] ?? '',
      externalLink: json['external_link'],
      ageRestriction: json['age_restriction'] ?? 'ALL',
      viewCount: json['view_count'] ?? 0,
      downloadCount: json['download_count'] ?? 0,
      shareCount: json['share_count'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'author': author,
      'top_category': topCategory,
      'middle_category': middleCategory,
      'sub_category': subCategory,
      'top_category_icon': topCategoryIcon,
      'middle_category_icon': middleCategoryIcon,
      'sub_category_icon': subCategoryIcon,
      'cover_image': coverImage,
      'content_file': contentFile,
      'external_link': externalLink,
      'age_restriction': ageRestriction,
      'view_count': viewCount,
      'download_count': downloadCount,
      'share_count': shareCount,
      'is_favorite': isFavorite,
    };
  }

  // Helper method to get the appropriate image for display
  String get displayImage {
    return coverImage.isNotEmpty ? coverImage : topCategoryIcon;
  }

  // Helper method to check if content is audio
  bool get isAudio {
    return contentFile.toLowerCase().endsWith('.mp3') ||
        contentFile.toLowerCase().endsWith('.wav') ||
        contentFile.toLowerCase().endsWith('.m4a') ||
        topCategory.toLowerCase().contains('audio');
  }

  // Helper method to check if content is PDF/document
  bool get isDocument {
    return contentFile.toLowerCase().endsWith('.pdf') ||
        contentFile.toLowerCase().endsWith('.doc') ||
        contentFile.toLowerCase().endsWith('.docx');
  }

  // Helper method to check if content is video
  bool get isVideo {
    return contentFile.toLowerCase().endsWith('.mp4') ||
        contentFile.toLowerCase().endsWith('.avi') ||
        contentFile.toLowerCase().endsWith('.mov');
  }

  // Helper method to get content type
  String get contentType {
    if (isAudio) return 'Audio';
    if (isVideo) return 'Video';
    if (isDocument) return 'Document';
    return 'Unknown';
  }
}
