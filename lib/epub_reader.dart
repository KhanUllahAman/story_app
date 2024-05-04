import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:aligned_dialog/aligned_dialog.dart';
import 'package:epub_reader/custom_menu.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:path_provider/path_provider.dart';

class EpubReaderScreen extends StatefulWidget {
  final String link;

  const EpubReaderScreen({super.key, required this.link});

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  EpubBook? epubBook;
  List<String>? pages = [];
  int currentPageIndex = 0;
  List<List<String>>? chapterPages = [];



  @override
  void initState() {
    super.initState();
    loadEpubBook();
  }

  Future<Uint8List> loadEpubFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/book.epub');
    file.writeAsBytesSync(response.bodyBytes);
    epubBook = await EpubReader.readBook(file.readAsBytesSync());
    return file.readAsBytesSync();
  }

  Future<void> loadEpubBook() async {
    final bookBytes = await loadEpubFromNetwork(widget.link);
    epubBook = await EpubReader.readBook(bookBytes);
    // You can load the first chapter initially
    loadChapterContent(1);
  }



  Future<void> loadChapterContent(int chapterIndex) async {
    // Load the content of the specified chapter
    final EpubChapter chapter = epubBook!.Chapters![chapterIndex];
    final List<String> chapterContent = chapter.HtmlContent!.split('\n');

    // Divide chapter content into pages based on screen height
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<String> chapterPages = [];
    List<String> currentPage = [];
    double currentPageHeight = 0;

    for (final line in chapterContent) {
      final double lineHeight = _calculateLineHeight(line);
      if (currentPageHeight + lineHeight <= screenHeight) {
        currentPage.add(line);
        currentPageHeight += lineHeight;
      } else {
        chapterPages.add(currentPage.join('\n'));
        currentPage = [line]; // Start new page with this line
        currentPageHeight = lineHeight;
      }
    }
    if (currentPage.isNotEmpty) {
      chapterPages.add(currentPage.join('\n')); // Add last page
    }

    setState(() {
      this.chapterPages = [chapterPages]; // Store chapter pages
      currentPageIndex = 0; // Reset current page index
    });
  }
  // Future<void> loadEpubBook() async {
  //   final bookBytes = await loadEpubFromNetwork(widget.link);
  //   epubBook = await EpubReader.readBook(bookBytes);
  //
  //   print(epubBook!.Content.toString());
  //   // Divide chapters into pages
  //   setState(() {
  //
  //     pages = _divideIntoPages(epubBook!.Chapters!);
  //
  //
  //   });
  // }

  List<String> _divideIntoPages(List<EpubChapter> chapters) {
    final List<String> result = [];
    final double screenHeight = MediaQuery.of(context).size.height;
    for (final chapter in chapters) {
      final List<String> lines = chapter.HtmlContent!.split('\n');

      final List<String> pageLines = [];
      double currentPageHeight = 0;
      // Iterate through lines and add them to the page until reaching the page height limit
      for (final line in lines) {
        final double lineHeight = _calculateLineHeight(line);
        if (currentPageHeight + lineHeight <= screenHeight) {
          pageLines.add(line);
          currentPageHeight += lineHeight;
        } else {
          break; // Start a new page if reaching the page height limit
        }
      }
      result.add(pageLines.join('\n'));
    }

    if (kDebugMode) {

    }

    return result;
  }

  double _calculateLineHeight(String line) {
    // Logic to calculate the height of a line based on its content
    // You can use a fixed value or dynamically calculate based on font size and content
    return 24.0; // Example fixed line height
  }

  void showCommentDialog(String? selectedText) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Comments"),
          content: Text(selectedText!),
        );
      },
    );
  }

  void changeChapter(int index) {
    setState(() {
      currentPageIndex = index;
      // currentContent = epubBook!.Chapters![index].HtmlContent;
    });
  }

  // void showChaptersDialog() {
  //   showAlignedDialog(
  //       barrierColor: Colors.transparent,
  //       context: context,
  //       builder: (BuildContext context) {
  //         return SafeArea(
  //           child: Align(
  //             alignment: const AlignmentDirectional(0, -1),
  //             child: ClipRRect(
  //               borderRadius: BorderRadius.circular(18),
  //               child: BackdropFilter(
  //                 filter: ImageFilter.blur(
  //                   sigmaX: 10,
  //                   sigmaY: 20,
  //                 ),
  //                 child: Material(
  //                   type: MaterialType.transparency,
  //                   child: Container(
  //                     width: MediaQuery.of(context).size.width * 0.8,
  //                     height: MediaQuery.of(context).size.height * 0.8,
  //                     decoration: const BoxDecoration(
  //                       color: Color(0x4D0F172A),
  //                     ),
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(20),
  //                       child: Column(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           Text(
  //                             epubBook?.Title ?? 'Loading...',
  //                             style: FlutterFlowTheme.of(context)
  //                                 .titleMedium
  //                                 .override(
  //                                   fontFamily: 'Proxima Nova',
  //                                   fontSize: 23,
  //                                   letterSpacing: 0,
  //                                   useGoogleFonts: false,
  //                                 ),
  //                           ),
  //                           Expanded(
  //                             child: ListView.builder(
  //                               itemCount: epubBook?.Chapters?.length,
  //                               itemBuilder: (BuildContext context, int index) {
  //                                 return ListTile(
  //                                   title: Text(
  //                                     epubBook?.Chapters?[index].Title ??
  //                                         'Chapter $index',
  //                                     style: TextStyle(
  //                                       color: index == currentPageIndex
  //                                           ? Colors.blue
  //                                           : Colors.white,
  //                                     ),
  //                                   ),
  //                                   onTap: () {
  //                                     setState(() {
  //                                       currentPageIndex = index;
  //                                       // currentContent = epubBook!
  //                                       //     .Chapters![index].HtmlContent;
  //                                     });
  //                                     Navigator.of(context).pop();
  //                                   },
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //                         ].divide(const SizedBox(height: 10)),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }
  //
  // void showTextDialog() {
  //   showAlignedDialog(
  //     barrierColor: Colors.transparent,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Align(
  //         alignment: const AlignmentDirectional(0, 0.65),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(18),
  //           child: BackdropFilter(
  //             filter: ImageFilter.blur(
  //               sigmaX: 10,
  //               sigmaY: 20,
  //             ),
  //             child: Material(
  //               type: MaterialType.transparency,
  //               child: Container(
  //                 width: MediaQuery.of(context).size.width * 0.8,
  //                 decoration: const BoxDecoration(
  //                   color: Color(0x4D0F172A),
  //                 ),
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(20),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.stretch,
  //                     mainAxisSize: MainAxisSize.min,
  //                     children: [
  //                       const Text(
  //                         'Background',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                       const Row(),
  //                       const Text(
  //                         'Font',
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 12,
  //                         ),
  //                       ),
  //                     ].divide(const SizedBox(height: 10)),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showChaptersDialog() {
    showAlignedDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Align(
            alignment: const AlignmentDirectional(0, -1),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 20,
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: const BoxDecoration(
                      color: Color(0x4D0F172A),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            epubBook?.Title ?? 'Loading...',
                            style: TextStyle(
                              fontFamily: 'Proxima Nova',
                              fontSize: 23,
                              letterSpacing: 0,
                              // useGoogleFonts: false,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: epubBook?.Chapters?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                  title: Text(
                                    epubBook?.Chapters?[index].Title ??
                                        'Chapter $index',
                                    style: TextStyle(
                                      color: index == currentPageIndex
                                          ? Colors.blue
                                          : Colors.white,
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      currentPageIndex = index;
                                      // currentContent = epubBook!
                                      //     .Chapters![index].HtmlContent;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showTextDialog() {
    showAlignedDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: const AlignmentDirectional(0, 0.65),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 20,
              ),
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: const BoxDecoration(
                    color: Color(0x4D0F172A),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Background',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const Row(),
                        const Text(
                          'Font',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String? selectedText;
    double fontSize = 18;

    void changeFontSize(double size) {
      setState(() {
        fontSize = size;
      });
    }

    // print(pages?.length ?? 0);

    final List<List<Color>> colors = [
      [
        const Color(0xFF0F172A),
        const Color(0xFF450A0A),
      ],
      [
        const Color(0xFF000000),
        const Color(0xFF000000),
      ],
    ];

    final List<ContextMenuButtonItem> buttonItems = [
      ContextMenuButtonItem(
        type: ContextMenuButtonType.values[1],
        label: "Post",
        onPressed: () {
          showCommentDialog(selectedText);
        },
      ),
      ContextMenuButtonItem(
        type: ContextMenuButtonType.custom,
        label: "Menu",
        onPressed: () {
          showAlignedDialog(
            barrierColor: Colors.transparent,
            context: context,
            isGlobal: true,
            builder: (context) => CustomMenu(
              context,
              onMenuButtonPressed: () => showChaptersDialog(),
              onCommentButtonPressed: () => showCommentDialog(selectedText),
              onTextSizeButtonPressed: () => showTextDialog(),
              context: context,
              text: 'Menu',
            ),
          );
        },
      ),
    ];

    return SafeArea(
        child: SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: colors[0],
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                width: double.infinity,
                child: Text(
                  epubBook?.Chapters?[currentPageIndex].Title ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: GestureDetector(
                  onDoubleTap: () {
                    showAlignedDialog(
                      barrierColor: Colors.transparent,
                      context: context,
                      isGlobal: true,
                      builder: (context) => CustomMenu(
                        context,
                        onMenuButtonPressed: () => showChaptersDialog(),
                        onCommentButtonPressed: () =>
                            showCommentDialog(selectedText),
                        onTextSizeButtonPressed: () => showTextDialog(),
                        context: context,
                        text: 'Menu',
                      ),
                    );
                  },
                  child:
                  PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentPageIndex = index; // Update to new page index
                      });
                    },
                    itemCount: chapterPages!.length,
                    itemBuilder: (context, chapterIndex) {
                      final List<String> chapterContent = chapterPages![chapterIndex];
                      final String fullChapterContent = chapterContent.join('\n');
                      return SingleChildScrollView(
                        // physics: const NeverScrollableScrollPhysics(),
                        // scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectionArea(
                            contextMenuBuilder: (context, editableTextState) {
                              return AdaptiveTextSelectionToolbar.buttonItems(
                                anchors: editableTextState.contextMenuAnchors,
                                buttonItems: buttonItems,
                              );
                            },
                            onSelectionChanged: (value) {
                              selectedText = value?.plainText;
                            },
                            child: Html(
                              data: fullChapterContent,
                              style: {
                                "body": Style(
                                  color: Colors.white,
                                  fontSize: FontSize(fontSize),
                                ),
                                "h1": Style(
                                  display: Display.none,
                                ),
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),



                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
