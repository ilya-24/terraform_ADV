resource "yandex_compute_instance" "myUbuntu" {
  count              = 2
  zone               = "ru-central1-a"
  maintenance_policy = "restart"

  metadata = {
    name     = "Ubuntu"
    foo      = "bar"
    ssh-keys = file("~/.ssh/id_rsa.pub")
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
    subnet_id = "e9berr3calqh9d4rpkcb"
  }

  scheduling_policy {
    # Сделать ВМ прерываемой(дешевле)
    preemptible = "true"
  }

}

