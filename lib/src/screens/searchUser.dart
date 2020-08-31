import 'package:flutter/material.dart';
import '../blocs/searchBlocProvider.dart';
import '../models/userModel.dart';
import '../providers/repository.dart';
import '../widgets/circularProgressIndicator.dart';
import '../widgets/searchListTile.dart';

class SearchUser extends StatelessWidget {
  final _repository = Repository();
  @override
  Widget build(BuildContext context) {
    final bloc = SearchBlocProvider.of(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[200],
        child: Column(
          children: <Widget>[
            Container(
              height: 90.0,
              color: Colors.blueGrey,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(top: 35.0, right: 20.0, left: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Form(
                      child: TextFormField(
                        onChanged: bloc.fetchSearch,
                        style: TextStyle(
                          fontSize: 20.0
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search Nickname',
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey
                            )
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.blueGrey
                            )
                          )
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Icon(Icons.search),
                  SizedBox(width: 10.0,)
                ],
              ),
            ),
            buildSearchList(bloc),
          ],
        ),
      ),
    );
  }
  Widget buildSearchList(SearchBloc bloc) {
    return StreamBuilder(
      stream: bloc.searchResult,
      builder: (context, AsyncSnapshot<Map<int, Future<Map<int, UserModel>>>> snapshot) {
        if(!snapshot.hasData) {
          return Text('');
        }
        final future = snapshot.data[0];
        return FutureBuilder(
          future: future,
          builder: (context, AsyncSnapshot<Map<int, UserModel>> userSnapshot) {
            if (!userSnapshot.hasData) {
              return Container(
                height: 200.0,
                child: CircularProgress(),
              );
            }

            if(userSnapshot.data.length == 0) {
              return Text('Nothing found');
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: userSnapshot.data.length,
              itemBuilder: (context, int index) {
                return SearchListTile(
                  name2: userSnapshot.data[index].name,
                  email2: userSnapshot.data[index].email,
                  photoUrl2: userSnapshot.data[index].photoUrl,
                );
              },
            );
          },
        );
      },
    );
  }
}