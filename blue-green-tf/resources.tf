#cs_lb --Connecting to CSVServer to both LB Servers
resource "citrixadc_csvserver" "canary_csvserver" {
  ipv46       = "172.17.0.5"
  name        = "canary_csvserver"
  port        = 80
  servicetype = "HTTP"

  lbvserverbinding = citrixadc_lbvserver.blueLB.name
}

resource "citrixadc_lbvserver" "blueLB" {
  ipv46       = "1.1.1.1"
  name        = "blueLB"
  port        = 80
  servicetype = "HTTP"
}
resource "citrixadc_lbvserver" "greenLB" {
  ipv46       = "1.1.1.2"
  name        = "greenLB"
  port        = 80
  servicetype = "HTTP"
}

resource "citrixadc_service" "blue_service" {
    lbvserver = citrixadc_lbvserver.blueLB.name
    name = "blue_service"
    ip = "172.16.5.4"
    servicetype  = "HTTP"
    port = 80

}

resource "citrixadc_service" "green_service" {
    lbvserver = citrixadc_lbvserver.greenLB.name
    name = "green_service"
    ip = "10.0.0.4"
    servicetype  = "HTTP"
    port = 80
}


#policy to based on that target lbvserver
resource "citrixadc_cspolicy" "blue_cspolicy" {
  csvserver       = citrixadc_csvserver.canary_csvserver.name
  targetlbvserver = citrixadc_lbvserver.blueLB.name
  policyname      = "blue_policy"
  rule            = "sys.random.mul(100).lt(60)"
  priority        = 100

  # Any change in the following id set will force recreation of the cs policy
  forcenew_id_set = [
    citrixadc_lbvserver.blueLB.id,
    citrixadc_csvserver.canary_csvserver.id,
  ]
}

resource "citrixadc_cspolicy" "green_cspolicy" {
  csvserver       = citrixadc_csvserver.canary_csvserver.name
  targetlbvserver = citrixadc_lbvserver.greenLB.name
  policyname      = "green_policy"
  rule            = "sys.random.mul(100).lt(40)"
  priority        = 101

  # Any change in the following id set will force recreation of the cs policy
  forcenew_id_set = [
    citrixadc_lbvserver.greenLB.id,
    citrixadc_csvserver.canary_csvserver.id,
  ]
}
