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
    Local bPre := {|| u_fbPre()} //Antes de abrir o formulário
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

    Local oModel := FWLoadModel("MVC_TIP")
    Local oStruct := FWFormStruct(2, cAlias)
    Local oView

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_MVC", oStruct, "MVCMASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:SetOwnerView("VIEW_MVC", "TELA")

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

//Validação que acontece antes da abertura do formulário
User Function fbPre()

	Local oModelAct := FWModelActive()
	Local lRet := .T.

	//O campo B1_DESC do modelo ativo ganha a propriedade 
	oModelAct:GetModel("MVCMASTER"):GetStruct():SetProperty("B1_DESC", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, "INCLUI"))

Return lRet
