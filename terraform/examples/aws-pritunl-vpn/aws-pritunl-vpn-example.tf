module "vpn" {
    source = "../../modules/aws-pritunl"

    # count = 0

    environment = "example"
    vpc_id = "vpc-02d8e874d887624c0"
    subnet_id = "subnet-0cb88233e387c955a"
}