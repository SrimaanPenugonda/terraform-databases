bucket           = "srimaan-terraform-state-files" //existing bucket name to store state files
key              = "databases/prod/terraform.tfstate" //path in bucket
region           = "us-east-1"
dynamodb_table   = "terraform"  //dynamodb table name

//these all r arguments passing to state.tf - which will execute at init step dev.init