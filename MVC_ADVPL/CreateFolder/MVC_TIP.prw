#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"

#DEFINE cAlias "SB1"

User Function MVC_TIP()

    Local aArea := GetArea()
    Local oBrowse
    Private aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAlias)
    oBrowse:SetDescription("MVC_TI_PREMIUM")
    oBrowse:DisableDetails()
    oBrowse:Activate()
    RestArea(aArea)


Return Nil


Static Function ModelDef()

    Local oStruct := FWFormStruct(1, cAlias)
    Local oModel
    Local bPre := Nil //Antes de abrir o formulário
    Local bPos := Nil //Clicar em CONFIRMAR antes de salvar
    Local bCommit := Nil //Após fechar o Formulário quando for salvar
    Local bCancel := Nil //Ao clicar em CANCELAR

    oModel := MPFormModel():New("MVC_TIPM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("MVCMASTER",, oStruct)
    oModel:SetDescription("MVC TI PREMIUM ESTUDOS")
    oModel:GetModel("MVCMASTER"):SetDescription("MVC TI PREMIUM ESTUDOS")
    oModel:SetPrimaryKey({})    

Return oModel

Static Function ViewDef()

    Local cCamposPr := "B1_COD | B1_DESC"
    Local cCamposObs := "B1_LOCPAD | B1_GRUPO"
    Local oModel := FWLoadModel("MVC_TIP")
    Local oStructPr := FWFormStruct(2, cAlias, {|cCampo| AllTrim(cCampo) $ cCamposPr} )
    Local oStructOb := FWFormStruct(2, cAlias, {|cCampo| AllTrim(cCampo) $ cCamposObs} )
    Local oView

    //Remova da aba padrão
    oStructPr:SetNoFolder()
    oStructOb:SetNoFolder()

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_MVCPR", oStructPr, "MVCMASTER")
    oView:AddField("VIEW_MVCOBS", oStructOb, "MVCMASTER")

    oView:CreateFolder("ABAS")
    oView:AddSheet("ABAS", "PRINCIPAL", "Principal")
    oView:AddSheet("ABAS", "OBSERVACAO", "Observação")

    oView:CreateHorizontalBox("TELAP", 100, , , "ABAS", "PRINCIPAL")
    oView:CreateHorizontalBox("TELAO", 100, , , "ABAS", "OBSERVACAO")
    oView:SetOwnerView("VIEW_MVCPR", "TELAP")
    oView:SetOwnerView("VIEW_MVCOBS", "TELAO")

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

