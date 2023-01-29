*** Settings ***
Documentation  API Testing in Robot Framework
Library  SeleniumLibrary
Library  RequestsLibrary
Library  JSONLibrary
Library  Collections
Library  String    

*** Variables ***
${Api_Base_Endpoint}     https://reqres.in/   



*** Test Cases ***
Do a GET Request and validate the response code 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${response}=  GET On Session  mysession  /api/users    params=page=2  
    Status Should Be  200  ${response}  #Check Status as 200
    ${json_response}=  Convert String to JSON    ${response.content}
    ${contents}=  Get Value From Json    ${json_response}    page   
    Log To Console    ${contents}    
    
    #Validation
    ${contents}=    Convert To String    ${contents}
    ${contents}=  Remove String Using Regexp    ${contents}    ['\\[\\],] 
    Should Be Equal    ${contents}    2   
    ${header_value}=  Get From Dictionary    ${response.headers}    Content-Type
    Should Be Equal    ${header_value}    application/json; charset=utf-8    

Do a GET Request for a single user and validate the response body
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${response}=  GET On Session  mysession  /api/users/2  
    Status Should Be  200  ${response}  #Check Status as 200

    #Check id as 2 from Response Body
    ${id}=   Get Value From Json  ${response.json()}  data.id
    ${idFromList}=  Get From List   ${id}  0
    ${string_id}=    Convert To String     ${idFromList}
    Should Be Equal    ${string_id}    2    
        
Do a GET Request for user not found and validate the response code 404
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${response}=  GET On Session  mysession  /api/users/23  expected_status=404    
    Status Should Be  404  ${response}  #Check Status as 404
    
Do a POST Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    name=Leena    job=SW Engineer    id=555
    Log To Console    ${body}    
    ${response}=  POST On Session  mysession  /api/users/    data=${body}
    Status Should Be  201  ${response}  #Check Status as 201
    #Validation
    ${id}=  Get Value From Json  ${response.json()}  id
    ${idFromList}=  Get From List   ${id}  0
    ${idFromListAsString}=  Convert To String  ${idFromList}
    Should be equal As Strings  ${idFromListAsString}  555
 
    
Do a PUT Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    name=Raghad    job=SW Engineer    id=666
    Log To Console    ${body}    
    ${response}=  PUT On Session  mysession  /api/users/2    data=${body}
    Status Should Be  200  ${response}  #Check Status as 200
    
    
Do a DELETE Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${response}=  DELETE On Session  mysession  /api/users/2    
    Status Should Be  204  ${response}  #Check Status as 204
    
    
Do a GET Request with delayed response  
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${response}=  GET On Session  mysession  /api/users    params=delay=3  
    Sleep    3s
    Status Should Be  200  ${response}  #Check Status as 200
    

Do REGISTER - SUCCESSFUL Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    email=eve.holt@reqres.in    password=pistol   
    Log To Console    ${body}    
    ${response}=  POST On Session  mysession  /api/register    data=${body}
    Status Should Be  200  ${response}  #Check Status as 200
    Should Contain    ${response.json()}    id  
    Should Contain    ${response.json()}    token    
  

Do REGISTER - UNSUCCESSFUL Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    email=sydney@fife
    Log To Console    ${body}    
    ${response}=  POST On Session  mysession  /api/register    data=${body}    expected_status=400
    Status Should Be  400  ${response}  #Check Status as 400     
     
    
Do LOGIN - SUCCESSFUL Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    email=eve.holt@reqres.in    password=cityslicka   
    Log To Console    ${body}    
    ${response}=  POST On Session  mysession  /api/login    data=${body}
    Status Should Be  200  ${response}  #Check Status as 200  
    Should Contain    ${response.json()}    token 
    
   
Do LOGIN - UNSUCCESSFUL Request and validate the response 
    Create Session  mysession  ${Api_Base_Endpoint}  verify=true
    ${body}=  Create Dictionary    email=peter@klaven
    Log To Console    ${body}    
    ${response}=  POST On Session  mysession  /api/login    data=${body}    expected_status=400
    Status Should Be  400  ${response}  #Check Status as 400 
    




  