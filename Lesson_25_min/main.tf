# https://www.youtube.com/watch?v=y1eqR0xL1ZI&t=5s&ab_channel=loftblog

locals {
  bucket_name = "tf-test-bucket-from-ilya"
  index       = "index.html"
}

// Create SA
resource "yandex_iam_service_account" "sa" {
  folder_id = local.folder_id
  name      = "tf-test-sa"
}

// Grant permissions
resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = local.folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

// Use keys to create bucket
resource "yandex_storage_bucket" "test" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = local.bucket_name
  acl        = "public-read"
  website {
    index_document = local.index
  }
}

resource "yandex_storage_object" "index" {
  access_key     = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key     = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket         = yandex_storage_bucket.test.id
  acl            = "public-read"
  key = local.index
  #   source         = "site/${local.index}"
  content_base64 = base64encode(file("site/${local.index}"))
  content_type   = "text/html"
  tags = {
    test = "value"
  }
}

resource "yandex_storage_object" "styles" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = yandex_storage_bucket.test.id
  acl        = "public-read"
  key        = each.key
  source     = "site/${each.key}"
  for_each   = fileset("site", "styles*")
  tags = {
    test = "value"
  }
}

output site_name {
  value = yandex_storage_bucket.test.website_endpoint
}