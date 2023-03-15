resource "null resource" "test" {
  provisioner "local-exec" {
    command = "echo ${var.env}"
  }
}