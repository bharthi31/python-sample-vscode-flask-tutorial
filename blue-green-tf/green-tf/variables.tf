variable "backend_service" {
  description = "The backend service IP"
  type        = string
}
variable "traffic_split_percentage" {
  description = "Percentage of Traffic to be split"
  type        = number
}
