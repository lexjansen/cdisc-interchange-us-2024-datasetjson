%*let project_folder=/home/&SYSUSERID/cdisc-int2024-dataset-json-sas; 
%let project_folder=/_github/lexjansen/cdisc-interchange-us-2024-datasetjson;
%include "&project_folder/programs/config.sas";

/* Convert ADaM v5 XPT files to SAS datasets */
%cstutilxptread(
  _cstSourceFolder=&project_folder/data/adam_xpt,
  _cstOutputLibrary=dataadam,
  _cstExtension=XPT,
  _cstOptions=datecopy
  );
/*
proc contents data=dataadam._ALL_ varnum;
run;
*/

/* Create metadata from ADaM Define-XML */
%create_metadata_from_definexml(
   definexml=&project_folder/data/adam_xpt/define.xml, 
   metadatalib=metaadam
   );


proc format;
  /* this is a very rough mapping, it does not take decimal into account */
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

/* Some manual ADaM data type updates */
data metaadam.metadata_columns;
  set metaadam.metadata_columns;

  dataType = put(xml_datatype, $datatyp.);
  if dataType = "string" then json_length = length;

  /* Define-XML v2 does not support decimal, but it is supported by Dataset-JSON. */
  /* This update is just to show that it works in Dataset-JSON. */
  
  if dataset_name in ('ADLBC', 'ADLBH') and 
     name in ('PCHG', 'AVAL', 'BASE', 'CHG', 'PCHG', 'A1LO', 'A1HI', 'R2A1LO', 'R2A1HI', 'BR2A1LO', 'BR2A1HI', 'ALBTRVAL', 'LBSTRESN')
     then do;
      dataType='decimal';
      targetDataType='decimal';
    end;
  
  if not missing(displayformat) then do;
    if substr(strip(reverse(upcase(name))), 1, 2) = "TD" then do;
      dataType = "date";
      targetDataType = "integer";
    end;
    if substr(strip(reverse(upcase(name))), 1, 3) = "MTD" then do;
      dataType = "datetime";
      targetDataType = "integer";
    end;
    if substr(strip(reverse(upcase(name))), 1, 2) = "MT" then do;
      dataType = "time";
      targetDataType = "integer";
    end;
  end;

run;



/* Create Dataset-JSON for ADaM */
%let _fileOID=%str(www.cdisc.org/StudyMSGv1/1/Define-XML_2.1.0);
%let _studyOID=%str(TDF_ADaM.ADaMIG.1.1);
%let _metaDataVersionOID=%str(MDV.TDF_ADaM.ADaMIG.1.1);


%write_datasetjson(
    dataset=dataadam.adsl,
    jsonpath=&project_folder/json_out/adam/adsl.json,
    usemetadata=N,
    metadatalib=metaadam,
    fileOID=&_fileOID/%sysfunc(date(), is8601da.)/adsl, 
    originator=CDISC ADaM MSG Team,
    sourceSystem=,
    sourceSystemVersion=,
    studyOID=&_studyOID,
    metaDataVersionOID=&_metaDataVersionOID,
    metaDataRef=define.xml
    );
    

%read_datasetjson(
    jsonpath=&project_folder/json_out/adam/adsl.json,
    datalib=outadam,
    dropseqvar=Y,
    savemetadata=Y,
    metadatalib=metasvad
    );
    
proc compare base=dataadam.adsl compare=outadam.adsl criterion=0.000000000001 method=absolute listall;
run; 

