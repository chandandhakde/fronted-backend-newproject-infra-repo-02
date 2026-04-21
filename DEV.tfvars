provider_region = "ap-south-1"
#vpc-----------------------------------------------------------
vpc_cidr_block = "10.0.0.0/16"
org = "coltech"
lob = "lms"
env = "dev"

#pub_sub-----------------------------------------------------------
cidr_block_01 = "10.0.1.0/24"
cidr_block_02 = "10.0.2.0/24"
sub_azs_1a = "ap-south-1a"
sub_azs_1b = "ap-south-1b"
pub_ip_true = true

#target_group--------------------------------------------------------
tg_type = "ip" #changes from "instance"

#alb------------------------------------------------------------------
alb_type = "application"

#lt
key_pair_lt = "jenkins-keypair-pem"

#ecs---------------------------------------------------------------------
 task_def_network_mode = "awsvpc" #change from bridge
