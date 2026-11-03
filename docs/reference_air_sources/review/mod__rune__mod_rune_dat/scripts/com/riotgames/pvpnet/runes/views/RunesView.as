package com.riotgames.pvpnet.runes.views
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.pvpnet.runes.controller.RuneConfigurationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RuneCombinerViewController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesTransportationController;
   import com.riotgames.pvpnet.runes.viewcontroller.RunesViewController;
   import com.riotgames.pvpnet.runes.views.combiner.RuneCombinerView;
   import com.riotgames.pvpnet.runes.views.common.RunePageList;
   import com.riotgames.pvpnet.runes.views.runesbook.RunePaginationArea;
   import com.riotgames.pvpnet.runes.views.runesbook.RunesBookView;
   import com.riotgames.pvpnet.runes.views.runespage.RuneStatisticsView;
   import com.riotgames.pvpnet.runes.views.runespage.RunesPageView;
   import com.riotgames.pvpnet.tracking.trackers.runes.IRunesTracker;
   import com.riotgames.rust.context.popup.IPopupContext;
   import com.riotgames.rust.context.popup.SimplePopupContextBehavior;
   import com.riotgames.rust.data.ListAdapter;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class RunesView extends StatefulView implements IPopupContext
   {
      
      private var runesBookView:RunesBookView;
      
      private var runesPageView:RunesPageView;
      
      private var runeCombiner:RuneCombinerView;
      
      private var errorLabel:ToolTip;
      
      private var pageNameEditSprite:StatefulView;
      
      private var pageNameEditField:TextFieldProxy;
      
      private var pageNameLabel:TextFieldProxy;
      
      private var popupBehavior:SimplePopupContextBehavior;
      
      private var revertButton:ButtonX;
      
      private var clearButton:ButtonX;
      
      private var saveButton:ButtonX;
      
      private var combinerButton:ButtonX;
      
      private var statisticsView:RuneStatisticsView;
      
      private var paginationArea:RunePaginationArea;
      
      private var _runePageList:RunePageList;
      
      private var runeBookController:IRuneBookController;
      
      private var runesViewController:RunesViewController;
      
      private var runeCombinerViewController:RuneCombinerViewController;
      
      private var runesTracker:IRunesTracker;
      
      private var runeConfigController:RuneConfigurationController;
      
      private var _alertChangedFocus:Boolean = false;
      
      private var runesTransportationController:RunesTransportationController;
      
      private var rM:IResourceManager = ResourceManager.getInstance();
      
      private var toolTipManager:IToolTipManager;
      
      private var _runesTracker:IRunesTracker;
      
      private var soundProvider:ISoundProvider;
      
      public function RunesView(param1:IContext)
      {
         super(param1);
         setCurrentState("normal");
         setLinkage(this.runeConfigController.getRunesViewLinkage());
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this.popupBehavior = new SimplePopupContextBehavior(this);
         this.runesViewController = getDependency(RunesViewController);
         this.toolTipManager = getDependency(IToolTipManager);
         this.runesTracker = getDependency(IRunesTracker);
         this.runeCombinerViewController = getDependency(RuneCombinerViewController);
         this.runeBookController = getDependency(IRuneBookController);
         this._runesTracker = getDependency(IRunesTracker);
         this.runesTransportationController = getDependency(RunesTransportationController);
         this.runeConfigController = getDependency(RuneConfigurationController);
         this.soundProvider = getDependency(ISoundProvider);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.runesBookView = new RunesBookView(this);
         setTimelineChildByName("runesBook",this.runesBookView);
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("runesPageHolder",_loc1_);
         this.runesPageView = new RunesPageView(this);
         _loc1_.addChild(this.runesPageView);
         var _loc2_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("runeCombinerHolder",_loc2_);
         this.statisticsView = new RuneStatisticsView(this);
         setTimelineChildByName("statisticsView",this.statisticsView);
         this.runeCombiner = new RuneCombinerView(this);
         _loc2_.addChild(this.runeCombiner);
         if(this.runeConfigController.isLegacyStyle())
         {
            this.paginationArea = new RunePaginationArea(this);
            setTimelineChildByName("runesPaginationArea",this.paginationArea);
            this.handleRuneBookChanged();
         }
         else if(this.runeConfigController.isIronStyle())
         {
            this._runePageList = new RunePageList(this);
            setTimelineChildByName("runePageList",this._runePageList);
         }
         this.clearButton = new ButtonX(this);
         this.clearButton.addEventListener(MouseEvent.CLICK,this.onClearClick);
         assignToolTip(this.clearButton,this.rM.getString("resources","runebook_book_clearPageButton_tooltip"));
         setTimelineChildByName("clearButton",this.clearButton);
         this.saveButton = new ButtonX(this);
         this.saveButton.addEventListener(MouseEvent.CLICK,this.onSaveClick);
         assignToolTip(this.saveButton,this.rM.getString("resources","runebook_book_saveBookButton_tooltip"));
         this.saveButton.setEnabled(false);
         setTimelineChildByName("saveButton",this.saveButton);
         this.revertButton = new ButtonX(this);
         this.revertButton.addEventListener(MouseEvent.CLICK,this.onRevertClick);
         assignToolTip(this.revertButton,this.rM.getString("resources","runebook_book_undoChangesButton_tooltip"));
         this.revertButton.setEnabled(false);
         setTimelineChildByName("revertButton",this.revertButton);
         this.combinerButton = new ButtonX(this);
         this.combinerButton.addEventListener(MouseEvent.CLICK,this.onCombineClick);
         this.setRuneCombinerButtonTooltip();
         setTimelineChildByName("combinerButton",this.combinerButton);
         this.pageNameEditSprite = new StatefulView(this);
         setTimelineChildByName("pageNameEditSprite",this.pageNameEditSprite);
         this.pageNameLabel = new TextFieldProxy(this);
         this.pageNameEditSprite.setTimelineChildByName("runePageNameLabel",this.pageNameLabel);
         this.pageNameLabel.addEventListener(MouseEvent.CLICK,this.onPageNameClicked);
         this.pageNameEditField = new TextFieldProxy(this);
         this.pageNameEditSprite.setTimelineChildByName("runePageNameEditField",this.pageNameEditField);
         this.pageNameEditField.addEventListener(FocusEvent.FOCUS_OUT,this.onNameEditFieldFocusOut);
         this.pageNameEditField.addEventListener(KeyboardEvent.KEY_DOWN,this.onNameEditFieldKeyDown);
         this.errorLabel = new ToolTip(this);
         this.errorLabel.setVisible(false);
         this.pageNameEditSprite.setTimelineChildByName("errorLabel",this.errorLabel);
         this.runesViewController.getSummonerChanged().add(this.handleSummonerChanged);
         this.runesViewController.getRuneBookRetrieved().add(this.handleRuneBookChanged);
         this.runesViewController.getHasUnsavedChangesChanged().add(this.onHasUnsavedChangesChanged);
         this.runesViewController.getCurrentRuneBookPageChanged().add(this.onCurrentRuneBookPageChanged);
         this.runesViewController.getViewIsHiddenChanged().add(this.onViewIsHiddenChanged);
         this.runeCombinerViewController.getRuneCombinerViewActiveChanged().add(this.onRuneCombinerActiveChanged);
         this.runeCombinerViewController.getCombinerButtonEnabledChanged().add(this.combinerButton.setEnabled);
         this.handleSummonerChanged();
         this.handleRuneBookChanged();
         this.onCurrentRuneBookPageChanged();
      }
      
      private function onViewIsHiddenChanged(param1:Boolean) : void
      {
         if(!param1)
         {
            this.errorLabel.setVisible(false);
            this.pageNameEditSprite.setCurrentState("inactive");
            this.updateNameDisplay();
         }
      }
      
      private function onNameEditFieldFocusOut(param1:FocusEvent) : void
      {
         if(!this._alertChangedFocus)
         {
            this.endNameEditing();
         }
      }
      
      private function onNameEditFieldKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.endNameEditing();
         }
      }
      
      private function endNameEditing() : void
      {
         var _loc1_:String = this.pageNameEditField.getText();
         if(this.runesViewController.getCurrentRuneBookPage().name == _loc1_)
         {
            this.pageNameEditSprite.setCurrentState("inactive");
            return;
         }
         var _loc2_:String = this.runeBookController.validateSpellBookName(_loc1_);
         if(_loc2_ != null)
         {
            this.errorLabel.setVisible(true);
            this.errorLabel.setData(_loc2_);
            this.setEditActive();
         }
         else
         {
            this.errorLabel.setVisible(false);
            this.pageNameEditSprite.setCurrentState("inactive");
            this.runesViewController.getCurrentRuneBookPage().name = _loc1_;
            this.runesViewController.setHasUnsavedChanges(true);
            this._runesTracker.incrementRunes_PageRenamed_Count_InASession();
         }
      }
      
      private function updateNameDisplay() : void
      {
         if(this.runesViewController.getCurrentRuneBookPage() == null)
         {
            return;
         }
         var _loc1_:String = this.runesViewController.getCurrentRuneBookPage().name;
         var _loc2_:String = this.runesViewController.getHasUnsavedChanges() ? "*" : "";
         this.pageNameLabel.setText(_loc1_ + _loc2_);
         this.pageNameEditField.setText(_loc1_);
      }
      
      private function onPageNameClicked(param1:MouseEvent) : void
      {
         if(this.runesViewController.isLocalSummoner())
         {
            this.setEditActive();
         }
      }
      
      private function setEditActive() : void
      {
         this._alertChangedFocus = false;
         this.pageNameEditSprite.setCurrentState("active");
         this.pageNameEditField.getAsset().stage.focus = this.pageNameEditField.getAsset() as TextField;
         this.pageNameEditField.setSelection(0,this.pageNameEditField.getText().length);
      }
      
      private function onCombineClick(param1:MouseEvent) : void
      {
         this.soundProvider.play(AudioKeys.SOUND_MOUSE_DOWN);
         this.runeCombinerViewController.setRuneCombinerViewActive(!this.runeCombinerViewController.getRuneCombinerViewActive());
      }
      
      private function onRuneCombinerActiveChanged(param1:Boolean) : void
      {
         if(param1)
         {
            this.runesTracker.incrementRunes_CombinerOpened_Count_InASession();
            this.runesPageView.setCurrentState("combining");
            setCurrentState("combining");
            this.runeCombinerViewController.startCombine();
         }
         else
         {
            this.runesPageView.setCurrentState("normal");
            setCurrentState("normal");
            this.runeCombinerViewController.endCombine();
         }
         this.setRuneCombinerButtonTooltip();
      }
      
      private function setRuneCombinerButtonTooltip() : void
      {
         if(this.runeBookController.combining)
         {
            assignToolTip(this.combinerButton,this.rM.getString("resources","runebook_runeInventory_runeBookButton_tooltip"));
         }
         else
         {
            assignToolTip(this.combinerButton,this.rM.getString("resources","runebook_runeInventory_runeCombinerButton_tooltip"));
         }
      }
      
      private function handleSummonerChanged() : void
      {
         this.saveButton.setVisible(this.runesViewController.isLocalSummoner());
         this.revertButton.setVisible(this.runesViewController.isLocalSummoner());
         this.clearButton.setVisible(this.runesViewController.isLocalSummoner());
         this.runesBookView.setVisible(this.runesViewController.isLocalSummoner());
      }
      
      private function onHasUnsavedChangesChanged(param1:Boolean) : void
      {
         this.revertButton.setEnabled(param1);
         this.saveButton.setEnabled(param1);
         this.updateNameDisplay();
      }
      
      private function handleRuneBookChanged() : void
      {
         if(this.paginationArea != null && this.runeBookController.runeBook != null)
         {
            this.paginationArea.setDataProvider(new ListAdapter(this.runeBookController.runeBook.bookPages));
         }
      }
      
      private function onSaveClick(param1:MouseEvent) : void
      {
         this.soundProvider.play(AudioKeys.SOUND_MOUSE_DOWN);
         this._runesTracker.incrementRunes_SaveClicked_Count_InASession();
         this.runesViewController.save();
      }
      
      private function onRevertClick(param1:MouseEvent) : void
      {
         this.soundProvider.play(AudioKeys.SOUND_MOUSE_DOWN);
         this._runesTracker.incrementRunes_RevertClicked_Count_InASession();
         this.runesViewController.revert();
      }
      
      private function onClearClick(param1:MouseEvent) : void
      {
         this.soundProvider.play(AudioKeys.SOUND_MOUSE_DOWN);
         this._runesTracker.incrementRunes_ClearClicked_Count_InASession();
         this.runesTransportationController.clearPage();
      }
      
      private function onCurrentRuneBookPageChanged() : void
      {
         this.updateNameDisplay();
         if(this.runesViewController.getCurrentRuneBookPage() != null)
         {
            this.statisticsView.setDataProvider(new ListAdapter(this.runesViewController.getCurrentRuneBookPage().getCombinedStats()));
         }
      }
      
      public function addPopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.addPopup(param1);
      }
      
      public function removePopup(param1:IDisplayChild) : void
      {
         this.popupBehavior.removePopup(param1);
      }
      
      public function setPosition(param1:DisplayObjectProxy, param2:DisplayObjectProxy, param3:int, param4:int) : void
      {
         this.popupBehavior.setPosition(param1,param2,param3,param4);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.runesViewController.getSummonerChanged().remove(this.handleSummonerChanged);
         this.runesViewController.getRuneBookRetrieved().remove(this.handleRuneBookChanged);
         this.runesViewController.getHasUnsavedChangesChanged().remove(this.onHasUnsavedChangesChanged);
         this.runesViewController.getCurrentRuneBookPageChanged().remove(this.onCurrentRuneBookPageChanged);
         this.runeCombinerViewController.getRuneCombinerViewActiveChanged().remove(this.onRuneCombinerActiveChanged);
         this.runeCombinerViewController.getCombinerButtonEnabledChanged().remove(this.combinerButton.setEnabled);
      }
   }
}

