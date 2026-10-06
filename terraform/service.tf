data "yandex_iam_service_account" "ig_sa" {
  service_account_id = "aje40r3dvft7cadhtnn4"
}

resource "yandex_kms_symmetric_key_iam_member" "key-access" {
  symmetric_key_id = yandex_kms_symmetric_key.key-a.id
  role             = "kms.keys.encrypterDecrypter"
  member           = "serviceAccount:${yandex_iam_service_account.buckets-account.id}"
}