*** Settings ***
Documentation    Teste para a aplicação ServeRest

Resource         ../../variables/variables.robot

Library    String

*** Keywords ***

Criar Sessão
    ${headers}  Create Dictionary  
    ...    accept=application/json
    ...    Content-Type=application/json 
   


    Create Session    alias=ServerRest    
    ...               url=https://serverest.dev  
    ...               headers=${headers} 
        
 