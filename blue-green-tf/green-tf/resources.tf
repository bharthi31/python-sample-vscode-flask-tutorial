#cs_lb --Connecting to CSVServer to both LB Servers
resource "citrixadc_csvserver" "demo_csvserver" {
  ipv46       = "172.17.0.5"
  name        = "demo_csvserver"
  port        = 80
  servicetype = "HTTP"

  lbvserverbinding = citrixadc_lbvserver.greenLB.name
}

resource "citrixadc_lbvserver" "greenLB" {
  ipv46       = "1.1.1.2"
  name        = "greenLB"
  port        = 80
  servicetype = "HTTP"
}

resource "citrixadc_service" "green_service" {
    lbvserver = citrixadc_lbvserver.greenLB.name
    name = "green_service"
    ip = var.backend_service
    servicetype  = "HTTP"
    port = 80
}

resource "citrixadc_cspolicy" "green_cspolicy" {
  csvserver       = citrixadc_csvserver.demo_csvserver.name
  targetlbvserver = citrixadc_lbvserver.greenLB.name
  policyname      = "green_policy"
  rule            = "sys.random.mul(100).lt(var.traffic_split_percentage)"
  priority        = 101

  # Any change in the following id set will force recreation of the cs policy
  forcenew_id_set = [
    citrixadc_lbvserver.greenLB.id,
    citrixadc_csvserver.demo_csvserver.id,
  ]
}
