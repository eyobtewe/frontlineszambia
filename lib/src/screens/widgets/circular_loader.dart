import 'package:flutter/cupertino.dart';

class CustomCircularLoader extends StatelessWidget {
  const CustomCircularLoader({Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 50,
      height: 50,
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}

// LoadingIndicator(indicatorType: Indicator.orbit, color: cWhite),
