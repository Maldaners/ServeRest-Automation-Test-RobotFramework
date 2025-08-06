*** Settings ***
Documentation    Teste para a aplicação ServeRest

Resource         ../variables/variables.robot

Library    String

*** Keywords ***

I want to create a new user
    New User data
    Post New User
    Conferir usuario cadastrado corretamente
# I send all the required data in the request
#     Decode Bytes To String

# the response should return status code 201 Created
#     Fail



New User data
   ${words}   Generate Random String   
    ${words}   Convert To Lower Case    ${words}   
   Set Test Variable    ${email}  ${words}@emailtest.com
    Log To Console     ${email}
   ${senha}   Generate Random String   
    ${senha}   Convert To Lower Case    ${senha}   
   Set Test Variable    ${password}  ${senha}

Post New User
   ${body}   Create Dictionary   
   ...       nome=Someone dos Santos  
   ...       email=${email}  
   ...      password=${password}
   ...  administrador=true  
   
   
   Criar Sessão
    ${Response}  POST On Session  
    ...    alias=ServerRest
    ...    url=/usuarios
    ...    json=${body}
    
    Set Task Variable    ${RESPONSE}   ${Response.json()}

Cadastrar novo usuario criado com erro na ServerRest
    Buscar dados para Login 

   ${body}   Create Dictionary   
   ...       nome= 
   ...       email=${email}
   ...  administrador=true  
   
   
   Criar Sessão
    ${Response}  POST On Session  
    ...    alias=ServerRest
    ...    url=/usuarios
    ...    json=${body}
    

    Set Task Variable    ${RESPONSE}   ${Response.json()}
    Log To Console    ${Response.json()}
Então a chamada deverá retornar ${statusCode}
    Should Be Equal As Integers    ${Response.status_code}   ${statusCode}

Buscar dados para Login 
    Criar Sessão
    ${Response}  GET On Session  
    ...    alias=ServerRest
    ...    url=/usuarios 
    
    Set Task Variable    ${RESPONSE}   ${Response.json()}
    
    Set Test Variable    ${email}    ${Response}[usuarios][0][email]
    Set Test Variable    ${password}    ${Response}[usuarios][0][password]

Criar Sessão
    ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json 
    Create Session    alias=ServerRest    url=https://serverest.dev  headers=${headers} 

Login test com email na ServerRest
   ${body}   Create Dictionary   
   ...       email=${email}  
   ...      password=${password}

   
   
   Criar Sessão
    ${Response}  POST On Session  
    ...    alias=ServerRest
    ...    url=/Login
    ...    json=${body}
    
    Set Task Variable    ${RESPONSE}   ${Response.json()}
    
Conferir usuario cadastrado corretamente

    Dictionary Should Contain Item  ${RESPONSE}  message  Cadastro realizado com sucesso 
    Dictionary Should Contain Key   ${RESPONSE}    _id 