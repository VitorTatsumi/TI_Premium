#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"

#DEFINE cAliasPai "SB1"
#DEFINE cAliasFilho "SB5"

User Function MVC_TIP()

    Local aArea := GetArea()
    Local oBrowse
    Private aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasPai)
    oBrowse:SetDescription("MVC_TI_PREMIUM")
    oBrowse:DisableDetails()
    oBrowse:Activate()
    RestArea(aArea)


Return Nil


Static Function ModelDef()

    Local oStructPai := FWFormStruct(1, cAliasPai)
    Local oStructFilho := FWFormStruct(1, cAliasFilho)
    Local oModel
    Local aRelation := {}
    Local bPre := Nil //Antes de abrir o formulário
    Local bPos := Nil //Clicar em CONFIRMAR antes de salvar
    Local bCommit := Nil //Após fechar o Formulário quando for salvar
    Local bCancel := Nil //Ao clicar em CANCELAR

    oModel := MPFormModel():New("MVC_TIPM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("MVCMASTER",, oStructPai)
    oModel:AddGrid("MVCDETAIL", "MVCMASTER", oStructFilho)
    oModel:SetDescription("MVC TI PREMIUM ESTUDOS")
    oModel:GetModel("MVCMASTER"):SetDescription("MVC TI PREMIUM CAMPOS")
    oModel:GetModel("MVCDETAIL"):SetDescription("MVC TI PREMIUM DETALHES")
    oModel:SetPrimaryKey({})    

    aAdd(aRelation, {"B5_FILIAL", "FWxFilial('SB5')"})
    aAdd(aRelation, {"B5_COD", "B1_COD"})
    oModel:SetRelation("MVCDETAIL", aRelation, SB5->(IndexKey(1)))

    //"Validação" de linha duplicada no grid
    oModel:GetModel("MVCDETAIL"):SetUniqueLine({"B5_COD"})

Return oModel

Static Function ViewDef()

    Local oModel := FWLoadModel("MVC_TIP")
    Local oStructPai := FWFormStruct(2, cAliasPai)
    Local oStructFilho := FWFormStruct(2, cAliasFilho)
    Local oView

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_MVCPAI", oStructPai, "MVCMASTER")
    oView:AddGrid("VIEW_MVCFILHO", oStructFilho, "MVCDETAIL")
    oView:CreateHorizontalBox("CABEC", 70)
    oView:CreateHorizontalBox("GRID", 30)
    oView:SetOwnerView("VIEW_MVCPAI", "CABEC")
    oView:SetOwnerView("VIEW_MVCFILHO", "GRID")

    //Remoção de campo. Caso haja mais de um campo, utilizar aEval + StrTokArr para remoção em lote
    oStructFilho:RemoveField("B5_PRV2")

    //oView:AddIncrementField("MVCDETAIL", )

Return oView


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

    //Caso deseje a inclusão de uma rotina personalizada, pode ser adicionado mais um botão à lista chamando a rotina personalizada, como no exemplo abaixo:
    //ADD OPTION aRotina TITLE 'Rotina Personalizada' ACTION 'MVC_TI_PREMIUM' OPERATION MODEL_OPERATION_CUSTOM ACCESS 0 //OPERATION 6

Return aRotina

//O P.E. deve ter o mesmo nome do ID do modelo 
User Function MVC_TIPM() 
    Local aParam := PARAMIXB 
    Local xRet := .T. 
    Local oObj := Nil 
    Local cIdPonto := ""
    Local cIdModel := ""
    Local nOper := 0 
    Local cCampo := ""
    Local cTipo := ""
    Local lEnd
 
    //Se tiver parâmetros
    If aParam != Nil 
        ConOut("> "+aParam[2]) 
 
        //Pega informações dos parâmetros
        oObj := aParam[1] 
        cIdPonto := aParam[2] 
        cIdModel := aParam[3] 
 
        //Valida a abertura da tela
        If cIdPonto == "MODELVLDACTIVE"
            xRet := .T. 
            //nOper := oObj:nOperation
 
            //Pré configurações do Modelo de Dados
        ElseIf cIdPonto == "MODELPRE"
            xRet := .T. 
 
            //Pré configurações do Formulário de Dados
        ElseIf cIdPonto == "FORMPRE"
            xRet := .T. 
 
            //nOper := oObj:GetModel(cIdPonto):nOperation
            //cTipo := aParam[4]
            //cCampo := aParam[5]
 
            //Se for Alteração
            //If nOper == 4
            //Não permite alteração dos campos
            //    If cTipo == "CANSETVALUE" .And. Alltrim(cCampo) $ ("CAMPO1;CAMPO2;CAMPO3")
            //        xRet := .F.
            //    EndIf
            //EndIf
 
            //Adição de opções no Ações Relacionadas dentro da tela
        ElseIf cIdPonto == "BUTTONBAR"
            xRet := {}
            //aAdd(xRet, {"* Titulo 1", "", {|| Alert("Botão 1")}, "Tooltip 1"})
            //aAdd(xRet, {"* Titulo 2", "", {|| Alert("Botão 2")}, "Tooltip 2"})
            //aAdd(xRet, {"* Titulo 3", "", {|| Alert("Botão 3")}, "Tooltip 3"})
 
            //Pós configurações do Formulário
        ElseIf cIdPonto == "FORMPOS"
            nOper := oObj:GetModel(cIdPonto):nOperation
 
            xRet := .T. 
 
            //Validação ao clicar no Botão Confirmar
        ElseIf cIdPonto == "MODELPOS"
            xRet := .T. 
 
            //Pré validações do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPRE"
 
            //Pós validações do Commit
        ElseIf cIdPonto == "FORMCOMMITTTSPOS"
 
            //Commit das operações (antes da gravação)
        ElseIf cIdPonto == "MODELCOMMITTTS"
 
            //Commit das operações (após a gravação)
        ElseIf cIdPonto == "MODELCOMMITNTTS"
            nOper := oObj:nOperation
 
            //Mostrando mensagens no fim da operação
            If nOper == 3
                Alert("Fim da Inclusão")
                 
            ElseIf nOper == 4  
                Alert("Fim da Alteração")
            EndIf
        EndIf 
    EndIf 
Return xRet
