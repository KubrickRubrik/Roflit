abstract final class BackgroundColors {
  static const List<BackgroundColorEntity> listFones = [
    BackgroundColorEntity(idFone: 1, color: [0xFF575E78, 0xFF2D3A46]),
    BackgroundColorEntity(idFone: 2, color: [0xFF44578B, 0xFF0E335E]),
    BackgroundColorEntity(idFone: 3, color: [0xFF567055, 0xFF2C2B38]),
    BackgroundColorEntity(idFone: 4, color: [0xFF756158, 0xFF382B2B]),
    BackgroundColorEntity(idFone: 5, color: [0xFF785757, 0xFF442D46]),
    // BackgroundColorEntity(idFone: 6, color: [0xFF8D3F3F, 0xFF4B1313]),
    // BackgroundColorEntity(idFone: 7, color: [0xFF602579, 0xFF3A1137]),
    BackgroundColorEntity(idFone: 8, color: [0xFF255F79, 0xFF11303A]),
  ];
  // static final List<int> listDuration = [10, 15];
  // static final List<double> listAlignment = [-0.5, -0.4, -0.3, -0.2, 0.2, 0.3, 0.4, 0.5];
  // static final List<double> listRadius = [1, 1.2, 1.4, 1.6];
}

final class BackgroundColorEntity {
  final int idFone;
  final List<int> color;
  const BackgroundColorEntity({required this.idFone, required this.color});
}
