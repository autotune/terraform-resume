provider "google" {
  credentials = "${file("../creds.json")}"
  project     = "badamscka"
  region      = "us-central1"
  zone        = "us-central1-a"
}
