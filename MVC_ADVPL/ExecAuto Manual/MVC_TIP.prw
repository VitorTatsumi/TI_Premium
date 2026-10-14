#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"

#DEFINE cLinha CHR(10) + CHR(13)
User Function MVC_TIP()

    Local aArea := GetArea()
    Local lRet := .F.
    Local oModel
    Local oSB1Modelo
    Local aErro := {}

    DbSelectArea("SB1")

    oModel := FWLoadModel("MATA010")
    oModel:SetOperation(3) //Inclusão
    oModel:Activate()

    oSB1Modelo := oModel:getModel("SB1MASTER")
    oSB1Modelo:SetValue("B1_COD", "FV001C001")
    oSB1Modelo:SetValue("B1_DESC", "PROD TESTE")
    oSB1Modelo:SetValue("B1_TIPO", "PA")
    ConfirmSX8()

    If oModel:VldData() .AND. oModel:CommitData()
        lRet := .T.
    Endif

    If !lRet 
        aErro := oModel:GetErrorMessage()
        MsgInfo("Id do Formulário: " + AllToChar(aErro[01]) + cLinha+;
                "Id do Campo de origem: " + AllToChar(aErro[02]) + cLinha+;
                "Id do formulário do Erro: " + AllToChar(aErro[03]) + cLinha+;
                "Id do Campo de Erro: " + AllToChar(aErro[04]) + cLinha+;
                "Id do Erro: " + AllToChar(aErro[05]) + cLinha+;
                "Mensagem de erro: " + AllToChar(aErro[06]) + cLinha+;
                "Solução: " + AllToChar(aErro[07]) + cLinha+;
                "Valor atribuído: " + AllToChar(aErro[08]) + cLinha+;
                "Valor anterior: " + AllToChar(aErro[09]) + cLinha)

        MostraErro()
    Endif

    RestArea(aArea)
Return
