# provider region----------------------------------------------
variable "provider_region" {
    type = string
    default = ""
    description = "This is the region for provider"
}
variable "env" {
    type = string
    default = ""
}
variable "org" {
    type = string
    default = ""
}
variable "lob" {
    type = string
    default = "value"
}


# vpc cidr_block--------------------------------------------
variable "vpc_cidr_block" {
    type = string
    default = ""
    description = "This cidr for the vpc"
}

# pub-sub-configuration---------------------------------------
variable "cidr_block_01" {
    type = string
    default = ""
}
  
variable "cidr_block_02" {
    type = string
    default = ""
}

variable "sub_azs_1a" {
    type = string
    default = ""
}

variable "sub_azs_1b" {
    type =string
    default = ""
}
variable "pub_ip_true" {
    type = bool
    default = true
}
   
#target-group-------------------------------------

 variable "tg_type" {
    type = string
    default = ""
 }  

# alb------------------------------------------------

variable "alb_type" {
    type = string
    default = ""
}

#launch_template
variable "key_pair_lt" {
    type = string
    default = ""
  
}

#task_definination
variable "task_def_network_mode" {
    type = string
    default = ""
  
}