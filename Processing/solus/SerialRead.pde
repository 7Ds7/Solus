import processing.serial.*;

class SerialRead {
  Serial serial_port;

  public SerialRead () {
    serial_port = new Serial (ROOT, Serial.list()[1], 9600);
  }

  String checkState() {
    String inByte = serial_port.readString();
    println(inByte);
    return inByte;
  }
}

