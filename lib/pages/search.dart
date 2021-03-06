import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttershare/models/user.dart';
import 'package:fluttershare/pages/profile.dart';
import 'package:fluttershare/widgets/progress.dart';
import 'package:fluttershare/pages/home.dart';


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with AutomaticKeepAliveClientMixin<Search> {

TextEditingController searchController = TextEditingController();
Future<QuerySnapshot> searchResults;

submit(query)  {
Future <QuerySnapshot> user = userRef.where("username",isGreaterThanOrEqualTo: query).getDocuments();

setState(() {
  searchResults=user;
});
}
AppBar searchWidget(){
return AppBar(
  backgroundColor: Colors.white,
title:TextFormField(
  controller: searchController,
   decoration: InputDecoration(
    hintText:"Search a user",
    filled: true,
    prefixIcon: Icon(
      Icons.account_circle
    ),
    suffixIcon:IconButton(icon:Icon(Icons.clear),
    onPressed:()=>searchController.clear())
  ),
 onFieldSubmitted:submit, 
)
);
}
Container noResultWidget() {
  return Container(
    child: Center(
      child:ListView(
        shrinkWrap: true,
        children: <Widget>[
       SvgPicture.asset('assets/images/search.svg',
          height:300) ,
      Text('find Users',textAlign:TextAlign.center,
      style:TextStyle(
        color: Colors.white,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w600,
        fontSize: 60.0,
      ) ,)
        
         
        ],
        ) ,
        ),
  );
}
resultWidget() {
 return FutureBuilder(
   future:searchResults,
   builder: (context, snapshot){
     if(!snapshot.hasData) {
       circularProgress();
     }
     List<UserResult> listResult = [];
     snapshot.data.documents.forEach((doc){
       User user = User.fromDocument(doc);
      UserResult userTile = UserResult(user);
      listResult.add(userTile);
     });
     return ListView(children:listResult);
   },
   );
 
}
bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor.withOpacity(0.8),
      appBar: searchWidget(),
      body:searchResults==null ? noResultWidget() : resultWidget(),
    );
  }
}

class UserResult extends StatelessWidget {
 final User user;

UserResult(this.user);
showProfile(context){
Navigator.push(context, MaterialPageRoute(builder: (context)=>
  Profile(profileId:user.id)
  ));
}
  @override
  Widget build(BuildContext context) {
    return Container(
      color:Theme.of(context).accentColor.withOpacity(0.7),
      child:Column(children: <Widget>[
      ListTile(
        leading:CircleAvatar(
          
          backgroundImage: CachedNetworkImageProvider(user.photourl),
         
         
        ) ,
        title: Text(user.displayName,style: TextStyle(color: Colors.white),),
        subtitle: Text(user.username,style: TextStyle(color: Colors.white),),
        onTap:()=>showProfile(context)),
        Divider(height: 2.0,color: Colors.white,)
    ],)
    );
  }
}
