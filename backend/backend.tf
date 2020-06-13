provider "google" {
  credentials = "${file("account.json")}"
  project     = "badamscka"
  region      = "us-central1"
  zone        = "us-central1-a"
}
