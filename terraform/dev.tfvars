aws_region                    = "us-east-1"
project                       = "portal"
environment                   = "dev"
price_class                   = "PriceClass_100"
spa_mode                      = true
log_retention_days            = 30
app_noncurrent_retention_days = 15


tags = {
  Terraform = "true"
  Environment = "DEV"
}
