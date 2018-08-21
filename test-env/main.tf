resource "azurerm_resource_group" "dwitkowski-test" {
    name        = "dwitkowski-test-rg"
    location    = "North Europe"

    tags {
        environment = "dwitkowski-test-env"
    }
}