locals {
    name = split("/", path_relative_to_include())[0]
}
