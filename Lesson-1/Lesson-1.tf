resource "yandex_compute_instance" "myUbuntu" {
  name        = "test2"
  zone        = "ru-central1-a"
  maintenance_policy = "restart"


  resources {
    cores  = 2
    memory = 1
    core_fraction = 5
  }
  boot_disk {
    initialize_params {
      image_id = "fd8l45jhe4nvt0ih7h2e"
    }
  }

  network_interface {
    subnet_id = "e9berr3calqh9d4rpkcb"
  }

  scheduling_policy {
    preemptible = "true"
  }

}

