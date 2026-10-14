#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"

// #DEFINE cAlias "SB1"

User Function MVC_TIP()

    Local aArea := GetArea()
    Local cFBkp := FunName()

    //Somente teste para verificar o funcionamento do ExecView
    //Ele abre a visualização de produtos já posicionado no primeiro registro existente. É necessário posicionar antes de abrir o ExecView
    SetFunName("MATA010")
    FWExecView("Teste ExecView", "MATA010", MODEL_OPERATION_VIEW)
    SetFunName(cFBkp)

    RestArea(aArea)

Return Nil
