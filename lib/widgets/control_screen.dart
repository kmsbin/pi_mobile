import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pi_mobile/app_module.dart';
import 'package:pi_mobile/blocs/controls_bloc.dart';
import 'package:pi_mobile/blocs/directions/directions_bloc.dart';
import 'package:pi_mobile/controller/map_screen_controller.dart';
import 'package:pi_mobile/pages/maps/input_modal.dart';
import 'package:provider/provider.dart';

import '../custom_icons.dart';

class ControllScreen extends StatefulWidget {
  @override
  _ControllScreenState createState() => _ControllScreenState();
}

class _ControllScreenState extends State<ControllScreen> with SingleTickerProviderStateMixin {
  List<Animation<Offset>> navOffset = [];
  Animation colorButton;
  AnimationController _controller;
  bool isRun = false;

  double iconDistance = -3;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    navOffset.length = 3;
    for (int index = 0; index < 3; index++) {
      navOffset[index] = Tween<Offset>(begin: Offset.zero, end: Offset(0, iconDistance)).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutCubic,
      ));
      colorButton = ColorTween(begin: Color(0xffD31B77), end: Colors.red[800]).animate(_controller);
      iconDistance = iconDistance - 1.5;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  var provider = AppModule.to.bloc<ControlsBloc>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: provider.output,
        builder: (context, snapshot) {
          return Stack(children: <Widget>[
            Align(
                alignment: Alignment.bottomRight,
                child: SlideTransition(
                  position: navOffset[0],
                  child: FloatingActionButton(
                      heroTag: "awserhwgwegwerh",
                      child: Icon(Icons.search),
                      onPressed: () {
                        isRun = !isRun;
                        if (isRun) {
                          _controller.forward();
                          // isRun = false;
                          return;
                        }
                        _controller.reverse();

                        showGeneralDialog(
                            context: context,
                            barrierDismissible: true,
                            barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                            pageBuilder: (BuildContext ctxt, asd, dfsg) {
                              AppModule.to.bloc<DirectionsBloc>().modalContext = ctxt;
                              return InputsModal(
                                screenSize: MediaQuery.of(ctxt).size,
                                routeType: provider.routeType,
                                modalCtxt: ctxt,
                              );
                            });
                        // Navigator.pushNamed(context, '/modal-locations');
                      }),
                )),
            AnimatedOpacity(
              opacity: provider.routeType == "cycling" ? 0.6 : 1,
              duration: Duration(milliseconds: 500),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: SlideTransition(
                    position: navOffset[1],
                    child: FloatingActionButton(
                        heroTag: "asdgaehadgtxedcrfect",
                        child: Icon(Icons.directions_bike),
                        onPressed: () {
                          print("\n ${provider.routeType}\n");
                          if (provider.routeType != "cycling") {
                            provider.changeRouteType(RouteType.cycling);
                          }
                        }),
                  )),
            ),
            AnimatedOpacity(
              opacity: provider.routeType == "walking" ? 0.6 : 1,
              duration: Duration(milliseconds: 500),
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: SlideTransition(
                    position: navOffset[2],
                    child: FloatingActionButton(
                        heroTag: "@#ahgdsaëaerha4wgrafhadfsyhwasdh#sd#ha%h",
                        child: Icon(FastBike.bike_fast_icon_135885),
                        onPressed: () {
                          print("\n ${provider.routeType}\n");
                          if (provider.routeType != "walking") {
                            provider.changeRouteType(RouteType.walking);
                          }
                          // _controller.reverse();
                        }),
                  )),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: AnimatedBuilder(
                    animation: colorButton,
                    builder: (context, widget) {
                      return FloatingActionButton(
                          mini: false,
                          backgroundColor: colorButton.value,
                          child: AnimatedIcon(
                            icon: AnimatedIcons.menu_close,
                            progress: _controller,
                          ),
                          heroTag: "asdg#ssehja2345%rh",
                          onPressed: () {
                            isRun = !isRun;
                            if (isRun) {
                              _controller.forward();
                              // isRun = false;
                              return;
                            }
                            _controller.reverse();
                          });
                    }))
          ]);
        });
  }
}
