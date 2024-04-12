terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.115.0"
    }
  }
}

locals {
  # Идентификатор папки https://console.yandex.cloud/folders/b1g8kbqq92bvsk3h7i1u?section=service-accounts
  folder_id = "b1g8kbqq92bvsk3h7i1u"
  # Идентификатор аккаунта https://console.yandex.cloud/folders/b1g8kbqq92bvsk3h7i1u/service-account/ajegt9po5pbfon86qc6e
  cloud_id = "ajegt9po5pbfon86qc6e"
}

provider "yandex" {
  //token                    = "auth_token_here"
  # Путь до авторизованного ключа
  service_account_key_file = "/home/ilya/.secrets/authorized_key.json"
  cloud_id                 = local.cloud_id
  folder_id                = local.folder_id
  //zone                     = "ru-central1-a"
}

