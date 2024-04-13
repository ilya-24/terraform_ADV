resource "yandex_compute_instance" "my_webserver" {
  count              = 1
  zone               = "ru-central1-a"
  maintenance_policy = "restart"


  metadata = {
    name      = "Ubuntu"
    foo       = "bar"
    ssh-keys  = file("~/.ssh/id_rsa.pub")
    user-data = <<EOF
#!/bin/bash
apt-get -y update
apt-get -y install apache2
apt-get -y install curl
myip=`curl http://127.0.0.1/latest/meta-data/local-ipv4`
echo "<h2>WebServer with IP: $myip</h2><br>Build by Terraform!"  >  /var/www/html/index.html
sudo service apache2 start
sudo systemctl enable apache2
EOF
  }
  resources {
    # Доля CPU в %
    core_fraction = 5
    cores         = 2
    memory        = 1
  }
  boot_disk {
    initialize_params {
      # image_id Ubuntu https://yandex.cloud/ru/marketplace/products/yc/ubuntu-2204-lts-oslogin
      image_id = "fd8l45jhe4nvt0ih7h2e"
    }
  }
  network_interface {
    # идентификатор подсети https://console.yandex.cloud/folders/b1g8kbqq92bvsk3h7i1u/vpc/network/enpeiguhevrqhejt3l7v/overview
    subnet_id          = "e9berr3calqh9d4rpkcb"
    security_group_ids = [yandex_vpc_security_group.my_webserver.id]
  }
  scheduling_policy {
    # Сделать ВМ прерываемой(дешевле)
    preemptible = "true"
  }
}

# resource "yandex_vpc_network" "lab-net" {
#   name = "lab-network"
# }

resource "yandex_vpc_security_group" "my_webserver" {

  network_id = "enpeiguhevrqhejt3l7v"

  ingress {
    protocol       = "TCP"
    description    = "rule1 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 80
    to_port        = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "rule2 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 443
    to_port        = 443
  }

  egress {
    protocol       = "ANY"
    description    = "rule3 description"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 0
  }
}

