import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/screens/category/bloc/music_categories_bloc.dart';
import 'package:innershakti_assignment/screens/category/bloc/music_categories_state.dart';
import 'package:innershakti_assignment/screens/category_details/model/category_details.dart';
import 'package:innershakti_assignment/screens/category_details/screen/category_details_screen.dart';

class MusicCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0x27, 0x2D, 0x32),
      appBar: AppBar(
        title: Text('InnerBhakti', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ), // First action button (e.g., search)
            onPressed: () {
              print('Search button pressed');
            },
          ),
          IconButton(
            icon: Icon(Icons.add,
                color: Colors.white), // Second action button (e.g., settings)
            onPressed: () {
              print('Add button pressed');
            },
          ),
        ],
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: BlocBuilder<MusicCategoriesBloc, MusicCategoriesState>(
        builder: (context, state) {
          if (state is MusicCategoriesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is MusicCategoriesLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Explore AudioBooks",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        var category = state.categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                12), // Card's corner radius
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CategoryDetailsScreen(
                                              bannerUrl: "${category.imageUrl}",id: category.id,description: category.description,title: category.name,)),
                                );
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage("${category
                                          .imageUrl}"), // Replace with your image URL field
                                      fit: BoxFit
                                          .cover, // Makes the image fill the card
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.35),),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(category.name,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 19)),
                                          Text(
                                              "${category.duration} Days Plan",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  )),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else if (state is MusicCategoriesError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('Welcome'));
        },
      ),
    );
  }
}
