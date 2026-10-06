terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
      version = ">= 0.129.0"
    }
  }
}

provider "yandex" {
  zone                     = "ru-central1-a"
  folder_id                = var.folder_id
}