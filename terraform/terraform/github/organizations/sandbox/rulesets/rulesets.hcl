locals {
    rule_name = split("/", path_relative_to_include())[2]
}
