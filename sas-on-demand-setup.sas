%* This datastep will clone the GitHub repo;
data _null_;
  rc=GITFN_CLONE("https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson.git",
  "/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
run;

%* This datastep will delete the clone of the GitHub repo;
data _null_;
  rc = GIT_DELETE_REPO("/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
  msg=sysmsg();
  put msg=;
run;
