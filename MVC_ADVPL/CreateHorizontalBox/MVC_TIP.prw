#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'

#DEFINE cAliasPai  "SB1"
#DEFINE cAliasEsq  "SB2"
#DEFINE cAliasDir  "SA5"

User Function MVC_TIP()

    Local aArea   := GetArea()
    Local oBrowse
    Private aRotina := MenuDef()

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasPai)
    oBrowse:SetDescription("MVC TI PREMIUM - GRIDS")
    oBrowse:DisableDetails()
    oBrowse:Activate()

    RestArea(aArea)

Return Nil


Static Function ModelDef()

    Local oStructPai := FWFormStruct(1, cAliasPai)
    Local oStructEsq := FWFormStruct(1, cAliasEsq)
    Local oStructDir := FWFormStruct(1, cAliasDir)
    Local oModel
    Local aRelEsq    := {}
    Local aRelDir    := {}

    oModel := MPFormModel():New("MVC_TIPM")
    oModel:SetDescription("MVC TI PREMIUM ESTUDOS")

    oModel:AddFields("MVCMASTER",, oStructPai)
    oModel:GetModel("MVCMASTER"):SetDescription("Produto")
    oModel:SetPrimaryKey({"B1_FILIAL", "B1_COD"})

    oModel:AddGrid("MVCGRID1", "MVCMASTER", oStructEsq)
    oModel:GetModel("MVCGRID1"):SetDescription("Saldos por Armazem")
    aAdd(aRelEsq, {"B2_FILIAL", "FWxFilial('SB2')"})
    aAdd(aRelEsq, {"B2_COD"   , "B1_COD"})
    oModel:SetRelation("MVCGRID1", aRelEsq, SB2->(IndexKey(1))) // B2_FILIAL+B2_COD+B2_LOCAL
    oModel:GetModel("MVCGRID1"):SetUniqueLine({"B2_LOCAL"})
    oModel:GetModel("MVCGRID1"):SetOptional(.T.)
    oModel:GetModel("MVCGRID1"):SetOnlyQuery(.T.)   // saldo nao deve ser gravado por aqui
    oModel:GetModel("MVCGRID1"):SetNoInsertLine(.T.)
    oModel:GetModel("MVCGRID1"):SetNoUpdateLine(.T.)
    oModel:GetModel("MVCGRID1"):SetNoDeleteLine(.T.)

    oModel:AddGrid("MVCGRID2", "MVCMASTER", oStructDir)
    oModel:GetModel("MVCGRID2"):SetDescription("Produto x Fornecedor")
    aAdd(aRelDir, {"A5_FILIAL" , "FWxFilial('SA5')"})
    aAdd(aRelDir, {"A5_PRODUTO", "B1_COD"})
    oModel:SetRelation("MVCGRID2", aRelDir, SA5->(IndexKey(2))) // A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA
    oModel:GetModel("MVCGRID2"):SetUniqueLine({"A5_FORNECE", "A5_LOJA"})
    oModel:GetModel("MVCGRID2"):SetOptional(.T.)

Return oModel


Static Function ViewDef()

    Local oModel     := FWLoadModel("MVC_TIP")
    Local oStructPai := FWFormStruct(2, cAliasPai)
    Local oStructEsq := FWFormStruct(2, cAliasEsq)
    Local oStructDir := FWFormStruct(2, cAliasDir)
    Local oView

    //Remove os campos antes de adicionar na View
    oStructEsq:RemoveField("B2_COD")
    oStructDir:RemoveField("A5_PRODUTO")

    oView := FWFormView():New()
    oView:SetModel(oModel)

    // O 3 parametro tem que ser o MESMO ID usado na ModelDef
    oView:AddField("VIEW_CABEC", oStructPai, "MVCMASTER")
    oView:AddGrid ("VIEW_GRID1", oStructEsq, "MVCGRID1")
    oView:AddGrid ("VIEW_GRID2", oStructDir, "MVCGRID2")

    oView:CreateHorizontalBox("BOX_CABEC", 40)
    oView:CreateHorizontalBox("BOX_GRIDS", 60)
        oView:CreateVerticalBox("BOX_ESQ", 50, "BOX_GRIDS")
        oView:CreateVerticalBox("BOX_DIR", 50, "BOX_GRIDS")

    oView:SetOwnerView("VIEW_CABEC", "BOX_CABEC")
    oView:SetOwnerView("VIEW_GRID1", "BOX_ESQ")
    oView:SetOwnerView("VIEW_GRID2", "BOX_DIR")

    oView:EnableTitleView("VIEW_CABEC", "Produto")
    oView:EnableTitleView("VIEW_GRID1", "Saldos por Armazem")
    oView:EnableTitleView("VIEW_GRID2", "Produto x Fornecedor")

Return oView


Static Function MenuDef()

    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0
    ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina
