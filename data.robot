*** Settings ***
Library           Collections
Library           OperatingSystem
Library           RequestsKeywords.py
Library           Selenium2Library
#Test Setup        Open Browser    ${MYBLUE_PILOT_URL}    ${BROWSER}
#Test Teardown     Close Browser

*** Variables ***
${BROWSER}        firefox
# GA VARIBALES
${GA_KEY}         AIzaSyCFj15TpkchL4OUhLD1Q2zgxQnMb7v3XaM
${GA_DIMENSION}    rt:pagePath
${GA_METRIC}      rt:pageViews
${GA_PROFILE_ID}    ga:92930649
${GA_BEARER_TOKEN}    Bearer ya29.ywB_Lp8jp6Wzd5PTxNU_pwTKJi7Dna9v-NShIjUguQ6zdyaif7P8PSafqXUsPJxwzo8Z4qQsOp5cCQ
${GA_REAL_TIME_DATA_ENDPOINT}    https://content.googleapis.com/analytics/v3/data/realtime?key=${GA_KEY}
#${DEF_PARAMS}    Create Dictionary    ids=${GA_PROFILE_ID}    key=${GA_KEY}

*** Test Cases ***
Something
    Log    ${GA_METRIC.replace(/[^a-zA-Z0-9]/, '_')}