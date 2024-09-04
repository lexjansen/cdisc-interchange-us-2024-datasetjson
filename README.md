# CDISC Interchange US 2024

## Dataset-JSON v1.1 Hands-On Implementation Training

SAS materials for the Dataset-JSON v1.1 Hands-On Implementation Training.
October 21, 2024 (9:00 AM-1:00 PM).

- [Learner preparation - SAS](doc/prepare-sas.md)
- [GitHub repository](https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson) for the SAS part of training.

Use the following code to clone the GitHub repository to your SAS® OnDemand environment:

```SAS
data _null_;
  rc=GITFN_CLONE("https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson.git",
  "/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
run;
```

Use the following code to delete the folder that you cloned from GitHub from your SAS® OnDemand environment:

```SAS
data _null_;
  rc = GIT_DELETE_REPO("/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
  msg=sysmsg();
  put msg=;
run;
```
