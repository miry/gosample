resource "tls_private_key" "kube" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "local_file" "private_key" {
  sensitive_content = tls_private_key.kube.private_key_pem
  filename          = "${path.module}/assets/private.key"
  file_permission   = "0600"
}
