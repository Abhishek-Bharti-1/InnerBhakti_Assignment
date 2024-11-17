
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:innershakti_assignment/repository/music_repository.dart';
import 'music_categories_event.dart';
import 'music_categories_state.dart';


class MusicCategoriesBloc extends Bloc<MusicCategoriesEvent, MusicCategoriesState> {
  final MusicRepository musicRepository;

  MusicCategoriesBloc(this.musicRepository) : super(MusicCategoriesInitial()) {
    on<FetchMusicCategories>((event, emit) async {
      emit(MusicCategoriesLoading());
      try {
        final categories = await musicRepository.fetchMusicCategories();
        emit(MusicCategoriesLoaded(categories));
      } catch (e) {
        emit(MusicCategoriesError(e.toString()));
      }
    });
  }
}
