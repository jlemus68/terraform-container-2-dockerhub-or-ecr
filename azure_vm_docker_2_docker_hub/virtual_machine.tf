# Configure the Azure provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US"
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create a network security group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "http"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ssh"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create a public IP address
resource "azurerm_public_ip" "example" {
  name                = "example-publicip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Dynamic"
}

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.example.id
  }
}

resource "azurerm_linux_virtual_machine" "web_linuxvm" {
  name                = "docker-web-linuxvm"
  #computer_name      = "web-linux-vm" # Hostname of the VM (Optional)
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location 
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [ azurerm_network_interface.example.id ]
  admin_ssh_key {
    username  = "azureuser"
    public_key = file("${path.module}/ssh-keys/terraform-azure.pub")
  }
  os_disk {
    caching             = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }  
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }  
  custom_data = filebase64("${path.module}/app-scripts/build_docker_image.sh")
  # custom_data = base64encode(local.webvm_custom_data)

  timeouts {
    create = "5m"  # Adjust the timeout duration as needed
    # Other timeout options: update, delete
  }
}

# An empty resource block
resource "null_resource" "name" {

  # SSH into the virtual machine instance
  connection {
    type        = "ssh"
    user        = "azureuser"
    private_key = file("./ssh-keys/terraform-azure.pem")  # Path to your SSH private key
    host        = azurerm_linux_virtual_machine.web_linuxvm.public_ip_address
  }

  # Copy the password file for your docker hub account
  # from your computer to the virtual machine instance
  provisioner "file" {
    source      = "./app-scripts/my_password.txt"
    destination = "/home/azureuser/my_password.txt"
  }

  # Copy the Dockerfile from your computer to the virtual machine instance
  provisioner "file" {
    source      = "./app-scripts/Dockerfile"
    destination = "/home/azureuser/Dockerfile"
  }

  # Copy the build_docker_image.sh from your computer to the virtual machine instance
  provisioner "file" {
    source      = "./app-scripts/build_docker_image.sh"
    destination = "/home/azureuser/build_docker_image.sh"
  }

  # Set permissions and run the build_docker_image.sh file
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/azureuser/build_docker_image.sh",
      "sh /home/azureuser/build_docker_image.sh"
    ]
  }

  # Wait for the virtual machine instance to be created
  depends_on = [azurerm_linux_virtual_machine.web_linuxvm]
}

# Print the URL of the container
output "container_url" {
  value = "http://${azurerm_linux_virtual_machine.web_linuxvm.public_ip_address}"
}

