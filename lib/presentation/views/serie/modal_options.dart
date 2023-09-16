import 'dart:convert';

import 'package:anirecord/data/providers/riverpod/auth_provider.dart';
import 'package:anirecord/data/providers/riverpod/serie_provider.dart';
import 'package:anirecord/domain/entities/serie_entity.dart';
import 'package:anirecord/domain/usercases/auth_user_cases/get_user_case.dart';
import 'package:anirecord/domain/usercases/serie_user_cases/add_serie_to_album_user_case.dart';
import 'package:anirecord/presentation/utils/const.dart';
import 'package:anirecord/presentation/views/home/list/list_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final optionStateProvider = StateNotifierProvider.family<OptionStateNotifier,
    Map<String, dynamic>, String>((ref, id) {
  final addSerieToAlbumUserCase = ref.watch(addSerieToAlbumProvider);
  final getUserUseCase = ref.watch(getUserCasePovider);
  void onRefresh() => ref.refresh(albumProvider);

  return OptionStateNotifier(
      addSerieToAlbumUserCase, getUserUseCase, onRefresh);
});

class OptionStateNotifier extends StateNotifier<Map<String, dynamic>> {
  final AddSerieToAlbumUserCase addSerieToAlbumUserCase;
  final GetUserCase getUserUseCase;
  late Map<String, dynamic> initialState;
  final void Function() onRefresh;
  OptionStateNotifier(
      this.addSerieToAlbumUserCase, this.getUserUseCase, this.onRefresh)
      : super({});

  void toggleButton(String aid, SeriePortable serie) {
    bool a = !state[aid]['status'];
    state[aid]['status'] = a;
    state = {...state};
  }

  void back() {
    state = json.decode(json.encode(initialState));
  }

  void save(Serie serie) {
    final changedToTrue = <String>[];
    final changedToFalse = <String>[];

    // Itera a través de las claves en initial
    for (final key in initialState.keys) {
      // Verifica si la clave existe en state y si el valor 'status' ha cambiado
      if (state.containsKey(key)) {
        final initialStatus = initialState[key]['status'];
        final stateStatus = state[key]['status'];

        if (initialStatus != stateStatus) {
          if (stateStatus == true) {
            addSerieToAlbumUserCase.call(
                getUserUseCase.call()!.uid, key, serie, true);

            changedToTrue.add(key);
          } else if (stateStatus == false) {
            addSerieToAlbumUserCase.call(
                getUserUseCase.call()!.uid, key, serie, false);

            changedToFalse.add(key);
          }
        }
      }
    }
    setInitialState();
    onRefresh();
  }

  void setState(Map<String, dynamic> newState) {
    state = {...newState};
  }

  void setInitialState() {
    initialState = json.decode(json.encode(state));
  }
}

final optionsAlbumProvier =
    FutureProvider.family<void, String>((ref, sid) async {
  final userData = ref.read(getUserCasePovider);
  final a = await ref
      .read(getAllAlbumsByIdUserProvider)
      .call(userData.call()!.uid, sid);
  ref.read(optionStateProvider(sid).notifier).setState(a);
  ref.read(optionStateProvider(sid).notifier).setInitialState();
});

final actionProvider = StateProvider<bool>((ref) => false);

class ModalOptionsFlow extends ConsumerWidget {
  const ModalOptionsFlow({super.key, required this.serie});
  final Serie serie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAlbum = ref.watch(optionsAlbumProvier(serie.id));
    return RefreshIndicator(
      onRefresh: ()async => await ref.refresh(optionsAlbumProvier(serie.id)),
      child: optionsAlbum.when(data: (_) {
        final option = ref.watch(optionStateProvider(serie.id));
        return option.isNotEmpty
            ? ListView.separated(
                itemCount: option.entries.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    thickness: 1.2,
                  ); // Agregar un Divider() entre todos los elementos
                },
                itemBuilder: (BuildContext context, int index) {
                  final e = option.entries.toList()[index];
                  return ListTile(
                    leading: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        const Icon(
                          Icons.folder,
                          color: colorPrimaryInverted,
                          size: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, right: 8),
                          child: e.value['iconCode'] != 57570
                              ? Icon(
                                  IconData(e.value['iconCode'],
                                      fontFamily: 'MaterialIcons'),
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      ],
                    ),
                    title: Text(
                      e.value['title'],
                      style: const TextStyle(fontSize: 15),
                    ),
                    subtitle: e.value['recuento'] != null
                        ? Text(
                            "${e.value['recuento']} series",
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                    trailing: Checkbox(
                      activeColor: colorPrimaryInverted,
                      value: e.value['status'],
                      onChanged: (bool? value) {
                        ref
                            .read(optionStateProvider(serie.id).notifier)
                            .toggleButton(
                              e.key,
                              SeriePortable(
                                serie.id,
                                serie.name,
                                serie.studio,
                                serie.year,
                              ),
                            );
                      },
                    ),
                  );
                },
              )
            : const Center(
                child: Text("No hay listas disponibles"),
              );
      }, error: (_, __) {
        return Text(_.toString());
      }, loading: () {
        return const Center(
            child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(
            strokeWidth: 1,
          ),
        ));
      }),
    );
  }
}
