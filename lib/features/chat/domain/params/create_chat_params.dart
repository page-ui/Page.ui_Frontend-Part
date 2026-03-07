class CreateChatParams {
  final String name;

  const CreateChatParams({required this.name});

  Map<String, dynamic> toInputJson() {
    return {'name': name};
  }
}
