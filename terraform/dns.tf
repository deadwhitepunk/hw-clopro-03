resource "yandex_dns_zone" "zone" {
  description = "zone for homework"
  folder_id   = var.folder_id
  name        = "zone"
  public      = true
  zone        = "systemerase.site."
}

resource "yandex_dns_recordset" "redirect_bucket" {
  zone_id = yandex_dns_zone.zone.id
  name    = "@"
  type    = "ANAME"
  ttl     = 600

  data = [
    "systemerase.site.website.yandexcloud.net"
  ]
}
