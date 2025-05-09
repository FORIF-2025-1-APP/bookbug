import 'package:bookbug/ui/core/ui/pagetitle_Base.dart';
import 'package:flutter/material.dart';

class WongyuTest extends StatelessWidget {
  const WongyuTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: PagetitleBase(title: 'home', fontsize: 25)),
    );
  }
}
