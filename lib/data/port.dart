class Port {
  String id = '';
  String connectorType = '';
  String status = '';

  Port(
    this.id,
    this.connectorType,
    this.status,
  );

  Port.fromJson(Map<String, dynamic> portJson) {
    id = portJson['id'];
    connectorType = portJson['connector_type'];
    status = portJson['port_status'][0]['status'];
  }
}
