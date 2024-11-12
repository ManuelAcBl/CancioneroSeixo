import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cancionero_seixo/controller/utils/local_save/local_save.dart';

class ScreenListNotifier extends Notifier<List<Display>?> {
  final LocalSave saver = LocalSave<List<int>>(name: "screens");

  static const EventChannel _eventChannel = EventChannel('com.manuelac.cancionero/screens_event');
  static const MethodChannel _methodChannel = MethodChannel('com.manuelac.cancionero/presenation');

  @override
  List<Display>? build() {
    List<int>? selected;

    //Future(() async => selected = await saver.load());

    _eventChannel.receiveBroadcastStream().listen((data) {
      Iterable<Display> displays = (jsonDecode(data) as List).map(
        (json) => kReleaseMode ? Display.fromJsonRelease(json) : Display.fromJson(json),
      );

      if(selected != null) {
        for(Display display in displays) {
          if(selected!.contains(display.id) && !display.selected) {
            _startPresentation(display.id);
          }
        }
      }

      state = displays.toList();
    });

    return null;
  }

  Future<void> openSettings() async {
    await _methodChannel.invokeMethod<String>('openSettings');
  }

  Future<bool> toggle(int displayId) async {
    Display display = state!.firstWhere((display) => display.id == displayId);

    if (display.selected) {
      return _stopPresentation(displayId);
    } else {
      return _startPresentation(displayId);
    }
  }

  Future<bool> _startPresentation(int displayId) async {
    bool? result = await _methodChannel.invokeMethod<bool>('showPresentation', {'displayId': displayId});

    return result == true;
  }

  Future<bool> _stopPresentation(int displayId) async {
    bool? result = await _methodChannel.invokeMethod<bool>('hidePresentation', {'displayId': displayId});

    return result == true;
  }

  @override
  bool updateShouldNotify(List<Display>? previous, List<Display>? next) {
    if (next != null) {
      saver.save(next.where((display) => display.selected == true).map((display) => display.id).toList());
    }

    return super.updateShouldNotify(previous, next);
  }
}

class Display {
  final int id, width, height;
  final String name;
  final double refreshRate;
  final bool selected;

  Display({
    required this.id,
    required this.width,
    required this.height,
    required this.name,
    required this.refreshRate,
    required this.selected,
  });

  factory Display.fromJson(Map<String, dynamic> json) => Display(
        id: json['id'],
        width: json['width'],
        height: json['height'],
        name: json['name'],
        refreshRate: json['refreshRate'],
        selected: json['selected'],
      );

  factory Display.fromJsonRelease(Map<String, dynamic> json) => Display(
        id: json['a'],
        width: json['b'],
        height: json['c'],
        name: json['d'],
        refreshRate: json['e'],
        selected: json['f'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'width': width,
        'height': height,
        'name': name,
        'refreshRate': refreshRate,
        'selected': selected,
      };
}
