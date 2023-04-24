class DeleteResponseRequest {
  String environmentId;
  String pathId;
  String responseId;

  DeleteResponseRequest(
      {required this.environmentId,
      required this.pathId,
      required this.responseId});
}
