#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"

User Function MVC_TIP()

    Local aArea := GetArea()
    Local cFBkp := FunName()
    Local cCod := 'FV1000011C4336'

    //Somente teste para verificar o funcionamento do ExecView
    //Ele abre a visualização de produtos já posicionado no primeiro registro existente. É necessário posicionar antes de abrir o ExecView

    DbSelectArea("SB1")
    If SB1->(DbSetOrder(1), MSSeek(FWxFilial("SB1") + cCod))
        SetFunName("MATA010")
        FWExecView("Teste ExecView", "MATA010", MODEL_OPERATION_VIEW)
        SetFunName(cFBkp)
    Endif

    RestArea(aArea)

Return
