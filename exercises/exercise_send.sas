%let project_folder=/home/&SYSUSERID/cdisc-int2024-dataset-json-sas;
%include "&project_folder/programs/config.sas";

/* Choose a dataset */
%let dataset=bg;


/* Convert SEND v5 XPT files to SAS datasets */
%cstutilxptread(
  _cstSourceFolder=&project_folder/data/send_xpt,
  _cstOutputLibrary=datasend,
  _cstExtension=XPT,
  _cstOptions=datecopy
  );

/* Create metadata from SEND Define-XML */
%create_metadata_from_definexml(
   definexml=&project_folder/data/send_xpt/define.xml,
   metadatalib=metasend
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

/* Some manual SEND data type updates */
data metasend.metadata_columns;
  set metasend.metadata_columns;

  dataType = put(xml_datatype, $datatyp.);
  if dataType = "string" then json_length = length;

run;



/* Create Dataset-JSON from the dataset */
%let _fileOID = %str(Covance Laboratories/Study8326556-Define2-XML_2.0.0)/%sysfunc(date(), is8601da.)/&dataset;
%let _studyOID = %str(8326556);
%let _metaDataVersionOID = %str(CDISC-SEND.3.1);
%let _originator = %str(CDISC SEND Team);

%write_datasetjson(
    dataset=datasend.&dataset,
    jsonpath=&project_folder/json_out/send/&dataset..json,
    usemetadata=Y,
    metadatalib=metasend,
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
    jsonpath=&project_folder/json_out/send/&dataset..json,
    datalib=outsend,
    savemetadata=Y,
    metadatalib=metasvad
    );

/* Compare original and created dataset */
ods listing close;
ods html5 path="&project_folder/exercises" file="compare_data_send.html";

  proc compare base=datasend.&dataset compare=outsend.&dataset criterion=0.000000000001 method=absolute listall;
    title01 "PROC COMPARE results - user &SYSUSERID";
  run;

ods html5 close;
ods listing;
run;
