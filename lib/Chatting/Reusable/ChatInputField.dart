import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';
import 'package:untitled2/Maps/PickLocation.dart';
import 'package:untitled2/Utiles/Utiles.dart';

import '../ChattingScreenViewModel.dart';

class ChatInputField extends StatefulWidget {
  const ChatInputField({super.key});

  @override
  _ChatInputFieldState createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      // Hide emoji picker when TextField gets focus
      final viewModel =
          Provider.of<ChattingScreenViewModel>(context, listen: false);
      if (viewModel.isEmojiVisible()) {
        viewModel.setEmojiVisible(false);
      }
    }
  }

  void _onAttachment(AttachmentType type) {
    debugPrint(type.name);

    switch (type) {
      case AttachmentType.location:
        debugPrint("Handling location attachment");
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PickLocation()));
        break;
      case AttachmentType.document:
        debugPrint("Handling location attachment");
        pickMultipleDocuments();
        break;
      case AttachmentType.image:
        debugPrint("Handling location attachment");
        pickImages();
        break;
      case AttachmentType.video:
        debugPrint("Handling location attachment");
        pickVideos();
        break;
      default:
        debugPrint("Unsupported attachment type");
        break;
    }
  }

  // Pick Documents
  Future<void> pickMultipleDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true, // Enable multiple file picking
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt'], // Specify file types
      );

      if (result != null) {
        List<PlatformFile> files = result.files;

        // Use the picked files
        for (var file in files) {
          debugPrint(file.name); // Print file name or handle file
        }
      } else {
        // User canceled the picker
        debugPrint('Operation canceled by the user.');
      }
    } catch (e) {
      // Handle any exceptions
      debugPrint('Error picking files: $e');
    }
  }

  // pick images
  Future<void> pickImages() async {
    List<Media> listVideoPaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.image,
        showCamera: true,
        selectCount: 5,
        cropConfig: CropConfig(enableCrop: true));
    debugPrint(listVideoPaths.toString());
  }

  // pick videos
  Future<void> pickVideos() async {
    List<Media> listVideoPaths = await ImagePickers.pickerPaths(
        galleryMode: GalleryMode.video,
        showCamera: true,
        videoRecordMinSecond: 5,
        videoRecordMaxSecond: 30,
        selectCount: 5,
        cropConfig: CropConfig(enableCrop: true));
    debugPrint(listVideoPaths.toString());
  }

  void _toggleEmojiKeyboard() {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    if (!viewModel.isEmojiVisible()) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
    debugPrint("_toggleEmojiKeyboard ==> ${viewModel.isEmojiVisible()}");
    viewModel.setEmojiVisible(!viewModel.isEmojiVisible());
  }

  void _onEmojiSelected(Emoji emoji) {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: false);
    final newText = _textController.text + emoji.emoji;

    _textController.value = _textController.value.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );

    viewModel.setInputText(newText);

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel =
        Provider.of<ChattingScreenViewModel>(context, listen: true);

    return Container(
      padding: const EdgeInsets.only(top: 5, bottom: 0, right: 0, left: 0),
      color: Theme.of(context).cardColor,
      child: SafeArea(
          child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.emoji_emotions_outlined),
                onPressed: _toggleEmojiKeyboard,
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  scrollController: _scrollController,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  // Allows unlimited number of lines
                  minLines: 1,
                  onChanged: (value) => viewModel.setInputText(value),
                  decoration: InputDecoration(
                    hintText: 'Write here...',
                    fillColor: Theme.of(context).primaryColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0), // Reduced padding
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              if (!_focusNode.hasFocus || !viewModel.isEmojiVisible())
                IconButton(
                  icon: Icon(viewModel.isSendButtonVisible
                      ? Icons.send
                      : Icons.attachment),
                  onPressed: () {
                    if (viewModel.isSendButtonVisible) {
                      // Handle send
                      viewModel.sendMessage(_textController);
                    } else {
                      // Handle attachment
                      Utils.showAttachmentSheet(context, _onAttachment);
                    }
                  },
                )
            ],
          ),
          Offstage(
            offstage: !viewModel.isEmojiVisible(),
            child: SizedBox(
              height: 300, // Adjust the height as needed
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _onEmojiSelected(emoji);
                },
                config: Config(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  initCategory: Category.RECENT,
                  bgColor: Theme.of(context).cardColor,
                  indicatorColor: Colors.blue,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.blue,
                  //progressIndicatorColor: Colors.blue,
                  backspaceColor: Colors.blue,
                  skinToneDialogBgColor: Colors.white,
                  skinToneIndicatorColor: Colors.grey,
                  enableSkinTones: true,
                  //showRecentsTab: true,
                  recentsLimit: 28,
                  // noRecentsText: "No Recents",
                  // noRecentsStyle: TextStyle(fontSize: 20, color: Colors.black26),
                  tabIndicatorAnimDuration: kTabScrollDuration,
                  categoryIcons: const CategoryIcons(),
                  buttonMode: ButtonMode.MATERIAL,
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
