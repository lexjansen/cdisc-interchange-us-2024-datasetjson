# CDISC Interchange US 2024

## Dataset-JSON v1.1 Hands-On Implementation Training

This repository contains SAS materials for the Dataset-JSON v1.1 Hands-On Implementation Training (October 21, 2024, 9:00 AM-1:00 PM).
The repository has a SAS implementation for converting Dataset-JSON files to and from SAS datasets following the [CDISC Dataset-JSON v1.1 specification](https://wiki.cdisc.org/display/DSJSON1DOT1/Dataset-JSON+1.1).

This repository is adapted from the [https://github.com/lexjansen/dataset-json-sas](https://github.com/lexjansen/dataset-json-sas) GitHub repository.

### Resources

- [Learner preparation - SAS](doc/prepare-sas.md)
- [https://jsonformatter.org](https://jsonformatter.org)

### SAS® OnDemand

Go to SAS® On-Demand account by signing in with your SAS profile at: <https://welcome.oda.sas.com/>

#### Clone the GitHub Repository

Use the following code to clone the GitHub repository to your SAS® OnDemand environment:

```SAS
data _null_;
  rc=GITFN_CLONE("https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson.git",
  "/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
run;
```

#### Delete the clone of the GitHub Repository

Use the following code to delete the folder that you cloned from GitHub from your SAS® OnDemand environment:

```SAS
data _null_;
  rc = GIT_DELETE_REPO("/home/&SYSUSERID/cdisc-int2024-dataset-json-sas");
  put rc=;
  msg=sysmsg();
  put msg=;
run;
```

### Example Data

- ADaM: ADaM Metadata Submission Guidelines v1.0, 18 April 18 2023
- SDTM: SDTM Metadata Submission Guidelines v2.0, published 30 March 2021
- SEND: CBER Pilot (with updated stylesheet)

### Issues

When encountering issues, please open an issue at [https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson](https://github.com/lexjansen/cdisc-interchange-us-2024-datasetjson).

### License

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
This project is using the [MIT](http://www.opensource.org/licenses/MIT "The MIT License | Open Source Initiative") license (see [`LICENSE`](LICENSE)).

The macros cstutilcheckvarsexist.sas, cstutilgetattribute.sas, cstutilnobs.sas, cstutilxptread.sas, cstutilxptwrite.sas are licensed under the [`Apache 2.0 License`](Apache-2.0-LICENSE).
