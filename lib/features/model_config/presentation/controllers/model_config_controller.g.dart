// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_config_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(providersConfig)
final providersConfigProvider = ProvidersConfigProvider._();

final class ProvidersConfigProvider
    extends
        $FunctionalProvider<
          AsyncValue<ProvidersConfig>,
          ProvidersConfig,
          FutureOr<ProvidersConfig>
        >
    with $FutureModifier<ProvidersConfig>, $FutureProvider<ProvidersConfig> {
  ProvidersConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'providersConfigProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$providersConfigHash();

  @$internal
  @override
  $FutureProviderElement<ProvidersConfig> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ProvidersConfig> create(Ref ref) {
    return providersConfig(ref);
  }
}

String _$providersConfigHash() => r'e2ff73813b840311cdc81bbe6411d20be6700000';

@ProviderFor(SpeechProviderController)
final speechProviderControllerProvider = SpeechProviderControllerProvider._();

final class SpeechProviderControllerProvider
    extends
        $AsyncNotifierProvider<
          SpeechProviderController,
          ({
            String? apiKey,
            String? customEndpoint,
            String? modelId,
            String? providerId,
          })
        > {
  SpeechProviderControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'speechProviderControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$speechProviderControllerHash();

  @$internal
  @override
  SpeechProviderController create() => SpeechProviderController();
}

String _$speechProviderControllerHash() =>
    r'748614be744175ccee59b982f5a00e12b631b6d8';

abstract class _$SpeechProviderController
    extends
        $AsyncNotifier<
          ({
            String? apiKey,
            String? customEndpoint,
            String? modelId,
            String? providerId,
          })
        > {
  FutureOr<
    ({
      String? apiKey,
      String? customEndpoint,
      String? modelId,
      String? providerId,
    })
  >
  build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<
                ({
                  String? apiKey,
                  String? customEndpoint,
                  String? modelId,
                  String? providerId,
                })
              >,
              ({
                String? apiKey,
                String? customEndpoint,
                String? modelId,
                String? providerId,
              })
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<
                  ({
                    String? apiKey,
                    String? customEndpoint,
                    String? modelId,
                    String? providerId,
                  })
                >,
                ({
                  String? apiKey,
                  String? customEndpoint,
                  String? modelId,
                  String? providerId,
                })
              >,
              AsyncValue<
                ({
                  String? apiKey,
                  String? customEndpoint,
                  String? modelId,
                  String? providerId,
                })
              >,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
