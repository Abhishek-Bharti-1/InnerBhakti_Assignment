import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/repository/music_repository.dart';
import 'package:innershakti_assignment/screens/category/bloc/music_categories_bloc.dart';
import 'package:innershakti_assignment/screens/category/bloc/music_categories_event.dart';
import 'package:innershakti_assignment/screens/category/screen/music_category_screen.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_bloc.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_event.dart';
import 'package:innershakti_assignment/screens/music_player/bloc/music_bloc.dart';
import 'package:innershakti_assignment/screens/music_player/screen/music_player.dart';
import 'package:innershakti_assignment/screens/music_player/model/song.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MusicRepository musicRepository = MusicRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              MusicCategoriesBloc(musicRepository)..add(FetchMusicCategories()),
        ),
       BlocProvider(
      create: (_) => CategoryDetailsBloc(musicRepository), // Initialize without triggering the event
    ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MusicCategoriesScreen(),
      ),
    );
  }

  // return MaterialApp(
  //   title: 'Flutter Demo',
  //   debugShowCheckedModeBanner: false,
  //   theme: ThemeData(
  //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  //     useMaterial3: true,
  //   ),
  //   home: BlocProvider(
  //   create: (context) => MusicBloc(playlist: playlist),
  //   child: MusicPlayerScreen(playlist: playlist,),
  // ),
  // );
}
