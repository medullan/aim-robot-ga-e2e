*** Settings ***
Library           Collections
Library           OperatingSystem
Library           RequestsKeywords.py
Library           Selenium2Library
Test Setup        Open Browser    ${MYBLUE_PILOT}${MYBLUE_PILOT_URL}    ${BROWSER}
Test Teardown     Close Browser

*** Variables ***
${BROWSER}        firefox
# AIM VARIBALES
${VALID_USER}    marchcontractuat
${INVALID_USER}    notamember
${VALID_PASSWORD}    Bigfun21!
${INVALID_PASSWORD}    Smallbore13$
${MYBLUE_PILOT}    https://test.fepblue.org:7443
${MYBLUE}    https://test.fepblue.org:8443
${SSO}    https://ssotest.fepblue.org:9031
${MYBLUE_PILOT_URL}    /pilot/login
${MYBLUE_CLASSIC_URL}    /web/guest/myblue
${MYBLUE_CLASSIC_HOME}    /members/myblue/dashboard
${AIM_PARAMS}    &dataLoad=true&_58_struts_action=%2Flogin%2Frest_aimcollectordetails
${AIM_WS}    ${MYBLUE}/web/guest/myblue?p_p_id=58&p_p_state=normal&p_p_lifecycle=1${AIM_PARAMS}
# GA VARIBALES
${GA_KEY}         AIzaSyCFj15TpkchL4OUhLD1Q2zgxQnMb7v3XaM
${GA_DIMENSION}    rt:pagePath
${GA_METRIC}      rt:pageViews
${GA_PROFILE_ID}    ga:92930649
${GA_BEARER_TOKEN}    Bearer ya29.zABUvOPcIbadhwL2XiBdatTF7LXfIrp3Gd6Xd67QQUaPcb_t2JvUVy4WVZJj8ws9pkPamoJC400fBA
${GA_REAL_TIME_DATA_ENDPOINT}    https://content.googleapis.com
${GA_REALTIME_CONSOLE}    https://developers.google.com/analytics/devguides/reporting/realtime/v3/reference/data/realtime/get


*** Test Cases ***
Logged for Valid User
    Get GA first rt:pageViews total for rt:pagePath ==${MYBLUE_CLASSIC_HOME}
    Login with valid user
    Wait Until Page Contains Element    userNameText
    Get GA next rt:pageViews total for rt:pagePath ==${MYBLUE_CLASSIC_HOME}
    The next should be more than first
    Logout User

Logged for for Invalid User
    Get GA first rt:pageViews total for rt:pagePath ==${MYBLUE_CLASSIC_HOME}
    Get GA oldlogin rt:pageViews total for rt:pagePath ==${MYBLUE_PILOT_URL}
    Login with invalid user
    Wait Until Page Contains    User Credentials Invalid
    Get GA next rt:pageViews total for rt:pagePath ==${MYBLUE_CLASSIC_HOME}
    Get GA newlogin rt:pageViews total for rt:pagePath ==${MYBLUE_PILOT_URL}
    The newlogin should be more than oldlogin
    The next should be same as first

*** Keywords ***
Login as ${username} ${password}
    Go To    ${MYBLUE_PILOT}${MYBLUE_PILOT_URL}
    Input Text    LoginUsername    ${username}
    Input Password    LoginPassword    ${password}
    Click Element    login

Login with ${what} user
    Login as ${${what}_USER} ${${what}_PASSWORD}

The ${arg0} should be same as ${arg1}
    Should Be Equal    ${${arg0}}    ${${arg1}}

The ${arg0} should be more than ${arg1}
    Should Be True    ${${arg0}} > ${${arg1}}

Logout User
    Go To    ${SSO}/idp/startSLO.ping?InErrorResource=${MYBLUE}/c/portal/logout

Get GA ${varName} ${metric} total for ${field} ${criteria}
    Setup Analytics ga-page-count
    ${counts}=    Get Google Analytics Page Hit ga-page-count ${GA_KEY} ${GA_PROFILE_ID} ${GA_METRIC} ${field} ${field}${criteria}
    Set Test Variable    ${${varName}}    ${counts['${metric}']}
    [Return]    ${counts['${metric}']}

Check Analytics Hit ${ref} ${path} ${criteria}
    Setup Analytics ${ref}
    ${counts}=    Get Google Analytics Page Hit ${ref} ${GA_KEY} ${GA_PROFILE_ID} ${GA_METRIC} ${GA_DIMENSION} ${criteria}
    [Return]    ${counts}

Setup Analytics ${ga}
    Run Keyword    Create Session    ${ga}    ${GA_REAL_TIME_DATA_ENDPOINT}

Get Google Analytics Page Hit ${ga} ${gaKey} ${profileId} ${metrics} ${dims} ${filter}
    #URL Parameters to be passed to GA Real Time Endpoint
    ${params}=    Create Dictionary    ids=${profileId}    key=${gaKey}
    #${filters}=    Url Encode    ga:pagepath==${filter}
    Set To Dictionary    ${params}    metrics=${metrics}    dimensions=${dims}    filters=${filter}
    #Headers to be passed to GA Real Time Endpoint
    ${headers}=    Create Dictionary    authorization=${GA_BEARER_TOKEN}    referer=${GA_REALTIME_CONSOLE}
    #Response recieved from ga realtime end point
    ${resp}=    Run Keyword    Get    ${ga}    /analytics/v3/data/realtime    params=${params}    headers=${headers}
    ${jsondata}=    To Json    ${resp.content}
    Log Dictionary    ${jsondata}
    [Return]    ${jsondata['totalsForAllResults']}
