// import 'package:epubx/epubx.dart';
// import 'package:flutterflow_ui/flutterflow_ui.dart';
// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// class ChaptersWidget extends StatefulWidget {
//   const ChaptersWidget({
//     super.key,
//     required this.bookTitle,
//     required this.chapters,
//     this.onChapterSelected,
//   });
//
//   final String bookTitle;
//   final List<EpubChapter>? chapters;
//   final VoidCallback? onChapterSelected;
//
//   @override
//   State<ChaptersWidget> createState() => _ChaptersWidgetState();
// }
//
// class _ChaptersWidgetState extends State<ChaptersWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Align(
//           alignment: const AlignmentDirectional(0, -1),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(18),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(
//                 sigmaX: 10,
//                 sigmaY: 20,
//               ),
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 decoration: const BoxDecoration(
//                   color: Color(0x4D0F172A),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         widget.bookTitle,
//                         style:
//                             FlutterFlowTheme.of(context).titleMedium.override(
//                                   fontFamily: 'Proxima Nova',
//                                   fontSize: 23,
//                                   letterSpacing: 0,
//                                   useGoogleFonts: false,
//                                 ),
//                       ),
//                       Expanded(
//                         child: ListView.builder(
//                           shrinkWrap: true,
//                           // scrollDirection: Axis.vertical,
//                           itemCount: widget.chapters?.length,
//                           itemBuilder: (BuildContext context, int index) {
//                             return ListTile(
//                               title: Text(
//                                 widget.chapters?[index].Title ?? 'Loading...',
//                                 style: FlutterFlowTheme.of(context)
//                                     .titleSmall
//                                     .override(
//                                       fontFamily: 'Proxima Nova',
//                                       fontSize: 16,
//                                       letterSpacing: 0,
//                                       useGoogleFonts: false,
//                                     ),
//                               ),
//                               onTap: widget.onChapterSelected,
//                             );
//                           },
//                         ),
//                       ),
//                     ].divide(const SizedBox(height: 10)),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }


//
// import 'dart:ui';
// import 'package:flutter/material.dart';
//
// class ChaptersWidget extends StatefulWidget {
//   const ChaptersWidget({
//     Key? key,
//     required this.bookTitle,
//     required this.chapters,
//     this.onChapterSelected,
//   }) : super(key: key);
//
//   final String bookTitle;
//   final List<EpubChapter>? chapters;
//   final VoidCallback? onChapterSelected;
//
//   @override
//   State<ChaptersWidget> createState() => _ChaptersWidgetState();
// }
//
// class _ChaptersWidgetState extends State<ChaptersWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               widget.bookTitle,
//               style: TextStyle(
//                 fontFamily: 'Proxima Nova',
//                 fontSize: 23,
//                 letterSpacing: 0,
//                 // Add any other styling properties here
//               ),
//             ),
//             SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: widget.chapters?.length ?? 0,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0),
//                     child: ListTile(
//                       title: Text(
//                         widget.chapters?[index]?.title ?? 'Loading...',
//                         style: TextStyle(
//                           fontFamily: 'Proxima Nova',
//                           fontSize: 16,
//                           letterSpacing: 0,
//                           // Add any other styling properties here
//                         ),
//                       ),
//                       onTap: widget.onChapterSelected,
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class EpubChapter {
//   final String title;
//
//   EpubChapter(this.title);
// }
