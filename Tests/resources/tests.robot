*** Settings ***
Documentation    Teste para a aplicação ServeRest

Resource         ../variables/variables.robot

Library    String

*** Keywords ***

I want to create a new user
    New User data
    
I send all the required data in the request
    Post New User



New User data
    ${words}   Generate Random String   12    [LETTERS] 
    ${words}   Convert To Lower Case    ${words}   
    Set Test Variable    ${email}       ${words}@emailtest.com
    Log To Console     ${email}


    ${senha}   Generate Random String   8   [NUMBERS][LETTERS]  
    Set Test Variable    ${password}   ${senha}

Post New User
   ${body}   Create Dictionary   
   ...       nome=Someone dos Santos  
   ...       email=${email}  
   ...       password=${password}
   ...       administrador=true  
   
   
   Criar Sessão
    ${Response}  POST On Session  
    ...    alias=ServerRest
    ...    url=/usuarios
    ...    json=${body}
   
    Set Task Variable    ${Response}   ${Response}
    Log To Console    ${Response}

the response should return status code ${statusCode} ${reason}
    Should Be Equal As Numbers     ${Response.status_code}   ${statusCode}
    Should Be Equal As Strings     ${Response.reason}   ${reason}
    
    Conferir usuario cadastrado corretamente

Buscar dados para Login 
    Criar Sessão
    ${Response}  GET On Session  
    ...    alias=ServerRest
    ...    url=/usuarios 
    
    Set Task Variable    ${RESPONSE}   ${Response.json()}
    
    Set Test Variable    ${email}    ${Response}[usuarios][0][email]
    Set Test Variable    ${password}    ${Response}[usuarios][0][password]


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

    Dictionary Should Contain Item  ${Response.json()}  message  Cadastro realizado com sucesso 
    Dictionary Should Contain Key   ${Response.json()}    _id 