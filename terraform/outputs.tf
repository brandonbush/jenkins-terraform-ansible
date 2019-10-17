/*output "private_ip" {
  value = "${aws_instance.test-server.private_ip}"
}
*/

output "failover_az_out" {
  value = var.failover_az
}