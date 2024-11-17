import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_bloc.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_event.dart';
import 'package:innershakti_assignment/screens/category_details/bloc/category_details_state.dart';
import 'package:innershakti_assignment/screens/music_player/screen/music_player.dart';

class CategoryDetailsScreen extends StatelessWidget {
  final String bannerUrl;
  final String id;
  final String title;
  final String description;
  const CategoryDetailsScreen(
      {super.key, required this.bannerUrl, required this.id,required this.description,required this.title});

  @override
  Widget build(BuildContext context) {
    final categoryDetailsBloc = context.read<CategoryDetailsBloc>();

// Dispatch the event with the desired id
    categoryDetailsBloc.add(FetchCategoryDetails(id));

    context.read<CategoryDetailsBloc>().add(FetchCategoryDetails(id));
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 0x27, 0x2D, 0x32),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurpleAccent,
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<CategoryDetailsBloc, CategoryDetailsState>(
        builder: (context, state) {
          if (state is CategoryDetailsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryDetailsLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 200,width:MediaQuery.of(context).size.width ,child: Image.network(bannerUrl,fit: BoxFit.fitWidth,)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(description,style: TextStyle(color:Colors.white, fontSize: 16),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Explore Chapters",style: TextStyle(color:Colors.white, fontSize: 20),),
                ),
                Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.categoryDetails.length,
                    itemBuilder: (context, index) {
                      final detail = state.categoryDetails[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MusicPlayerScreen(imageUrl: bannerUrl)),
                          );
                        },
                        child: ListTile(
                          trailing: Icon(Icons.arrow_forward_sharp,color: Colors.white,),
                          title: Text(
                            detail.title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            detail.description,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.white,
                          thickness: 1,
                        ),
                      )
              ],
            );
          } else if (state is CategoryDetailsError) {
            return Center(child: Text('Error: ${state.message}',style: TextStyle(color: Colors.white)));
          }
          return Center(child: Text('Loading...'));
        },
      ),
    );
  }
}
