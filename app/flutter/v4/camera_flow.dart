import 'package:flutter/material.dart';
import 'package:skindoc/gallery_page.dart';
import 'package:skindoc/camera_page.dart';
import 'package:camera/camera.dart';
import 'storage_service.dart';


class CameraFlow extends StatefulWidget {
  // 1
  final VoidCallback shouldLogOut;

  CameraFlow({Key key, this.shouldLogOut}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CameraFlowState();
}

class _CameraFlowState extends State<CameraFlow> {

  CameraDescription _camera;
  // 2
  bool _shouldShowCamera = false;
  StorageService _storageService;

  // 3
  List<MaterialPage> get _pages {
    return [
      // Show Gallery Page
      MaterialPage(
          child: GalleryPage(
              imageUrlsController: _storageService.imageUrlsController,
              shouldLogOut: widget.shouldLogOut,
              shouldShowCamera: () => _toggleCameraOpen(true))),

      // Show Camera Page
      if (_shouldShowCamera)
        MaterialPage(
            child: CameraPage(
                camera: _camera,
                didProvideImagePath: (imagePath) {
                  this._toggleCameraOpen(false);
                  this._storageService.uploadImageAtPath(imagePath);
                }))
    ];
  }

  @override
  void initState() {
    super.initState();
    _getCamera();
    _storageService = StorageService();
    _storageService.getImages();
  }

  @override
  Widget build(BuildContext context) {
    // 4
    return Navigator(
      pages: _pages,
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  // 5
  void _toggleCameraOpen(bool isOpen) {
    setState(() {
      this._shouldShowCamera = isOpen;
    });
  }

  void _getCamera() async {
    final camerasList = await availableCameras();
    setState(() {
      final firstCamera = camerasList.first;
      this._camera = firstCamera;
    });
  }
}