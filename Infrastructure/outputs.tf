# output "vpc_subnet" {
#   description = "The output for all networking resources"
#   value = var.vpc_subnet != null ? {
#     for name, item in module.vpc_subnet :
#     name => {
#         vpcId = item.vpc_Id
#         Public_SubnetsId = item.Public_subnet_ids
#         Private_SubnetId = item.Private_subnet_ids
#         NatgatwayId = item.natgateway_id
#         InternetGatewayId = item.internetgw_id
#     }
#   } : null
# }

output "vpcId" {
  description = "The Id of the vpc to be outputed"
  value = module.vpc_subnet.vpc_Id
}