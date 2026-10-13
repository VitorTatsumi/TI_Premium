#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "tbiconn.ch"

User Function MVC_TIP()

    Private oMark 

    oMark := FWMarkBrowse():New()
    oMark:SetAlias("SA2")

    oMark:SetSemaphore(.T.)
    oMark:SetDescription("Seleção de Produtos")
    oMark:SetFieldMark('A2_OK')

    oMark:Activate()


Return Nil

Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Processar' ACTION 'u_slctA2' OPERATION 2   ACCESS 0

Return aRotina


User Function slctA2()

    Local aArea := GetArea()    
    Local cMarca := oMark:Mark()
    Local nTotal := 0

    SA2->(DbGoTop())
    While !SA2->(EoF())
        If oMark:IsMark(cMarca)
            nTotal ++ 
            RecLock("SA2", .F.)
                A2_OK := ''
            SA2->(MsUnlock())
        Endif
        SA2->(DbSkip())
    Enddo

    MsgInfo("Foram marcados " + cValToChar(nTotal) + " registros.")

    RestArea(aArea)

Return
