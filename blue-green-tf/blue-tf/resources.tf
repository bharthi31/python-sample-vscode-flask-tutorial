#cs_lb --Connecting to CSVServer to both LB Servers
resource "citrixadc_csvserver" "demo_csvserver" {
  ipv46       = "172.17.0.5"
  name        = "demo_csvserver"
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

resource "citrixadc_service" "blue_service" {
    lbvserver = citrixadc_lbvserver.blueLB.name
    name = "blue_service"
    ip = var.backend_service
    servicetype  = "HTTP"
    port = 80

}

resource "citrixadc_csaction" "blue_csaction" {
  name            = "blue_csaction"
  targetlbvserver = citrixadc_lbvserver.blueLB.name
}

#policy to based on that target lbvserver
resource "citrixadc_cspolicy" "blue_cspolicy" {
  csvserver       = citrixadc_csvserver.demo_csvserver.name
  targetlbvserver = citrixadc_lbvserver.blueLB.name
  policyname      = "blue_policy"
  action          = citrixadc_csaction.blue_csaction.name
  rule            = "HTTP.REQ.HOSTNAME.SERVER.EQ(\"demo-bg.webapp.com\") && HTTP.REQ.URL.PATH.SET_TEXT_MODE(IGNORECASE).STARTSWITH(\"/\")"
  priority        = 100

  # Any change in the following id set will force recreation of the cs policy
  forcenew_id_set = [
    citrixadc_lbvserver.blueLB.id,
    citrixadc_csvserver.demo_csvserver.id,
  ]
}
