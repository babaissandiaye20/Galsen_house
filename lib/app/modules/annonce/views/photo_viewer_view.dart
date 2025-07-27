import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/photo.dart';
import '../../../theme/app_theme.dart';

class PhotoViewerView extends StatefulWidget {
  final List<Photo> photos;
  final int initialIndex;

  const PhotoViewerView({Key? key, required this.photos, this.initialIndex = 0})
    : super(key: key);

  @override
  State<PhotoViewerView> createState() => _PhotoViewerViewState();
}

class _PhotoViewerViewState extends State<PhotoViewerView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.photos.length}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Partager la photo
              Get.snackbar('Partage', 'Partage de la photo');
            },
          ),
        ],
      ),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(widget.photos[index].url),
            initialScale: PhotoViewComputedScale.contained,
            minScale: PhotoViewComputedScale.contained * 0.8,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            heroAttributes: PhotoViewHeroAttributes(
              tag: widget.photos[index].id,
            ),
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppTheme.backgroundColor,
                child: const Center(
                  child: Icon(Icons.error, size: 50, color: AppTheme.textLight),
                ),
              );
            },
          );
        },
        itemCount: widget.photos.length,
        loadingBuilder: (context, event) {
          return Container(
            color: AppTheme.backgroundColor,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        pageController: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
