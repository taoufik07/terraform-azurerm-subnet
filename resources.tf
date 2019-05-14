resource "azurerm_subnet" "subnet" {
  count = "${length(var.subnet_cidr_list)}"

  name                 = "${coalesce(element(var.custom_subnet_names, count.index), length(var.subnet_cidr_list) == 1 ? local.subnet_name : "${local.subnet_name}${count.index}")}"
  resource_group_name  = "${var.resource_group_name}"
  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${element(var.subnet_cidr_list, count.index)}"

  route_table_id            = "${element(coalescelist(var.route_table_ids, list("")), count.index)}"
  network_security_group_id = "${element(coalescelist(var.network_security_group_ids, list("")), count.index)}"

  service_endpoints = "${var.service_endpoints}"
}

resource "azurerm_subnet_network_security_group_association" "subnet_association" {
  count = "${length(var.network_security_group_ids)}"

  subnet_id                 = "${element(azurerm_subnet.subnet.*.id, count.index)}"
  network_security_group_id = "${element(var.network_security_group_ids, count.index)}"
}

resource "azurerm_subnet_route_table_association" "route_table_association" {
  count = "${length(var.route_table_ids)}"

  subnet_id      = "${element(azurerm_subnet.subnet.*.id, count.index)}"
  route_table_id = "${element(var.route_table_ids, count.index)}"
}
