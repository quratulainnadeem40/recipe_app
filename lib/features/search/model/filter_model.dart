class FilterModel {
  String? category;
  String? area;
  String? sortBy; // 'popular', 'newest', 'time'
  double maxPrepTime; // Minutes mein

  FilterModel({
    this.category,
    this.area,
    this.sortBy = 'popular',
    this.maxPrepTime = 60.0,
  });

  void reset() {
    category = null;
    area = null;
    sortBy = 'popular';
    maxPrepTime = 60.0;
  }
}