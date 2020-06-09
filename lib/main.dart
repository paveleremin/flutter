import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final counter;
  AppState(this.counter);
}

//action
enum Actions { Increment }

//pure function
AppState reducer(AppState prev, action) {
  if (action == Actions.Increment) {
    return new AppState(prev.counter + 1);
  }
  return prev;
}

void main() {
  // Create your store as a final variable in the main function or inside a
  // State object. This works better with Hot Reload than creating it directly
  // in the `build` function.
  final store = Store<AppState>(reducer, initialState: new AppState(0));

  runApp(FlutterReduxApp(
    title: 'Flutter Redux Demo',
    store: store,
  ));
}

class FlutterReduxApp extends StatelessWidget {
  final Store<AppState> store;
  final String title;

  FlutterReduxApp({Key key, this.store, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return StoreProvider<AppState>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
        theme: ThemeData.dark(),
        title: title,
        home: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'You have pushed the button this many times:',
                ),
                // Connect the Store to a Text Widget that renders the current
                // count.
                //
                // We'll wrap the Text Widget in a `StoreConnector` Widget. The
                // `StoreConnector` will find the `Store` from the nearest
                // `StoreProvider` ancestor, convert it into a String of the
                // latest count, and pass that String  to the `builder` function
                // as the `count`.
                //
                // Every time the button is tapped, an action is dispatched and
                // run through the reducer. After the reducer updates the state,
                // the Widget will be automatically rebuilt with the latest
                // count. No need to manually manage subscriptions or Streams!
                StoreConnector<AppState, String>(
                  converter: (store) => store.state.counter.toString(),
                  builder: (context, count) {
                    return Text(
                      count,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                )
              ],
            ),
          ),
          // Connect the Store to a FloatingActionButton. In this case, we'll
          // use the Store to build a callback that with dispatch an Increment
          // Action.
          //
          // Then, we'll pass this callback to the button's `onPressed` handler.
          floatingActionButton: StoreConnector<AppState, VoidCallback>(
            converter: (store) {
              // Return a `VoidCallback`, which is a fancy name for a function
              // with no parameters. It only dispatches an Increment action.
              return () => store.dispatch(Actions.Increment);
            },
            builder: (context, callback) {
              return FloatingActionButton(
                // Attach the `callback` to the `onPressed` attribute
                onPressed: callback,
                tooltip: 'asdasdasd',
                child: Icon(Icons.add),
              );
            },
          ),
        ),
      ),
    );
  }
}