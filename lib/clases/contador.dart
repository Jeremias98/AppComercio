
class Contador {
  num contadorUnidades = 1;

  Contador() {
    contadorUnidades = 1;
  }

  void incrementarContador() {
    contadorUnidades++;
  }

  void decrementarContador() {
    if (contadorUnidades > 1) contadorUnidades--;
  }

  void reestablecerContador() {
    contadorUnidades = 1;
  }

  void establecerContador(num cantidad) {
    contadorUnidades = cantidad;
  }

  num obtenerContador() {
    return contadorUnidades;
  }
}
