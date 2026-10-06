locals {
  sa_name     = "admin-buckets-account"
  sa_desc     = "Аккаунт для управления бакетами Object Storage"
  sa_key_desc = "Статический ключ для ${local.sa_name}"
  key_name    = "bucket-key"
  key_desc    = "Ключ для шифрования бакетов"
}

resource "yandex_iam_service_account" "buckets-account" {
  name        = local.sa_name
  description = local.sa_desc
}

resource "yandex_resourcemanager_folder_iam_member" "buckets-account-role" {
  folder_id = var.folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.buckets-account.id}"
}

resource "yandex_iam_service_account_static_access_key" "buckets-account-key" {
  service_account_id = "${yandex_iam_service_account.buckets-account.id}"
  description        = local.sa_key_desc
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = local.key_name
  description       = local.key_desc
  default_algorithm = "AES_256"
  rotation_period   = "168h"
}

resource "yandex_storage_bucket" "pictures_bucket" {
  anonymous_access_flags {
    read        = true
    list        = false
    config_read = false
  }
  bucket = "systemerase.site"
  force_destroy = true
  folder_id = var.folder_id
  access_key = "${yandex_iam_service_account_static_access_key.buckets-account-key.access_key}"
  secret_key = "${yandex_iam_service_account_static_access_key.buckets-account-key.secret_key}"
  server_side_encryption_configuration {
    rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = yandex_kms_symmetric_key.key-a.id
      sse_algorithm     = "aws:kms"
    }
  }
  }
  https {
    certificate_id = var.cert_id
  }
  website {
    index_document = "index.html"
  }
}

resource "yandex_storage_object" "download_kitty" {
  bucket = yandex_storage_bucket.pictures_bucket.id
  key = "best_kitty.jpg"
  source = "../img/kitty_from_internet.jpg"
}

resource "yandex_storage_object" "index" {
  bucket = yandex_storage_bucket.pictures_bucket.id
  key = "index.html"
  source = "./index.html"
}