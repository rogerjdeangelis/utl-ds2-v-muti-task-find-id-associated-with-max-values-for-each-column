DS2 vs multi_task find ids associated with max values for several variables

github
https://tinyurl.com/v5g6lxf
https://github.com/rogerjdeangelis/utl-ds2-v-muti-task-find-id-associated-with-max-values-for-each-column

Given precious stones of varing cut, clarity and carats identify the imbeded serial number and the
maximum currrent market value for each stone.

     Two Solutions ( Not sure the difference is significant)

        Seconds
          32    a. multi-task 'proc means (I am in lockdown in San Francisco and do not access to my beast(32 cores 128gb NVMe) in DC.
                   This should scale with mare cores except for ultrathin laptops due to themal throttling (compute bound?)
          50    b. proc ds2  (fastest HASH, DS2 hash is multithreaded - good for limited core laptops and desktops?
                   Simpler and best for smaller datasets)
                   Richard DeVenezia <rdevenezia@GMAIL.COM>

      I only ran four parallell tasks because of my vintage laptop E6420 I7.

SOAPBOX ON

  Perhaps muti-tasking with base SAS is an alternative for many of the esoteric SAS products
  like DS2, LUA, FCMP, HP procs, GRID(really is a different language?)...

  I think we should be using muti-tasking more because of inexpensive muti-core CPUS.

  I believe AMD is up to 64 threads(instuction streames/cores) in there latest CPSs.

  You chose where you want to spend your time.

  It may even be advantageous to restrict separate parallel tasks to a a single tread?.

  I know that the hash is muti-threaded in DS2 and not in base sas but i suspect patitioned data and muti-tasking
  in base SAS will always be faster then 'proc ds2' on modern no eltrathin laptops.

  Less is more, stop fracturing SAS with enterprise this, studio that, FCMP, Ds2..
  Just move the functionality into base SAS and SAS stat.

  Fix bugs and problems with in base SAS especially ods output, dosubl(share storage) and classic editor(ie tf command text flow).

SOAPBOX ON

Note
====
  Vintage E6420 I7s supports(16gb ram ddr3) four esata SSD drives,c drive, one in cdrom  tray,
  one in laptop esata port and one in docking station plus
  multiple USB3 ports on 'blue' docking station?

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

libname sd1 "d:/sd1";
libname se1 "e:/sd1";

data  /* spde might be better */
  sd1.have
  sd1.garnet (keep=embeded_serial garnet  )
  se1.jade   (keep=embeded_serial jade    )
  sd1.opal   (keep=embeded_serial opal    )
  se1.pearl  (keep=embeded_serial pearl   )
;
  call streaminit(123);
  format garnet jade opal pearl dollar20.;
  do  embeded_serial=2031394253 to 8031394255 by 21;
    array v garnet jade opal pearl;
    do over v; v=ceil(rand('uniform', 2e9)); end;
    output;
  end;
run;run;


proc print data=sd1.have (obs=5) width=min;
format garnet jade opal pearl dollar23.;
var embeded_serial garnet jade opal pearl;
run;quit;


SD1.HAVE total obs=285,714,286

   EMBEDED_
    SERIAL          GARNET             JADE              OPAL             PEARL

  2031394253      $836,599,846    $1,928,756,680    $1,843,638,759    $1,224,309,018
  2031394274    $1,341,658,152    $1,276,810,283    $1,324,810,784    $1,661,598,237
  2031394295    $1,886,597,920    $1,840,338,967      $153,252,941    $1,548,298,279
  2031394316    $1,048,578,739       $46,399,842      $498,025,784      $307,584,118
  2031394337    $1,320,745,492      $378,953,883    $1,963,990,602    $1,126,623,673
  ....

*           _
 _ __ _   _| | ___  ___
| '__| | | | |/ _ \/ __|
| |  | |_| | |  __/\__ \
|_|   \__,_|_|\___||___/

;

Lest see if we can find the embeeded serial number and market value for the most expensive garnet

SD1.out_garnet total obs=1


            EMBEDED_
STONE       SERIAL       MAX_MARKET_VALUE

 Garnet    2268517454    $1,999,999,964


LETS CHECK
==========

 EMBEDED_
  SERIAL         GARNET

....
2268517412     $945,717,567
2268517433   $1,574,447,089

2268517454   $1,999,999,964  <== Engraved Serial Number and associated market value

2268517475      $53,309,260
2268517496     $339,786,382
....

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;

WORK.WANT_4CORE total obs=4

                ENGRAVED_
  PRECIOUS_      SERIAL_       MAX_MARKET_
    STONE        NUMBER          VALUE

   GARNET      2268517454    $1,999,999,964
   JADE        5653575788    $1,999,999,998
   OPAL        5079247733    $1,999,999,996
   PEARL       2830118438    $1,999,999,984

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __  ___
/ __|/ _ \| | | | | __| |/ _ \| '_ \/ __|
\__ \ (_) | | |_| | |_| | (_) | | | \__ \
|___/\___/|_|\__,_|\__|_|\___/|_| |_|___/
                           _ _   _       _            _    _
  __ _     _ __ ___  _   _| | |_(_)     | |_ __ _ ___| | _(_)_ __   __ _
 / _` |   | '_ ` _ \| | | | | __| |_____| __/ _` / __| |/ / | '_ \ / _` |
| (_| |_  | | | | | | |_| | | |_| |_____| || (_| \__ \   <| | | | | (_| |
 \__,_(_) |_| |_| |_|\__,_|_|\__|_|      \__\__,_|___/_|\_\_|_| |_|\__, |
                                                                   |___/
;

* save macro in autocall library;
filename ft15f001 "c:/oto/utl_hxx.sas";
parmcards4;
%macro utl_hxx(d,col);

    /* %let col=ruby; */

    libname s&d.1 "&d.:/sd1";
    libname sot     "d:/sd1";

    proc means data=s&d.1.&col. noprint max nway missing;
       var &col.;
       output out=sot.out_&col.(rename=&col.=max_market_value drop=_:) maxid(&col.(embeded_serial)) = engraved_serial_number max=;
    run;quit;

%mend utl_hxx;
;;;;
run;quit;

* test one interactively.
%inc "c:/oto/utl_hxx.sas";;
%utl_hxx(c,ruby);

%let _s=%qsysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk
        -rsasuser -nosplash -sasautos &_r\oto -config &_r\cfg\cfgsas.cfg));

systask kill sys1 sys2 sys3 sys4 sys5 sys6 sys7 sys8;
%let beg=%sysfunc(time());
systask command "&_s -termstmt %nrstr(%utl_hxx(d,garnet);) -log d:\log\a2.log" taskname=sys2;
systask command "&_s -termstmt %nrstr(%utl_hxx(e,jade);) -log d:\log\a3.log" taskname=sys3;
systask command "&_s -termstmt %nrstr(%utl_hxx(d,opal);) -log d:\log\a5.log" taskname=sys5;
systask command "&_s -termstmt %nrstr(%utl_hxx(e,pearl);) -log d:\log\a6.log" taskname=sys6;

waitfor sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;

%let elap=%sysevalf(%sysfunc(time())-&beg) ;

%put &=elap;


libname sd1 "d:/sd1";

data want_4core /view=want_4core;
    retain precious_stone;
    format max_market_value  dollar23.;
    set
        sd1.out_garnet
        sd1.out_jade
        sd1.out_opal
        sd1.out_pearl
     indsname=fro;
     precious_stone=scan(fro,2,'_');
run;quit;

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;


640   %let _s=%qsysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk
641           -rsasuser -nosplash -sasautos &_r\oto -config &_r\cfg\cfgsas.cfg));
NOTE: There are no active tasks/transactions.
642   systask kill sys1 sys2 sys3 sys4 sys5 sys6 sys7 sys8;
643   %let beg=%sysfunc(time());
644   systask command "&_s -termstmt %nrstr(%utl_hxx(d,garnet);) -log d:\log\a2.log" taskname=sys2;
645   systask command "&_s -termstmt %nrstr(%utl_hxx(e,jade);) -log d:\log\a3.log" taskname=sys3;
646   systask command "&_s -termstmt %nrstr(%utl_hxx(d,opal);) -log d:\log\a5.log" taskname=sys5;
647   systask command "&_s -termstmt %nrstr(%utl_hxx(e,pearl);) -log d:\log\a6.log" taskname=sys6;
NOTE: The task "sys1" is not an active task.
NOTE: The task "sys4" is not an active task.
NOTE: The task "sys7" is not an active task.
NOTE: The task "sys8" is not an active task.
648   waitfor sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;
NOTE: Task "sys2" produced no LOG/Output.
649   %let elap=%sysevalf(%sysfunc(time())-&beg) ;
650   %put &=elap;

**********************;
ELAP=32.4519999026961
**********************;

NOTE: Task "sys2" produced no LOG/Output.
NOTE: Task "sys5" produced no LOG/Output.
NOTE: Task "sys6" produced no LOG/Output.
NOTE: Task "sys3" produced no LOG/Output.

A1.LOG

X64_7PRO WIN 6.1.7601 Service Pack 1 Workstation

NOTE: SAS initialization used:
      real time           0.17 seconds
      cpu time            0.17 seconds

NOTE: Libref SD1 was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\sd1
NOTE: Libref SOT refers to the same physical library as SD1.
NOTE: Libref SOT was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\sd1

NOTE: There were 285714286 observations read from the data set SD1.GARNET.
NOTE: The data set SOT.OUT_GARNET has 1 observations and 2 variables.
NOTE: PROCEDURE MEANS used (Total process time):
      real time           31.41 seconds
      cpu time            50.60 seconds



NOTE: SAS Institute Inc., SAS Campus Drive, Cary, NC USA 27513-2414
NOTE: The SAS System used:
      real time           31.61 seconds
      cpu time            50.79 seconds

*    _     ____
  __| |___|___ \
 / _` / __| __) |
| (_| \__ \/ __/
 \__,_|___/_____|

;

filename ft15f001 "c:/oto/utl_xds2.sas";
parmcards4;
%macro utl_xds2;
libname sd1 "d:/sd1";
proc ds2;
  data _null_;
    declare char(32) _name_ ;
    declare double value embeded_serial;
    declare package hash result();

    vararray double v[*] garnet jade opal pearl;
    declare double max[1000];

    method init();
      /* declare package sqlstmt s('drop table want'); error in want does not exist */
      /* s.execute(); */
      result.keys([_name_]);
      result.data([_name_ value embeded_serial]);
      result.multidata();
      result.ordered('ascending');
      result.defineDone();
    end;
    method term();
      result.output('want');
    end;
    method run();
      declare int index;
      set sd1.have;
      do index = 1 to dim(v);
        if v[index] > max[index] then do;
          _name_ = vname(v[index]);
          value = v[index];
          if not missing (max[index]) then do;
            result.removeall();
          end;
          result.add();
          max[index] = v[index];
        end;
        else
        if v[index] = max[index] then do;
          _name_ = vname(v[index]);
          value = v[index];
          result.add();
        end;
      end;
    end;
  enddata;
run;
quit;

data _null_;
  set want;
  put _all_;
run;quit;

%mend utl_xds2;
;;;;
run;quit;

%let _s=%qsysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work &_r\wrk
        -rsasuser -nosplash -sasautos &_r\oto -config &_r\cfg\cfgsas.cfg));

systask kill sys1;
%let beg=%sysfunc(time());
systask command "&_s -termstmt %nrstr(%utl_xds2;) -log d:\log\xds2.log" taskname=sys1;
waitfor sys1;
%let elap=%sysevalf(%sysfunc(time())-&beg) ;
%put &=elap;


data _null_;
  set want;
  put _all_;
run;quit;

*_
| | ___   __ _
| |/ _ \ / _` |
| | (_) | (_| |
|_|\___/ \__, |
         |___/
;


651   filename ft15f001 "c:/oto/utl_xds2.sas";
652   parmcards4;
702   ;;;;

NOTE: "sys1" is not an active task/transaction.
NOTE: "sys2" is not an active task/transaction.
NOTE: "sys4" is not an active task/transaction.
NOTE: There are no active tasks/transactions.
703   run;quit;
704   systask kill sys1 sys2 sys3 sys4 sys5 sys6 sys7 sys8;
705   %let beg=%sysfunc(time());
706   systask command "&_s -termstmt %nrstr(%utl_xds2;) -log d:\log\xds2.log" taskname=sys1;
NOTE: The task "sys2" is not an active task.
NOTE: The task "sys3" is not an active task.
NOTE: The task "sys4" is not an active task.
NOTE: The task "sys5" is not an active task.
NOTE: The task "sys6" is not an active task.
NOTE: The task "sys7" is not an active task.
NOTE: The task "sys8" is not an active task.
707   waitfor sys1 sys2 sys3 sys4  sys5 sys6 sys7 sys8;
NOTE: Task "sys1" produced no LOG/Output.
708   %let elap=%sysevalf(%sysfunc(time())-&beg) ;
709   %put &=elap;


ELAP=50.0390000343031

NOTE: Copyright (c) 2016 by SAS Institute Inc., Cary, NC, USA.
NOTE: SAS (r) Proprietary Software 9.4 (TS1M6)
      Licensed to US CENTERS FOR MEDICARE & MEDICAID SERVICES, Site 70124131.
NOTE: This session is executing on the X64_7PRO  platform.



NOTE: Analytical products:

      SAS/STAT 15.1
      SAS/ETS 15.1
      SAS/OR 15.1
      SAS/IML 15.1
      SAS/QC 15.1

NOTE: Additional host information:

 X64_7PRO WIN 6.1.7601 Service Pack 1 Workstation

NOTE: SAS initialization used:
      real time           0.18 seconds
      cpu time            0.18 seconds

NOTE: Libref SD1 was successfully assigned as follows:
      Engine:        V9
      Physical Name: d:\sd1
NOTE: Execution succeeded. No rows affected.

NOTE: PROCEDURE DS2 used (Total process time):
      real time           48.45 seconds
      cpu time            1:14.05



garnet   value=1999999964 embeded_serial=2268517454
jade     value=1999999998 embeded_serial=5653575788
opal     value=1999999996 embeded_serial=5079247733
pearl    value=1999999984 embeded_serial=2830118438




NOTE: There were 4 observations read from the data set WORK.WANT.
NOTE: DATA statement used (Total process time):
      real time           0.00 seconds
      cpu time            0.00 seconds



NOTE: SAS Institute Inc., SAS Campus Drive, Cary, NC USA 27513-2414
NOTE: The SAS System used:
      real time           50.03 seconds
      cpu time            1:14.27




