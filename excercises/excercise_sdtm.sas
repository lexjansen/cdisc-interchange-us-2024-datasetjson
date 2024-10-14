%let project_folder=/home/&SYSUSERID/cdisc-int2024-dataset-json-sas;
%include "&project_folder/programs/config.sas";

/* Choose a dataset */
%let dataset=ae;


/* Convert SDTM v5 XPT files to SAS datasets */
%cstutilxptread(
  _cstSourceFolder=&project_folder/data/sdtm_xpt,
  _cstOutputLibrary=datasdtm,
  _cstExtension=XPT,
  _cstOptions=datecopy
  );

/* Create metadata from SDTM Define-XML */
%create_metadata_from_definexml(
   definexml=&project_folder/data/sdtm_xpt/define.xml,
   metadatalib=metasdtm
   );


/* Map Define-XML datatypes to JSON datatypes */
/* this is a very rough mapping, it does not take decimal into account */
proc format;
  value $datatyp
    text = "string"
    date = "date"
    datetime = "datetime"
    time = "time"
    URI = "string"
    partialDate = "string"
    partialTime = "string"
    partialDatetime = "string"
    durationDatetime = "string"
    intervalDatetime = "string"
    incompleteDatetime = "string"
    incompleteDate = "string"
    incompleteTime = "string"
    integer = "integer"
    float = "float"
    ;
run;

/* Some manual SDTM data type updates */
data metasdtm.metadata_columns;
  set metasdtm.metadata_columns;

  dataType = put(xml_datatype, $datatyp.);
  if dataType = "string" then json_length = length;

run;



/* Create Dataset-JSON from the dataset */
%let _fileOID = %str(www.cdisc.org/StudyMSGv2/1/Define-XML_2.1.0)/%sysfunc(date(), is8601da.)/&dataset;
%let _studyOID = %str(Tcdisc.com/CDISCPILOT01);
%let _metaDataVersionOID = %str(MDV.MSGv2.0.SDTMIG.3.3.SDTM.1.7);
%let _originator = %str(CDISC SDTM MSG Team);

%write_datasetjson(
    dataset=datasdtm.&dataset,
    jsonpath=&project_folder/json_out/sdtm/&dataset..json,
    usemetadata=Y,
    metadatalib=metasdtm,
    fileOID=&_fileOID,
    originator=&_originator,
    sourceSystem=,
    sourceSystemVersion=,
    studyOID=&_studyOID,
    metaDataVersionOID=&_metaDataVersionOID,
    metaDataRef=define.xml,
    %* In a submission, you would typicaly use pretty=NOPRETTY ;
    pretty=PRETTY
    );


/* Create SAS dataset from Dataset-JSON */
%read_datasetjson(
    jsonpath=&project_folder/json_out/sdtm/&dataset..json,
    datalib=outsdtm,
    dropseqvar=Y,
    savemetadata=Y,
    metadatalib=metasvad
    );

/* Compare original and created dataset */
proc compare base=datasdtm.&dataset compare=outsdtm.&dataset criterion=0.000000000001 method=absolute listall;
run;
