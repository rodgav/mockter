class BaseViewModel extends BaseViewModelInput with BaseViewModelOutput {
  @override
  finish() {}

  @override
  start() {}
}

abstract class BaseViewModelInput {
  start();

  finish();
}

abstract class BaseViewModelOutput {}
