variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
# variable "customer_compartment_ocid" {}
variable "compartment_ocid" {}
variable "region" {}
variable "ssh_public_key" {}
variable "ssh_private_key" {}
variable "image_name" {
  type    = "string"
  default = "StBernard"
}

provider "oci" {
    tenancy_ocid         = "${var.tenancy_ocid}"
    user_ocid            = "${var.user_ocid}"
    fingerprint          = "${var.fingerprint}"
    private_key_path     = "${var.private_key_path}"
    region               = "${var.region}"
    disable_auto_retries = "true" 
}
variable "InstanceImageOCID" {
  type = "map"
  default = {
    // See https://docs.us-phoenix-1.oraclecloud.com/images/
    // Oracle-provided image "Oracle-Linux-7.4-2018.02.21-1"
    us-phoenix-1 = "ocid1.image.oc1.phx.aaaaaaaaupbfz5f5hdvejulmalhyb6goieolullgkpumorbvxlwkaowglslq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaajlw3xfie2t5t52uegyhiq2npx7bqyu4uvi2zyu3w3mqayc2bxmaa"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa7d3fsb6272srnftyi4dphdgfjf6gurxqhmv6ileds7ba3m2gltxq"
    uk-london-1    = "ocid1.image.oc1.uk-london-1.aaaaaaaaa6h6gj6v4n56mqrbgnosskq63blyv2752g36zerymy63cfkojiiq"
  }
}
data "oci_identity_availability_domains" "ADs" { compartment_id = "${var.tenancy_ocid}" }
data "oci_objectstorage_namespace" "ns" {}
resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = "${var.compartment_ocid}"
  namespace      = "${data.oci_objectstorage_namespace.ns.namespace}"
  name           = "DogBucket"
#   access_type    = "NoPublicAccess"
}
resource "null_resource" "upload_img" {
  provisioner "local-exec" {
    command = "echo y | oci os object put -ns <TENANCY> -bn DogBucket --name StBernard --file StBernard | sleep 5"
  }
}

#resource "oci_objectstorage_object" "image_obj" {
# namespace        = "${data.oci_objectstorage_namespace.ns.namespace}"
# bucket           = "${oci_objectstorage_bucket.bucket.name}"
# object           = "${var.image_name}"
# source          = "${var.image_name}"
#}


resource "oci_core_image" "image" {
    #Required
    compartment_id = "${var.compartment_ocid}"
    #Optional
    # display_name = "${var.image_display_name}"
    # launch_mode = "${var.image_launch_mode}"
    
    image_source_details {
        source_type = "objectStorageTuple"
        bucket_name = "${oci_objectstorage_bucket.bucket.name}"
        namespace_name = "${data.oci_objectstorage_namespace.ns.namespace}"
        object_name = "${var.image_name}" # exported image name
        
        #Optional
        # source_image_type = "${var.source_image_type}"
    }
}
# create vcn
resource "oci_core_virtual_network" "vcn_of_puppies" {
  cidr_block     = "10.0.0.0/16"
  dns_label      = "vcnofpuppies"
  compartment_id = "${var.compartment_ocid}"
  display_name   = "vcn_of_puppies"
}
resource "oci_core_internet_gateway" "internetdoggateway" {
  compartment_id = "${var.compartment_ocid}"
  display_name   = "internetdoggateway"
  vcn_id         = "${oci_core_virtual_network.vcn_of_puppies.id}"
}
resource "oci_core_route_table" "routedogs" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn_of_puppies.id}"
  display_name   = "routedogs"
  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = "${oci_core_internet_gateway.internetdoggateway.id}"
  }
}
resource "oci_core_security_list" "securitydog" {
  display_name   = "securitydog"
  compartment_id = "${var.compartment_ocid}"
  vcn_id         = "${oci_core_virtual_network.vcn_of_puppies.id}"
  egress_security_rules = [{
    protocol    = "all"
    destination = "0.0.0.0/0"
  }]
  ingress_security_rules = [
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        "min" = 80
        "max" = 80
      }
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        "min" = 443
        "max" = 443
      }
    },
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        "min" = 5100
        "max" = 5100
      }
    },    
    {
      protocol = "6"
      source   = "0.0.0.0/0"
      tcp_options {
        "min" = 22
        "max" = 22
      }
    },
  ]
}
# create subnet
resource "oci_core_subnet" "subnet_dog" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  cidr_block          = "10.0.1.0/24"
  display_name        = "subnet_dog"
  dns_label           = "subnetdog"
  compartment_id      = "${var.compartment_ocid}"
  vcn_id              = "${oci_core_virtual_network.vcn_of_puppies.id}"
  security_list_ids   = [
    "${oci_core_virtual_network.vcn_of_puppies.default_security_list_id}",
    "${oci_core_security_list.securitydog.id}",
  ]
  route_table_id      = "${oci_core_route_table.routedogs.id}"
  dhcp_options_id     = "${oci_core_virtual_network.vcn_of_puppies.default_dhcp_options_id}"
}
resource "oci_core_instance" "server_goldenretriever" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[2],"name")}"
  compartment_id      = "${var.compartment_ocid}"
  display_name        = "server_goldenretriever"
  shape               = "VM.Standard1.1"
  create_vnic_details {
    subnet_id        = "${oci_core_subnet.subnet_dog.id}"
    display_name     = "primaryvnicpup"
    assign_public_ip = true
    hostname_label   = "webserverdoggo"
  }
  source_details {
    source_type = "image"
    source_id = "${oci_core_image.image.id}"
    # source_id   = "ocid1.image.oc1.iad.aaaaaaaapvqeod2xejrc6vnzifdia7ck33zk35oa76ju2t6gfbinsnqvrqrq"
    #boot_volume_size_in_gbs = "60"
  }
  metadata {
    ssh_authorized_keys = "${var.ssh_public_key}"
    # user_data           = "${base64encode(file(var.BootStrapFile))}"
  }
}
