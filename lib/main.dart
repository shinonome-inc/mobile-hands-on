import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Hands On',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TwitterHomePage(),
    );
  }
}

class TwitterAppBar extends StatelessWidget with PreferredSizeWidget {
  const TwitterAppBar({
    Key? key,
    required this.backgroundColor,
    required this.leftImageUrl,
    required this.centerImageUrl,
    required this.rightImageUrl,
  }) : super(key: key);
  final Color backgroundColor;
  final String leftImageUrl;
  final String centerImageUrl;
  final String rightImageUrl;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(
          radius: 8.0,
          backgroundImage: NetworkImage(leftImageUrl),
        ),
      ),
      title: SizedBox(
        width: 44.0,
        height: 44.0,
        child: centerImageUrl.isEmpty
            ? const SizedBox.shrink()
            : Image.network(
                centerImageUrl,
                errorBuilder: (c, o, s) => const SizedBox.shrink(),
              ),
      ),
      actions: <Widget>[
        if (rightImageUrl.isNotEmpty) Image.network(rightImageUrl),
      ],
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
    );
  }
}

class TweetUserIcon extends StatelessWidget {
  const TweetUserIcon({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20.0,
      backgroundImage: NetworkImage(tweet.userIconUrl),
    );
  }
}

class TweetHeader extends StatelessWidget {
  const TweetHeader({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  String timeFormatter(int seconds) {
    String timeText = '$seconds秒';
    if (seconds >= 86400) {
      timeText = '${seconds ~/ 86400}日';
    } else if (seconds >= 3600) {
      timeText = '${seconds ~/ 3600}時間';
    } else if (seconds >= 60) {
      timeText = '${seconds ~/ 60}分';
    }
    return timeText;
  }

  @override
  Widget build(BuildContext context) {
    final rand = math.Random();
    final seconds = rand.nextInt(300000);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: tweet.userName,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const WidgetSpan(
                  child: SizedBox(width: 8.0),
                ),
                TextSpan(
                  text: '@${tweet.userId}',
                ),
                const TextSpan(
                  text: '・',
                  style: TextStyle(fontSize: 10.0),
                ),
                TextSpan(text: timeFormatter(seconds)),
              ],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Icon(
          Icons.keyboard_control,
          size: 16.0,
          color: Colors.grey,
        ),
      ], // <Widget>[]
    );
  }
}

class TweetBody extends StatelessWidget {
  const TweetBody({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        tweet.text,
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}

class TweetFooterItem extends StatelessWidget {
  const TweetFooterItem({
    Key? key,
    required this.iconData,
    this.count,
  }) : super(key: key);
  final IconData? iconData;
  final int? count;

  String get countText {
    if (count == null) {
      return '';
    } else if (count! >= 10000) {
      return '${(count! / 10000).toStringAsFixed(1)}万';
    } else {
      return '$count';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black87,
            size: 16.0,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                countText,
                style: const TextStyle(color: Colors.black87, fontSize: 12.0),
              ),
            ),
          ),
        ], // <Widget>[]
      ), // Row
    );
  }
}

class TweetFooter extends StatelessWidget {
  const TweetFooter({Key? key, required this.tweet}) : super(key: key);
  final Tweet tweet;

  @override
  Widget build(BuildContext context) {
    final rand = math.Random();
    final int replayCount = rand.nextInt(500);
    final int retweetCount = rand.nextInt(10000) + replayCount;
    final int likesCount = rand.nextInt(90000) + retweetCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TweetFooterItem(
          iconData: CupertinoIcons.chat_bubble,
          count: replayCount,
        ),
        TweetFooterItem(
          iconData: CupertinoIcons.arrow_2_squarepath,
          count: retweetCount,
        ),
        TweetFooterItem(
          iconData: CupertinoIcons.heart,
          count: likesCount,
        ),
        const TweetFooterItem(
          iconData: CupertinoIcons.tray_arrow_up,
        ),
      ], // <Widget>[]
    );
  }
}

class TweetItem extends StatelessWidget {
  const TweetItem({
    Key? key,
    required this.tweetImage,
    required this.tweetHeader,
    required this.tweetBody,
    required this.tweetFooter,
  }) : super(key: key);
  final Widget tweetImage;
  final Widget tweetHeader;
  final Widget tweetBody;
  final Widget tweetFooter;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              tweetImage,
              const SizedBox(width: 8.0),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    tweetHeader,
                    tweetBody,
                    tweetFooter,
                  ], // <Widget>[]
                ), // Column
              ),
            ], // <Widget>[]
          ), // Row
        ),
        const Divider(),
      ], // <Widget>[]
    );
  }
}

class TwitterBottomNavigationBar extends StatelessWidget {
  const TwitterBottomNavigationBar({
    Key? key,
    required this.homeIcon,
    required this.searchIcon,
    required this.bellIcon,
    required this.mailIcon,
  }) : super(key: key);
  final Icon homeIcon;
  final Icon searchIcon;
  final Icon bellIcon;
  final Icon mailIcon;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black87,
      unselectedItemColor: Colors.black45,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      iconSize: 28.0,
      type: BottomNavigationBarType.fixed,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: homeIcon,
          label: '',
        ),
        BottomNavigationBarItem(
          icon: searchIcon,
          label: '',
        ),
        BottomNavigationBarItem(
          icon: bellIcon,
          label: '',
        ),
        BottomNavigationBarItem(
          icon: mailIcon,
          label: '',
        ),
      ],
    );
  }
}

class TwitterHomePage extends StatefulWidget {
  const TwitterHomePage({Key? key}) : super(key: key);

  @override
  State<TwitterHomePage> createState() => _TwitterHomePageState();
}

class _TwitterHomePageState extends State<TwitterHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ------------------------------ appBar ------------------------------
      // backgroundColor: Colors.white,
      // leftImageUrl: Data.loginUser.iconUrl,  // この行は変更しなくてOK
      // centerImageUrl: 'https://img.icons8.com/color/48/000000/twitter--v1.png',
      // rightImageUrl: 'https://img.icons8.com/material-outlined/24/000000/sparkling.png',
      appBar: TwitterAppBar(
        backgroundColor: Colors.white,
        leftImageUrl: Data.loginUser.iconUrl, // この行は変更しなくてOK
        centerImageUrl:
            'https://img.icons8.com/color/48/000000/twitter--v1.png',
        rightImageUrl:
            'https://img.icons8.com/material-outlined/24/000000/sparkling.png',
      ), // appBar

      // ------------------------------ body ------------------------------
      // tweetImage: tweetImage(tweet),
      // tweetHeader: tweetHeader(tweet),
      // tweetBody: tweetBody(tweet),
      // tweetFooter: tweetFooter(tweet),
      body: ListView.builder(
        itemCount: Data.tweetList.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          final Tweet tweet = Data.tweetList[index];
          return TweetItem(
            tweetImage: TweetUserIcon(tweet: tweet),
            tweetHeader: TweetHeader(tweet: tweet),
            tweetBody: TweetBody(tweet: tweet),
            tweetFooter: TweetFooter(tweet: tweet),
          );
        }, // Column
      ),

      // ----------------------- floatingActionButton -----------------------
      // child: const Icon(Icons.add),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),

      // ----------------------- bottomNavigationBar -----------------------
      bottomNavigationBar: const TwitterBottomNavigationBar(
        // homeIcon: const Icon(CupertinoIcons.home),
        // searchIcon: const Icon(CupertinoIcons.search),
        // bellIcon: const Icon(CupertinoIcons.bell),
        // mailIcon: const Icon(CupertinoIcons.mail),
        homeIcon: Icon(CupertinoIcons.home),
        searchIcon: Icon(CupertinoIcons.search),
        bellIcon: Icon(CupertinoIcons.bell),
        mailIcon: Icon(CupertinoIcons.mail),
      ), // bottomNavigation
    ); // Scaffold
  }
}

class User {
  String iconUrl;
  String name;
  String id;

  User({
    required this.iconUrl,
    required this.name,
    required this.id,
  });
} // class User

class Tweet {
  String userIconUrl;
  String userName;
  String userId;
  String text;
  String postImage;

  Tweet({
    required this.userIconUrl,
    required this.userName,
    required this.userId,
    required this.text,
    required this.postImage,
  });
} // class Tweet

class Data {
  // ---------------------- ログインユーザーのデータ ---------------------
  static User loginUser = User(
    iconUrl: 'https://lohas.nicoseiga.jp/thumb/10871615i?1640475082',
    name: 'name',
    id: 'id',
  ); // loginUser

  // ------------------------- ツイートのデータ -------------------------
  static List<Tweet> tweetList = [
    Tweet(
      userIconUrl: 'https://lohas.nicoseiga.jp/thumb/10871615i?1640475082',
      userName: 'name',
      userId: 'id',
      text: 'ツイート本文',
      postImage: '',
    ),
  ]; // tweetList
} // class Data
