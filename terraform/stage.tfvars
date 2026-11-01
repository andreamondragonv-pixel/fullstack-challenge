aws_region                    = "us-east-1"
project                       = "challenge"
environment                   = "stg"
price_class                   = "PriceClass_100"
spa_mode                      = true
log_retention_days            = 90
app_noncurrent_retention_days = 30


tags = {
  Terraform   = "true"
  Environment = "STG"
}
