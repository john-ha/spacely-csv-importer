provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "spacely_csv_importer_bucket" {
  bucket = "spacely-csv-importer"
  tags = {
    Name = "spacely-csv-importer"
  }
}
