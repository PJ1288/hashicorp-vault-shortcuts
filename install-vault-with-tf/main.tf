# main.tf

provider "aws" {
  region = "us-east-2"
}

# SSH key pair
resource "aws_key_pair" "deployer_key" {
  key_name   = "shortcut-vault-key"
  public_key = file("<path to public key>")
}

resource "aws_instance" "vault_server" {
  ami           = "ami-0649bea3443ede307"
  instance_type = "t2.micro"
  key_name      = "shortcut-vault-key"

  tags = {
    Name = "ShortcutVaultServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              yum install -y yum-utils
              yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
              yum -y install vault
              systemctl start vault
              systemctl enable vault
              EOF
}

output "vault_server_public_ip" {
  value = aws_instance.vault_server.public_ip
}
