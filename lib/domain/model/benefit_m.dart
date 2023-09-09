class Benefit {

  String? name;
  String? img;
  bool? status;

  Benefit();

  Benefit.fromJson(this.name, this.status, this.img);

  List<Benefit> filter(List<Map<String ,dynamic>> jsn){
    List<Benefit> lst = jsn.map((e) => Benefit.fromJson(e['name'], e['status'], e['img'])).toList();
    return lst;
  }
}