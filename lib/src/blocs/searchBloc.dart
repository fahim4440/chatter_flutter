import 'package:Chatter/src/providers/repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/userModel.dart';
import '../providers/repository.dart';

class SearchBloc {
  final _repository = Repository();
  final _searchInputController = PublishSubject<String>();
  final _searchOutputController = PublishSubject<Map<int, Future<Map<int, UserModel>>>>();

  //streams
  Stream<Map<int, Future<Map<int, UserModel>>>> get searchResult => _searchOutputController.stream;

  SearchBloc() {
    _searchInputController.stream.transform(_userFetchTransformer()).pipe(_searchOutputController);
  }

  _userFetchTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<Map<int, UserModel>>> cache, String username, index) {
        cache[0] = _repository.fetchUserSearchData(username);
        return cache;
      },
      <int, Future<Map<int, UserModel>>> {}
    );
  }

  //sinks
  Function(String) get fetchSearch => _searchInputController.sink.add;

}