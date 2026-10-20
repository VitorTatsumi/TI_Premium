#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "tbiconn.ch"
#Include "Totvs.ch"

#DEFINE cAlias "SB1"
Static cTitulo := "TEMPORÁRIA - "

User Function MVC_TIP()

    Local aArea := FWGetArea() //Salva a área selecionada
    Local oBrowse
    Local aCmp := {}
    Local aColunas := {}
    Local aPesquisa := {}
    Private lCopy := .F.
    Private oTmpTable := Nil
    Private cAliasTmp := GetNextAlias() //Pega o próximo alias disponível
    Private aRotina := MenuDef()

    //Cria os campos 
    aAdd(aCmp, {"TMP_COD",      "C", 06, 0})
    aAdd(aCmp, {"TMP_DESC",     "C", 50, 0})
    aAdd(aCmp, {"TMP_VLR",    "N", 10, 0})
    aAdd(aCmp, {"TMP_DATA",     "D", 08, 0})

    //Cria a tabela temporária
    oTmpTable := FWTemporaryTable():New(cAliasTmp)  //Cria a tabela temporária e passa o Alias
    oTmpTable:SetFields(aCmp)                        //Seta os campos criados 
    oTmpTable:AddIndex("1", {"TMP_COD"})            //Adiciona índice
    oTmpTable:Create()                              //Cria
    cTitulo += oTmpTable:GetRealName()              //Pega o nome real da tabela

    //Definição de colunas que serão exibidas no Browse
    aAdd(aColunas, {"Codigo",       "TMP_COD", "C", 06, 0, "@!"})
    aAdd(aColunas, {"Descrição",    "TMP_DESC", "C", 50, 0, "@!"})
    aAdd(aColunas, {"Valor",        "TMP_VLR", "N", 10, 0, "@E 9,999,999.99"})
    aAdd(aColunas, {"Data",         "TMP_DATA", "D", 08, 0, "@D"})

    //Cria os campos de Pesquisa
    aAdd(aPesquisa, {"Codigo", {{"", "C", 6, 0, "Codigo", "@!", "TMP_COD"}}})

    //Cria o oBrowse normalmente
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasTmp)     //Passa o alias criado para a temporária
    oBrowse:SetTemporary(.T.)       //Indica que é temporária
    oBrowse:SetFields(aColunas)     //Seta as colunas criadas para a temporária
    oBrowse:DisableDetails()
    oBrowse:SetDescription(cTitulo) 
    oBrowse:SetSeek(.T., aPesquisa) //Adiciona a pesquisa criada para a temporária
    oBrowse:Activate()
    

    oTmpTable:Delete()
    FWRestArea(aArea)

Return Nil


Static Function ModelDef()

    Local oModel
    Local oStTmp := FWFormModelStruct():New()
    Local bPre      := Nil //Antes de abrir o formulário
    Local bPos      := Nil //Clicar em CONFIRMAR antes de salvar
    Local bCommit   := Nil //Após fechar o Formulário quando for salvar
    Local bCancel   := Nil //Ao clicar em CANCELAR

    //Define os campos da estrutura da temporária
    oStTmp:AddTable(cAliasTmp, {"TMP_COD", "TMP_DESC", "TMP_VLR", "TMP_DATA"}, "Temporária")

    //Adiciona os campos da temporária no modelo
    // [01]  C   Titulo do campo
    // [02]  C   ToolTip do campo
    // [03]  C   Id do Field
    // [04]  C   Tipo do campo
    // [05]  N   Tamanho do campo
    // [06]  N   Decimal do campo
    // [07]  B   Code-block de validação do campo
    // [08]  B   Code-block de validação When do campo
    // [09]  A   Lista de valores permitido do campo
    // [10]  L   Indica se o campo tem preenchimento obrigatório
    // [11]  B   Code-block de inicializacao do campo
    // [12]  L   Indica se trata-se de um campo chave
    // [13]  L   Indica se o campo pode receber valor em uma operação de update.
    // [14]  L   Indica se o campo é virtual
    oStTmp:AddField("Codigo","Codigo","TMP_COD","C",06,0,Nil,Nil,{},.T.,FwBuildFeature(STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, "+cAliasTmp+"->TMP_COD, '')"), .T., .F., .F.)
    oStTmp:AddField("Descricao","Descricao","TMP_DESC","C",50,0,Nil,Nil,{},.T.,FwBuildFeature(STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, "+cAliasTmp+"->TMP_DESC, '')"), .T., .F., .F.)
    oStTmp:AddField("Valor","Valor","TMP_VLR","N",10,0,Nil,Nil,{},.T.,FwBuildFeature(STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, "+cAliasTmp+"->TMP_VLR, '')"), .T., .F., .F.)
    oStTmp:AddField("Data","Data","TMP_DATA","D",08,0,Nil,Nil,{},.T.,FwBuildFeature(STRUCT_FEATURE_INIPAD, "Iif(!INCLUI, "+cAliasTmp+"->TMP_DATA, '')"), .T., .F., .F.)

    //Setando as propriedades do campo - Será alterada as propriedades do Modelo
    //Travando edição d
    oStTmp:SetProperty("TMP_DATA", MODEL_FIELD_WHEN, FwBuildFeature(STRUCT_FEATURE_WHEN, 'INCLUI'))
    oStTmp:SetProperty("TMP_DATA", MODEL_FIELD_INIT, FwBuildFeature(STRUCT_FEATURE_INIPAD, 'Date()'))

    oModel := MPFormModel():New("MVC_TIPM", bPre, bPos, bCommit, bCancel)
    oModel:AddFields("MVCMASTER",, oStTmp)
    oModel:SetDescription("Modelo " + cTitulo)
    oModel:GetModel("MVCMASTER"):SetDescription("Formulário" + cTitulo)
    oModel:SetPrimaryKey({"TMP_COD"})    

Return oModel

Static Function ViewDef()

    Local oModel := FWLoadModel("MVC_TIP")
    Local oStTmp := FWFormViewStruct():New()
    Local oView  := Nil

    //[01]  C   Nome do Campo
    //[02]  C   Ordem
    //[03]  C   Titulo do campo
    //[04]  C   Descricao do campo
    //[05]  A   Array com Help
    //[06]  C   Tipo do campo
    //[07]  C   Picture
    //[08]  B   Bloco de PictTre Var
    //[09]  C   Consulta F3
    //[10]  L   Indica se o campo é alteravel
    //[11]  C   Pasta do campo
    //[12]  C   Agrupamento do campo
    //[13]  A   Lista de valores permitido do campo (Combo)
    //[14]  N   Tamanho maximo da maior opção do combo
    //[15]  C   Inicializador de Browse
    //[16]  L   Indica se o campo é virtual
    //[17]  C   Picture Variavel
    //[18]  L   Indica pulo de linha após o campo
    oStTmp:AddField("TMP_COD","01","Codigo","Codigo",Nil,"C","@!",Nil,Nil,Iif(INCLUI, .T., .F.),Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil)
    oStTmp:AddField("TMP_DESC","02","Descricao","Descricao",Nil,"C","@!",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil)
    oStTmp:AddField("TMP_VLR","03","Valor","Valor",Nil,"N","@E 9,999,999.99",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil)
    oStTmp:AddField("TMP_DATA","04","Data","Data",Nil,"D","@D",Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil,Nil)

    //SetProperty também pode ser aplicado na ViewDef, será alterada as propriedades de visualização
    oStTmp:SetProperty("TMP_COD", MVC_VIEW_TITULO, "Data de inclusão")

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_MVC", oStTmp, "MVCMASTER")
    oView:CreateHorizontalBox("TELA", 100)
    oView:EnableTitleView("VIEW_MVC", "Dados - " + cTitulo)
    oView:SetCloseOnOk({||.T.})
    oView:SetOwnerView("VIEW_MVC", "TELA")

Return oView


Static Function MenuDef()

	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.MVC_TIP' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
    //ADD OPTION aRotina TITLE '*Copiar'    ACTION 'u_CopyReg' OPERATION 9 ACCESS 0 //OPERATION 5
    ADD OPTION aRotina TITLE 'Copiar'    ACTION 'VIEWDEF.MVC_TIP' OPERATION 9 ACCESS 0 //OPERATION 5

    //Caso deseje a inclusão de uma rotina personalizada, pode ser adicionado mais um botão à lista chamando a rotina personalizada, como no exemplo abaixo:
    //ADD OPTION aRotina TITLE 'Rotina Personalizada' ACTION 'MVC_TI_PREMIUM' OPERATION MODEL_OPERATION_CUSTOM ACCESS 0 //OPERATION 6

Return aRotina



// User Function CopyReg()

//     Local aArea := FWGetArea()
//     Local cTitulo := "Copy"
//     Local cProgram := "MVC_TIP"
//     Local nOp := MODEL_OPERATION_INSERT

//     lCopy := .T.

//     oModel := FWLoadModel(cProgram)
//     oModel:SetOperation(nOp)
//     oModel:Activate(.T.)

//     cNovoCod := GetSXENum(cAliasTmp, "TMP_COD")
//     ConfirmSX8()

//     oModel:SetValue("MVCMASTER", "TMP_COD", cNovoCod)
//     oModel:SetValue("MVCMASTER", "TMP_DESC", (cAliasTmp)->TMP_COD + " - Copy")
//     oModel:SetValue("MVCMASTER", "TMP_DATA", Date())

//     nRet := FWExecView(cTitulo, cProgram, nOp, /*oDlg*/, {||.T.}, /*bOk*/,/*nPercReducao*/,/*aEnableButtons*/,/*bCancel*/,/*cOperatId*/,/*cToolBar*/,oModel)
//     lCopy := .F.
//     oModel:DeActivate()

//     If nRet == 0
//         Alert("Ok!")
//     Endif

//     FWRestArea(aArea)

// Return

