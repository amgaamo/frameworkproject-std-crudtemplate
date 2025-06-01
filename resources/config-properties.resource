*** Variables ***
### [VARIABLE URL] ###
#-------------------------------------------------------------#
# ${VAR_BROWSER} >> (chromium,chrome/msedge/firefox/Safari)   #
# ${VAR_BOTVERSION} >> VX.Y.Z -- X=Major / Y=Minor / Z=Patch  #
#-------------------------------------------------------------#
${VAR_BOTVERSION}           V1.1.100
${VAR_BROWSER}              chromium
${VAR_PROTOCOL}             https
${VAR_IPSERV}               ci.netbay.co.th
${VAR_PATHLOGIN_URL}        usermanagement
${VAR_API_SUBDIRECTORY}     usermanagement-api

### [MODE FOR TEST] ###
#-------------------------------------------------------------------------------------------------#
#  ${_fixdata_}         >>  true = Fix data value       /   false = Get environment value         #
#  ${_headlessmode_}    >>  true = Run headless mode    /   false = Open browser to run script    #
#  ${_concurrentmode_}  >>  true = Run concurrent mode  /   false = Run single mode               #
#  ${_loadingchecknetwork_}  >> true= Use keyword "wait until network is idle"                    #
#-------------------------------------------------------------------------------------------------#
${_headlessmode_}           false
${_fixdata_}                true
${_concurrentmode_}         false
${_loadingchecknetwork_}    true

${_SET_DISPLAY_HEIGHT}      1920
${_SET_DISPLAY_WIDTH}       1080
