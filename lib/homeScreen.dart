import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //This list will contain the elements to show in the listview
  final List<String> list =
      List.generate(20, (index) => 'List item ${index + 1}');

  // We will be controlling the listview scroll events through this controller
  final ScrollController _scrollController = ScrollController();

  // This var will help us track the scrolling events and have more controll over it.
  bool _isLoading;

  @override
  void initState() {
    // initializing the tracker
    _isLoading = false;

    // Adding a scroll event listener to our controller, this will let us perform actions
    // for each scrolling event.
    _scrollController
      ..addListener(() async {
        // position.pixels = the currently scrolled position in pixels
        // position.maxScrollExtent = The maximum scrolling position
        // checking if the currently scrolled position is greater than 80% of the maximum
        // scroll extent
        // we're also checking if our tracker isn't put to true so we don't execute the
        // fetch data function more than it should.
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent * 0.8 &&
            !_isLoading) {
          // Setting the tracker to true so it displays a loading indicator in the ListView
          // and not allow this condition to launch again when the data is still not fetched yet.
          setState(() {
            _isLoading = true;
          });

          // Replace this with any fetching function.
          await fetchData(list);

          // Setting the tracker back to false so it removes the loading indicator and allows
          // these conditional instructions to be run again.
          setState(() {
            _isLoading = false;
          });
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    // Cleaning the controller from the memory to avoid some dumb shi*
    // Because you can
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // This is the list lol
        child: ListView.builder(
          // linking the controller with the list
          controller: _scrollController,
          itemCount: list.length,
          // some fancy scrolling behavious (you can delete it)
          physics: BouncingScrollPhysics(),
          itemBuilder: (_, index) {
            // putting the item widget inside a var just to make the code looks smoother
            // because of the conditional rendering below
            final itemToDisplay = Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    list.elementAt(index),
                  ),
                ),
              ),
            );

            // rendering a column containing the last item of the list
            // and a loading indicator which is controller by the _isLoading var
            // that is updated whenever the user reaches 80% of the listView
            // and fetching function isn't finished yet.
            return index == list.length - 1 && _isLoading
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      itemToDisplay,
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 20.0,
                        ),
                        child: LinearProgressIndicator(),
                      ),
                    ],
                  )
                : itemToDisplay;
          },
        ),
      ),
    );
  }
}

// This function generates some random data and adds it to the list that is displayed inside
// the ListView after a delay of 3 seconds.
Future fetchData(List<String> list) async {
  await Future.delayed(Duration(seconds: 3));
  list.addAll(
    List.generate(20, (index) => 'Item Added when scrolling ${index + 1}'),
  );
}
