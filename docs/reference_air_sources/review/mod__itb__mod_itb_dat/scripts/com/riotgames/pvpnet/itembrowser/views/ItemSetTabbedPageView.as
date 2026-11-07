package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.button.RadioButtonGroupX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import com.riotgames.rust.focus.RiotFocusManager;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.ui.Keyboard;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class ItemSetTabbedPageView extends StatefulView
   {
      
      private static const STATE_PAGE_BUILD:String = "pageBuild";
      
      private static const STATE_PAGE_ASSOCIATIONS:String = "pageAssociations";
      
      private static const STATE_NO_ITEM_SETS:String = "noItemSet";
      
      private static const STATE_PAGE_EXPORT:String = "pageExport";
      
      private var _showCodeButton:LabelButtonX;
      
      private var _pageTitle:InputTextFieldProxy;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _shareTab:LabelButtonX;
      
      private var _codeBackground:SpriteProxy;
      
      private var _viewBuildButton:LabelButtonX;
      
      private var _exportToFileButton:LabelButtonX;
      
      private var _model:ItemSetsModel;
      
      private var _currentItemSet:ItemSet;
      
      private var _associationsView:ItemSetAssociationManagementView;
      
      private var _itemSetJSONText:TextFieldProxy;
      
      private var _tabGroup:RadioButtonGroupX;
      
      private var _noItemSetsText:TextFieldProxy;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _pageBuildView:ItemSetPageBuildView;
      
      private var _viewPropertiesButton:LabelButtonX;
      
      private var _exportInfoText:TextFieldProxy;
      
      private var _lastItemSetViewState:String = "pageBuild";
      
      private var _exportButton:LabelButtonX;
      
      public function ItemSetTabbedPageView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
      }
      
      override public function destroy() : void
      {
         this.removeModelListeners();
         this.removeActiveItemSetListeners();
         super.destroy();
      }
      
      private function handleItemSetTitleChanged() : void
      {
         this._pageTitle.setText(this._currentItemSet.title);
      }
      
      private function stopEditingPageName() : void
      {
         RiotFocusManager.setFocus(this);
         this._itemSetsController.changePageTitle(this._pageTitle.getText());
         this._pageTitle.removeEventListener(FocusEvent.FOCUS_OUT,this.handleEditFocusOut);
         this._pageTitle.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleEditKeyDown);
      }
      
      override protected function createChildren() : void
      {
         setCurrentState(STATE_NO_ITEM_SETS);
         this._tabGroup = new RadioButtonGroupX();
         this._pageBuildView = new ItemSetPageBuildView(this);
         setTimelineChildByName("pageBuildView",this._pageBuildView);
         this._associationsView = new ItemSetAssociationManagementView(this);
         setTimelineChildByName("associationsView",this._associationsView);
         this._pageTitle = new InputTextFieldProxy(this);
         setTimelineChildByName("pageTitle",this._pageTitle);
         this._pageTitle.addEventListener(FocusEvent.FOCUS_IN,this.startEditingPageName);
         assignToolTip(this._pageTitle,ResourceManager.getInstance().getString("itemBrowser","editButtonTooltip"));
         this._viewBuildButton = new LabelButtonX(this);
         setTimelineChildByName("viewBuildButton",this._viewBuildButton);
         this._viewBuildButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_buildTab"));
         assignToolTip(this._viewBuildButton,ResourceManager.getInstance().getString("itemBrowser","buildTabTooltip"));
         this._tabGroup.addRadioButton(this._viewBuildButton);
         this._viewPropertiesButton = new LabelButtonX(this);
         setTimelineChildByName("viewPropertiesButton",this._viewPropertiesButton);
         this._viewPropertiesButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_propertiesTab"));
         assignToolTip(this._viewPropertiesButton,ResourceManager.getInstance().getString("itemBrowser","associationTabTooltip"));
         this._tabGroup.addRadioButton(this._viewPropertiesButton);
         this._shareTab = new LabelButtonX(this);
         setTimelineChildByName("shareTab",this._shareTab);
         this._shareTab.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_shareTab"));
         assignToolTip(this._shareTab,ResourceManager.getInstance().getString("itemBrowser","shareTabTooltip"));
         if(ClientConfig.instance.showItemSetSharing)
         {
            this._tabGroup.addRadioButton(this._shareTab);
         }
         else
         {
            this._shareTab.setVisible(false);
         }
         this._noItemSetsText = new TextFieldProxy(this);
         setTimelineChildByName("noItemSetText",this._noItemSetsText);
         this._noItemSetsText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_noPageInfo"));
         this._exportInfoText = new TextFieldProxy(this);
         setTimelineChildByName("exportInstructionText",this._exportInfoText);
         this._exportInfoText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportInfo"));
         this._exportButton = new LabelButtonX(this);
         setTimelineChildByName("exportButton",this._exportButton);
         this._exportButton.setText(ResourceManager.getInstance().getString("itemBrowser","copyButton"));
         this._exportButton.addEventListener(MouseEvent.CLICK,this.handleExportButtonClicked);
         this._exportToFileButton = new LabelButtonX(this);
         setTimelineChildByName("exportToFileButton",this._exportToFileButton);
         this._exportToFileButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportToFileButton"));
         this._exportToFileButton.addEventListener(MouseEvent.CLICK,this.handleExportToFileButtonClicked);
         this._showCodeButton = new LabelButtonX(this);
         setTimelineChildByName("showCodeButton",this._showCodeButton);
         this._showCodeButton.setText(ResourceManager.getInstance().getString("itemBrowser","showCodeButton"));
         this._showCodeButton.addEventListener(MouseEvent.CLICK,this.handleShowCodeButtonClicked);
         this._codeBackground = new SpriteProxy(this);
         setTimelineChildByName("codeBackground",this._codeBackground);
         this._codeBackground.setVisible(false);
         this._itemSetJSONText = new TextFieldProxy(this);
         setTimelineChildByName("itemSetExportJSON",this._itemSetJSONText);
         this._itemSetJSONText.setText("");
         this._itemSetJSONText.addEventListener(FocusEvent.FOCUS_IN,this.handleItemSetTextFocus);
         this._itemSetJSONText.setVisible(false);
         this._tabGroup.setSelectedButton(this._viewBuildButton);
         this._tabGroup.getSelectedButtonChanged().add(this.handleSelectedTabChanged);
         super.createChildren();
      }
      
      private function addModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().add(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleExportToFileButtonClicked(param1:Event = null) : void
      {
         var file:File = null;
         var e:Event = param1;
         try
         {
            file = File.desktopDirectory;
            file.addEventListener(Event.SELECT,this.onFileSelected);
            file.browseForSave(ResourceManager.getInstance().getString("itemBrowser","itemSets_selectSaveLocation"));
         }
         catch(error:Error)
         {
            logger.error("0003 failed to open \'browse for save\' dialogue: " + error.message);
         }
      }
      
      private function startEditingPageName(param1:Event = null) : void
      {
         this._pageTitle.addEventListener(FocusEvent.FOCUS_OUT,this.handleEditFocusOut);
         this._pageTitle.addEventListener(KeyboardEvent.KEY_DOWN,this.handleEditKeyDown);
      }
      
      private function onFileSelected(param1:Event) : void
      {
         var _loc3_:AlertAction = null;
         var _loc2_:File = param1.target as File;
         var _loc4_:Array = _loc2_.nativePath.split(File.separator);
         var _loc5_:String = _loc4_.pop();
         _loc5_ = _loc5_.split(".")[0] + ".lolitemset";
         _loc4_.push(_loc5_);
         _loc2_ = new File("file:///" + _loc4_.join(File.separator));
         var _loc6_:Boolean = this._itemSetsController.writeActiveItemSetToFile(_loc2_);
         if(!_loc6_)
         {
            this.logger.error("0002 failed to write file for single item set");
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportConfirmationTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_saveToFileFailure"));
            _loc3_.add();
         }
         else
         {
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_exportSuccess",[1,_loc2_.nativePath]));
            _loc3_.add();
         }
      }
      
      private function removeModelListeners() : void
      {
         if(this._model)
         {
            this._model.getActiveItemSetChanged().remove(this.handleActiveItemSetChanged);
         }
      }
      
      private function handleSelectedTabChanged() : void
      {
         var _loc1_:ButtonX = this._tabGroup.getSelectedButton();
         if(_loc1_ == this._viewPropertiesButton)
         {
            setCurrentState(STATE_PAGE_ASSOCIATIONS);
         }
         else if(_loc1_ == this._shareTab)
         {
            setCurrentState(STATE_PAGE_EXPORT);
            this.updateItemSetJSONText();
         }
         else
         {
            setCurrentState(STATE_PAGE_BUILD);
         }
      }
      
      private function handleEditFocusOut(param1:Event) : void
      {
         this.stopEditingPageName();
      }
      
      private function selectAllText() : void
      {
         this._itemSetJSONText.setSelection(0,int.MAX_VALUE);
      }
      
      private function handleActiveItemSetChanged() : void
      {
         this.removeActiveItemSetListeners();
         this._currentItemSet = this._model ? this._model.getActiveItemSet() : null;
         this.addActiveItemSetListeners();
         if(this._currentItemSet)
         {
            this._pageTitle.setText(this._currentItemSet.title);
            if(getCurrentState() == STATE_NO_ITEM_SETS)
            {
               this.handleSelectedTabChanged();
            }
            this.updateItemSetJSONText();
         }
         else
         {
            setCurrentState(STATE_NO_ITEM_SETS);
            this._pageTitle.setText("");
         }
      }
      
      private function addActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getTitleChanged().add(this.handleItemSetTitleChanged);
         }
      }
      
      private function handleShowCodeButtonClicked(param1:Event = null) : void
      {
         if(this._codeBackground.getVisible())
         {
            this._itemSetJSONText.setVisible(false);
            this._codeBackground.setVisible(false);
            this._showCodeButton.setText(ResourceManager.getInstance().getString("itemBrowser","showCodeButton"));
         }
         else
         {
            this._itemSetJSONText.setVisible(true);
            this._codeBackground.setVisible(true);
            this._showCodeButton.setText(ResourceManager.getInstance().getString("itemBrowser","hideCodeButton"));
         }
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(param1 != this._model)
         {
            if(this._model)
            {
               this.removeModelListeners();
            }
            this._model = param1;
            this._pageBuildView.setModel(this._model);
            this._associationsView.setModel(this._model);
            if(this._model)
            {
               this.addModelListeners();
               this.handleActiveItemSetChanged();
            }
         }
      }
      
      private function handleItemSetTextFocus(param1:Event = null) : void
      {
         setTimeout(this.selectAllText,1);
      }
      
      private function handleEditKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.stopEditingPageName();
         }
      }
      
      private function handleExportButtonClicked(param1:Event = null) : void
      {
         if(!this._model || !this._model.getActiveItemSet())
         {
            return;
         }
         this._itemSetsController.sendActiveItemSetJsonToClipboard();
      }
      
      private function removeActiveItemSetListeners() : void
      {
         if(this._currentItemSet)
         {
            this._currentItemSet.getTitleChanged().remove(this.handleItemSetTitleChanged);
         }
      }
      
      private function updateItemSetJSONText() : void
      {
         this._itemSetJSONText.setText(this._itemSetsController.getJSONForActiveItemSet());
      }
   }
}

