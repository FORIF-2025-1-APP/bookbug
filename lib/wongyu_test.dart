import 'package:bookbug/ui/core/ui/badgebutton_Base.dart';
import 'package:bookbug/ui/core/ui/pagetitle_base.dart';
import 'package:bookbug/ui/core/ui/profileimage_base.dart';
import 'package:flutter/material.dart';

class WongyuTest extends StatelessWidget {
  const WongyuTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: PagetitleBase(title: 'home', fontsize: 25)),
      body: Column(
        children: [
          Row(
            children: [
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
            ],
          ),
          Row(
            children: [
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
              BadgebuttonBase(badge: 'assets/hyu.jpeg', badgename: 'HYU'),
            ],
          ),
          ProfileimageBase(image: 'assets/hyu.jpeg', badge: 'assets/hyu.jpeg'),
        ],
      ),
    );
  }
}
