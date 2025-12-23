compile isptsvr twtr trdr
assemble isptfix and tfix2
use assembly statementements and build isptfix
copy rhdcmapr from system lib isplg.idms.r190.z211.rt.cagjload to
    isplg.idms.r190.z211.dba.loadlib (or dba load)
run amastfix
isptmapr and isptvect to hook into idmsmapr
assemble with asmtmapr
run tvec in idms to install the hook
