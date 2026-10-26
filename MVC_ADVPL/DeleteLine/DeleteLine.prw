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

    oView:AddUserButton("@Limpar Grid",         "MAGIC_BMP", {||u_lmpGrd()},,,,.F./*Exibir no Grid caso haja espaço*/)
    oView:AddUserButton("@Deletar/Desdeletar",  "MAGIC_BMP", {||u_delUndel()},,,,.F.)

    //Remoção de campo. Caso haja mais de um campo, utilizar aEval + StrTokArr para remoção em lote
    oStructFilho:RemoveField("B5_PRV2")

    //oView:AddIncrementField("MVCDETAIL", )

Return oView


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5

    //Caso deseje a inclusão de uma rotina personalizada, pode ser adicionado mais um botão à lista chamando a rotina personalizada, como no exemplo abaixo:
    //ADD OPTION aRotina TITLE 'Rotina Personalizada' ACTION 'MVC_TI_PREMIUM' OPERATION 6 ACCESS 0 //OPERATION 6

Return aRotina

//Limpeza do Grid
User Function lmpGrd()

    Local aArea := FWGetArea()
    Local oModelPad := FWModelActive()
    Local oModelGrid := oModelPad:GetModel("MVCDETAIL")

    If oModelGrid:CanClearData()
        oModelGrid:ClearData()
    Endif

    FWRestArea(aArea)

Return 

//Deleção e Desdeleção de linha do grid
User Function delUndel()

    Local aArea      := FWGetArea()
    Local oModelPad  := FWModelActive()
    Local oModelGrid := oModelPad:GetModel("MVCDETAIL")
    Local nLine      := 0 As Numeric
    
    //Percorro todas as linhas do modelo
    For nLine := 1 To oModelGrid:Length()

        //Posiciono na linha do contador a cada loop
        oModelGrid:GoLine(nLine)

        //Se tiver deletado, desdeleta, se não, deleta
        If oModelGrid:IsDeleted()
            oModelGrid:UndeleteLine()
        Else    
            oModelGrid:DeleteLine()
        Endif

    Next

    FWRestArea(aArea)

Return
