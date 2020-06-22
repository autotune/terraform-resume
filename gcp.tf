terraform {
  backend "gcs" {
    bucket      = "badamsresume"
    prefix      = "dev"
    credentials = "serviceaccount.json"
  }
}
