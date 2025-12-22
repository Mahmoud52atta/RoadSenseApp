abstract class Failuers {
  String message;
  Failuers(this.message);
}

class ServerFailuer extends Failuers {
  ServerFailuer(super.message);
}
