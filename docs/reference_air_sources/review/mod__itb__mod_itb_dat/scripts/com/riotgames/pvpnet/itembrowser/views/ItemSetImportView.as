package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.rust.components.text.InputTextFieldProxy;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.FileFilter;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   
   public class ItemSetImportView extends StatefulView
   {
      
      private static const VIEW_STATE_FIRST_VIEW:String = "firstView";
      
      private static const VIEW_STATE_EXPORT:String = "export";
      
      private static const VIEW_STATE_IMPORT:String = "import";
      
      private static const MODE_NONE:int = 0;
      
      private static const MODE_IMPORT:int = 1;
      
      private static const MODE_EXPORT:int = 2;
      
      private var _exportFileButton:LabelButtonX;
      
      private var _selectItemSetsView:ItemSetSelectItemSetsView;
      
      private var _mode:uint;
      
      private var _closeButton:LabelButtonX;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _importCodeText:InputTextFieldProxy;
      
      private var _titleText:TextFieldProxy;
      
      private var _confirmActionButton:LabelButtonX;
      
      private var _model:ItemSetsModel;
      
      private var _importFileButton:LabelButtonX;
      
      private var _selectSetsTitle:TextFieldProxy;
      
      private var _importFilePathButton:ButtonX;
      
      private var _itemSetPreviewer:ItemSetTabbedPagePreviewer;
      
      private var _copyExportCodeButton:LabelButtonX;
      
      private var _exportToFileLabel:TextFieldProxy;
      
      private var _importPathText:TextFieldProxy;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _importFile:File;
      
      private var _importCodeButton:LabelButtonX;
      
      private var _importFromFileLabel:TextFieldProxy;
      
      private var _scrollAreaSizer:SpriteProxy;
      
      public function ItemSetImportView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
         this._itemSetsController = getDependency(ItemSetsController);
         setCurrentState(VIEW_STATE_FIRST_VIEW);
      }
      
      override protected function createChildren() : void
      {
         this._titleText = new TextFieldProxy(this);
         setTimelineChildByName("titleText",this._titleText);
         this._titleText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importExportInfoTitle"));
         this._importCodeText = new InputTextFieldProxy(this);
         setTimelineChildByName("instructionsText",this._importCodeText);
         this._importCodeText.setText("");
         this._importCodeText.setHintText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInstructions"));
         this._importCodeText.addEventListener(Event.CHANGE,this.onImportTextChanged);
         this._importCodeButton = new LabelButtonX(this);
         setTimelineChildByName("importCodeButton",this._importCodeButton);
         this._importCodeButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importCodeButton"));
         this._importCodeButton.addEventListener(MouseEvent.CLICK,this.handleImportCodeButtonClicked);
         this._importFileButton = new LabelButtonX(this);
         setTimelineChildByName("importFileButton",this._importFileButton);
         this._importFileButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importFileButton"));
         this._importFileButton.addEventListener(MouseEvent.CLICK,this.handleImportFilePathButtonClicked);
         this._importFromFileLabel = new TextFieldProxy(this);
         setTimelineChildByName("importFromFileLabel",this._importFromFileLabel);
         this._importFromFileLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importFromFileLabel"));
         this._importFilePathButton = new ButtonX(this);
         setTimelineChildByName("importFilePathButton",this._importFilePathButton);
         this._importFilePathButton.addEventListener(MouseEvent.CLICK,this.handleImportFilePathButtonClicked);
         this._importPathText = new TextFieldProxy(this);
         setTimelineChildByName("importPathText",this._importPathText);
         this._importPathText.addEventListener(MouseEvent.CLICK,this.handleImportFilePathButtonClicked);
         this._exportFileButton = new LabelButtonX(this);
         setTimelineChildByName("exportFileButton",this._exportFileButton);
         this._exportFileButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportButton"));
         this._exportFileButton.addEventListener(MouseEvent.CLICK,this.handleExportFileButtonClicked);
         this._exportToFileLabel = new TextFieldProxy(this);
         setTimelineChildByName("exportToFileLabel",this._exportToFileLabel);
         this._exportToFileLabel.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportToFileLabel"));
         this._scrollAreaSizer = new SpriteProxy(this);
         setTimelineChildByName("scrollAreaSizer",this._scrollAreaSizer);
         this._closeButton = new LabelButtonX(this);
         setTimelineChildByName("closeButton",this._closeButton);
         this._closeButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_closeImportButton"));
         this._closeButton.addEventListener(MouseEvent.CLICK,this.handleCloseButtonClicked);
         this._selectItemSetsView = new ItemSetSelectItemSetsView(this);
         setTimelineChildByName("selectItemSetsView",this._selectItemSetsView);
         this._selectItemSetsView.getSelectedItemSetsChanged().add(this.handleSelectedItemSetsChanged);
         this._selectItemSetsView.getItemSetMouseDown().add(this.handleItemSetMouseDown);
         this._confirmActionButton = new LabelButtonX(this);
         setTimelineChildByName("confirmActionButton",this._confirmActionButton);
         this._confirmActionButton.setText("");
         this._confirmActionButton.addEventListener(MouseEvent.CLICK,this.handleConfirmButtonClicked);
         this._copyExportCodeButton = new LabelButtonX(this);
         setTimelineChildByName("copyExportCodeButton",this._copyExportCodeButton);
         this._copyExportCodeButton.setText(ResourceManager.getInstance().getString("itemBrowser","copyButton"));
         this._copyExportCodeButton.addEventListener(MouseEvent.CLICK,this.handleCopyExportCodeClicked);
         this._itemSetPreviewer = new ItemSetTabbedPagePreviewer(this);
         setTimelineChildByName("itemSetPagePreview",this._itemSetPreviewer);
         super.createChildren();
      }
      
      private function handleItemSetMouseDown(param1:ItemSet) : void
      {
         this._itemSetPreviewer.setItemSet(param1);
      }
      
      private function handleSelectedItemSetsChanged() : void
      {
         if(!this._selectItemSetsView.getSelectedItemSets())
         {
            return;
         }
         var _loc1_:int = int(this._selectItemSetsView.getSelectedItemSets().length);
         this._confirmActionButton.setEnabled(_loc1_ >= 1);
      }
      
      private function getItemSetsFromJSON(param1:String) : Vector.<ItemSet>
      {
         var _loc3_:ItemSet = null;
         var _loc2_:Vector.<ItemSet> = new Vector.<ItemSet>();
         if(param1.substr(0,1) == "{")
         {
            _loc3_ = this._itemSetsController.getItemSetFromJSON(param1);
            if(_loc3_)
            {
               _loc2_.push(this._itemSetsController.getItemSetFromJSON(param1));
            }
         }
         else if(param1.substr(0,1) == "[")
         {
            _loc2_ = this._itemSetsController.getMultipleItemSetsFromJSON(param1);
         }
         return _loc2_;
      }
      
      private function handleImportCodeButtonClicked(param1:MouseEvent = null) : void
      {
         this.importItemSetsFromJSON(this._importCodeText.getText());
      }
      
      private function onImportTextChanged(param1:Event) : void
      {
         var _loc2_:Vector.<ItemSet> = this.getItemSetsFromJSON(this._importCodeText.getText());
         if(_loc2_.length > 0)
         {
            this._importCodeButton.setEnabled(true);
         }
         else
         {
            this._importCodeButton.setEnabled(false);
         }
      }
      
      private function handleImportFileSelected(param1:Event) : void
      {
         var _loc2_:File = param1.target as File;
         if(Boolean(_loc2_) && Boolean(_loc2_.exists) && _loc2_.extension == "lolitemset")
         {
            this._importFile = _loc2_;
            this._importPathText.setText(this._importFile.nativePath);
            this.proceedWithFileImport();
         }
      }
      
      private function onExportFileSelected(param1:Event) : void
      {
         var _loc3_:AlertAction = null;
         var _loc2_:File = param1.target as File;
         var _loc4_:Array = _loc2_.nativePath.split(File.separator);
         var _loc5_:String = _loc4_.pop();
         _loc5_ = _loc5_.split(".")[0] + ".lolitemset";
         _loc4_.push(_loc5_);
         _loc2_ = new File("file:///" + _loc4_.join(File.separator));
         var _loc6_:Boolean = this._itemSetsController.writeItemSetsToFile(this._selectItemSetsView.getSelectedItemSets(),_loc2_);
         if(!_loc6_)
         {
            this.logger.error("0002 - failed to write file for single item set");
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportConfirmationTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_saveToFileFailure"));
            _loc3_.add();
         }
         else
         {
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_exportSuccess",[this._selectItemSetsView.getSelectedItemSets().length,_loc2_.nativePath]));
            _loc3_.add();
            setVisible(false);
         }
      }
      
      public function initializeView() : void
      {
         setCurrentState(VIEW_STATE_FIRST_VIEW);
         this._itemSetPreviewer.setItemSet(null);
         this._importCodeText.setText("");
         this._titleText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importExportInfoTitle"));
         this._importCodeButton.setEnabled(false);
         this._selectItemSetsView.setItemSets(null);
         this._copyExportCodeButton.setVisible(false);
         this._mode = MODE_NONE;
         this._importFile = null;
         this._importPathText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importPathDefaultText"));
      }
      
      private function handleExportFileButtonClicked(param1:Event = null) : void
      {
         this._mode = MODE_EXPORT;
         setCurrentState(VIEW_STATE_EXPORT);
         if(this._model.getItemSets().length > 0)
         {
            this._itemSetPreviewer.setItemSet(this._model.getItemSets()[0]);
         }
         this._selectItemSetsView.setItemSets(this._model.getItemSets());
         this._confirmActionButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportFileButton"));
         this._titleText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_exportInfoTitle"));
         this._copyExportCodeButton.setVisible(true);
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         if(this._model != param1)
         {
            this._model = param1;
            this._selectItemSetsView.setModel(this._model);
            this._itemSetPreviewer.setModel(this._model);
         }
      }
      
      private function handleCopyExportCodeClicked(param1:Event = null) : void
      {
         Clipboard.generalClipboard.clear();
         Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,this._itemSetsController.multipleItemSetsToJSON(this._selectItemSetsView.getSelectedItemSets()));
      }
      
      private function handleCloseButtonClicked(param1:MouseEvent = null) : void
      {
         setVisible(false);
      }
      
      private function proceedWithFileImport(param1:Event = null) : void
      {
         var alertAction:AlertAction = null;
         var itemSetJSON:String = null;
         var fileStream:FileStream = null;
         var e:Event = param1;
         if(Boolean(this._importFile) && Boolean(this._importFile.exists) && this._importFile.extension == "lolitemset")
         {
            try
            {
               fileStream = new FileStream();
               fileStream.open(this._importFile,FileMode.READ);
               itemSetJSON = fileStream.readMultiByte(fileStream.bytesAvailable,"utf-8");
            }
            catch(error:Error)
            {
               logger.error("0005 - Error when opening file for item set import: " + error.message);
               alertAction = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_importedFailedOnFile"));
               alertAction.add();
            }
            this.importItemSetsFromJSON(itemSetJSON);
         }
      }
      
      private function handleImportFilePathButtonClicked(param1:Event = null) : void
      {
         var file:File = null;
         var fileFilter:FileFilter = null;
         var e:Event = param1;
         try
         {
            file = File.desktopDirectory;
            fileFilter = new FileFilter(ResourceManager.getInstance().getString("itemBrowser","itemSets_selectOpenFileDescription"),"*.lolitemset");
            file.addEventListener(Event.SELECT,this.handleImportFileSelected);
            file.browseForOpen(ResourceManager.getInstance().getString("itemBrowser","itemSets_selectOpenFile"),[fileFilter]);
         }
         catch(error:Error)
         {
            logger.error("0003 - failed to open browse for open dialogue: " + error.message);
         }
      }
      
      private function importItemSetsFromJSON(param1:String) : void
      {
         var _loc3_:AlertAction = null;
         var _loc2_:Vector.<ItemSet> = new Vector.<ItemSet>();
         if(param1.substr(0,1) != "{" && param1.substr(0,1) != "[")
         {
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_importFailed"));
            _loc3_.add();
            this.logger.error("0004 - Imported data for item sets wasn\'t valid");
            return;
         }
         _loc2_ = this.getItemSetsFromJSON(param1);
         if(_loc2_.length != 0)
         {
            setCurrentState(VIEW_STATE_IMPORT);
            this._itemSetPreviewer.setItemSet(_loc2_[0]);
            this._selectItemSetsView.setItemSets(_loc2_);
            this._confirmActionButton.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importButton"));
            this._titleText.setText(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInfoTitle"));
            this._mode = MODE_IMPORT;
         }
         else
         {
            this.logger.error("0006 - No item sets were found after import");
            _loc3_ = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_importFailed"));
            _loc3_.add();
         }
      }
      
      private function handleConfirmButtonClicked(param1:Event = null) : void
      {
         var file:File = null;
         var itemSetsToImport:Vector.<ItemSet> = null;
         var itemSet:ItemSet = null;
         var alertAction:AlertAction = null;
         var e:Event = param1;
         if(this._mode == MODE_EXPORT)
         {
            try
            {
               file = File.desktopDirectory;
               file.addEventListener(Event.SELECT,this.onExportFileSelected);
               file.browseForSave(ResourceManager.getInstance().getString("itemBrowser","itemSets_selectSaveLocation"));
            }
            catch(error:Error)
            {
               logger.error("0001 - failed to open \'browse for save\' dialogue: " + error.message);
            }
         }
         else if(this._mode == MODE_IMPORT)
         {
            itemSetsToImport = this._selectItemSetsView.getSelectedItemSets();
            for each(itemSet in itemSetsToImport)
            {
               this._itemSetsController.addExistingItemPage(itemSet);
            }
            alertAction = new AlertAction(ResourceManager.getInstance().getString("itemBrowser","itemSets_importInfoTitle"),ResourceManager.getInstance().getString("itemBrowser","itemSets_importSuccess",[itemSetsToImport.length]));
            alertAction.add();
            setVisible(false);
         }
      }
   }
}

