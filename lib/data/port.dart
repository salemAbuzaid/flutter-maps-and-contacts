class Port {
  String id = '';
  String connectorType = '';
  String status = '';
  num power = 0.0;

  Port(
    this.id,
    this.connectorType,
    this.status,
  );

  Port.fromJson(Map<String, dynamic> portJson) {
    id = portJson['id'];
    connectorType = portJson['connector_type'];
    status = portJson['port_status'][0]['status'];
    power = portJson['power_kw'];
  }
}
