enum LoadingStatus { loading, success, failure }

class LoadingRecipe {
  final String title;
  final DateTime startTime;
  LoadingStatus status;

  LoadingRecipe({required this.title, required this.startTime, this.status = LoadingStatus.loading});
}
