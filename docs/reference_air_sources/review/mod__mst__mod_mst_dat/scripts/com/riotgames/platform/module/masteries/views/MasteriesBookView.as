package com.riotgames.platform.module.masteries.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTip;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.ToolTipManager;
   import blix.components.tooltip.assignToolTip;
   import blix.components.tooltip.unassignToolTip;
   import blix.context.IContext;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.masteries.objects.MasteryBook;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import com.riotgames.platform.module.masteries.views.renderers.CreateMasteryPageButtonProxy;
   import com.riotgames.platform.module.masteries.views.renderers.MasteryPageSelectorButtonProxy;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import mx.events.CollectionEvent;
   
   public class MasteriesBookView extends SpriteProxy
   {
      
      private static const BASE_PAGE_BUTTON_X:int = 225;
      
      private static const BASE_PAGE_BUTTON_Y:int = 10;
      
      private static const PAGE_BUTTON_WIDTH:int = 33;
      
      private var _editIcon:SpriteProxy;
      
      private var _deletePageButton:ButtonX;
      
      private var defaultToolTipHandler:ToolTipHandler;
      
      private var bookChanged:Boolean = false;
      
      private var _utilityPointsSpentText:TextFieldProxy;
      
      private var _offensePointsSpentText:TextFieldProxy;
      
      private var titleEditModeChanged:Boolean = false;
      
      private var _pageButtons:Vector.<MasteryPageSelectorButtonProxy>;
      
      private var addButton:CreateMasteryPageButtonProxy;
      
      private var _revertMasteriesButton:ButtonX;
      
      private var _titleEditMode:Boolean = false;
      
      private var _saveMasteriesButton:ButtonX;
      
      private var _selectedButton:MasteryPageSelectorButtonProxy;
      
      private var _book:MasteryBook;
      
      private var _defensePointsSpentText:TextFieldProxy;
      
      private var _pointsSpentText:TextFieldProxy;
      
      private var _localSummoner:Boolean = true;
      
      private var _pageNameLabel:TextFieldProxy;
      
      private var _returnPointsButton:ButtonX;
      
      private var _pageNameEditSprite:StatefulView;
      
      private var _pageNameEditField:TextFieldProxy;
      
      public function MasteriesBookView(param1:IContext)
      {
         super(param1);
         setLinkage("MasteryBookView");
      }
      
      override public function destroy() : void
      {
         var _loc1_:MasteryPageSelectorButtonProxy = null;
         if(this._book)
         {
            this.removePageEventListeners();
            this._book.removeEventListener(MasteryEvent.CURRENT_PAGE_CHANGED,this.onDisplayedPageChanged);
         }
         unassignToolTip(this._pageNameEditSprite);
         unassignToolTip(this._saveMasteriesButton);
         unassignToolTip(this._returnPointsButton);
         unassignToolTip(this._deletePageButton);
         unassignToolTip(this._revertMasteriesButton);
         for each(_loc1_ in this._pageButtons)
         {
            this.removeChild(_loc1_);
            _loc1_.destroy();
         }
         super.destroy();
      }
      
      private function onReturnPointsButtonClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new MasteryEvent(MasteryEvent.RETURN_POINTS_REQUEST));
      }
      
      private function onDisplayedPageChanged(param1:MasteryEvent) : void
      {
         this.addPageEventListeners();
         this.updatePageButtonDisplays();
         this.updatePageNameDisplay();
         this.updatePointsSpentDisplays();
         this.updateButtonStates();
      }
      
      public function updateView() : void
      {
         this.updateButtonStates();
         this.updatePageButtonDisplays();
         this.updatePageNameDisplay();
         this.updatePointsSpentDisplays();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ToolTip = new ToolTip(this);
         _loc1_.setLinkage("assets.ToolTipAsset");
         this.defaultToolTipHandler.setView(_loc1_);
         this.defaultToolTipHandler.showDelay = 0;
         this._pointsSpentText = new TextFieldProxy(this);
         this.setTimelineChildByName("masteryPointsSpentText",this._pointsSpentText);
         this._offensePointsSpentText = new TextFieldProxy(this);
         this.setTimelineChildByName("offenseCountText",this._offensePointsSpentText);
         this._defensePointsSpentText = new TextFieldProxy(this);
         this.setTimelineChildByName("defenseCountText",this._defensePointsSpentText);
         this._utilityPointsSpentText = new TextFieldProxy(this);
         this.setTimelineChildByName("utilityCountText",this._utilityPointsSpentText);
         this._pageNameEditSprite = new StatefulView(this);
         this.setTimelineChildByName("pageNameEditSprite",this._pageNameEditSprite);
         this._pageNameLabel = new TextFieldProxy(this);
         this._pageNameEditSprite.setTimelineChildByName("masteryPageNameDisplayField",this._pageNameLabel);
         this._pageNameLabel.addEventListener(MouseEvent.MOUSE_DOWN,this.onPageNameClicked);
         this._pageNameEditField = new TextFieldProxy(this);
         this._pageNameEditSprite.setTimelineChildByName("masteryPageNameEditField",this._pageNameEditField);
         this._pageNameEditField.addEventListener(FocusEvent.FOCUS_OUT,this.onNameEditFieldFocusOut);
         this._pageNameEditField.addEventListener(KeyboardEvent.KEY_DOWN,this.onNameEditFieldKeyDown);
         assignToolTip(this._pageNameEditSprite,RiotResourceLoader.getString("nameEditFieldTooltip","Edit Page Name"));
         this._editIcon = new SpriteProxy(this);
         this._pageNameEditSprite.setTimelineChildByName("editIcon",this._editIcon);
         this._saveMasteriesButton = new ButtonX(this);
         this._returnPointsButton = new ButtonX(this);
         this._deletePageButton = new ButtonX(this);
         this._revertMasteriesButton = new ButtonX(this);
         this.setTimelineChildByName("saveMasteriesButton",this._saveMasteriesButton);
         this.setTimelineChildByName("returnMasteriesButton",this._returnPointsButton);
         this.setTimelineChildByName("deletePageButton",this._deletePageButton);
         this.setTimelineChildByName("revertChangesButton",this._revertMasteriesButton);
         assignToolTip(this._saveMasteriesButton,RiotResourceLoader.getString("saveMasteriesButtonTooltip","Create Page"));
         assignToolTip(this._returnPointsButton,RiotResourceLoader.getString("returnMasteriesButtonTooltip","Return Page"));
         assignToolTip(this._deletePageButton,RiotResourceLoader.getString("deleteMasteriesPageButtonTooltip","Delete Page"));
         assignToolTip(this._revertMasteriesButton,RiotResourceLoader.getString("revertMasteriesButtonTooltip","Revert Page"));
         this._saveMasteriesButton.addEventListener(MouseEvent.CLICK,this.onSaveBookButtonClicked);
         this._returnPointsButton.addEventListener(MouseEvent.CLICK,this.onReturnPointsButtonClicked);
         this._deletePageButton.addEventListener(MouseEvent.CLICK,this.onDeletePageButtonClicked);
         this._revertMasteriesButton.addEventListener(MouseEvent.CLICK,this.onRevertPageButtonClicked);
         this._pageButtons = new Vector.<MasteryPageSelectorButtonProxy>();
      }
      
      private function onNameEditFieldFocusOut(param1:FocusEvent) : void
      {
         this.endNameEditing();
      }
      
      private function updatePageNameDisplay() : void
      {
         var _loc1_:String = "";
         if(this._pageNameEditSprite.getCurrentState() == "active")
         {
            this.endNameEditing();
         }
         if(this._book.currentPage != null)
         {
            _loc1_ = MasteriesUtils.getLocalizedPageName(this._book.currentPage.name,this._book.currentPageIndex);
         }
         this._pageNameLabel.setText((this._book.currentPage.isDirty ? "*" : "") + _loc1_);
         this._pageNameEditField.setText(_loc1_);
         if(this._localSummoner)
         {
            assignToolTip(this._pageNameEditSprite,RiotResourceLoader.getString("nameEditFieldTooltip","Edit Page Name"));
            this._editIcon.setVisible(true);
         }
         else
         {
            assignToolTip(this._pageNameEditSprite,RiotResourceLoader.getString("nameEditFieldTooltipReadonly","Page Name"));
            this._editIcon.setVisible(false);
         }
      }
      
      private function onPageButtonPressed(param1:MouseEvent) : void
      {
         var _loc3_:MasteryEvent = null;
         this.removePageEventListeners();
         this.endNameEditing();
         var _loc2_:MasteryPageSelectorButtonProxy = param1.currentTarget as MasteryPageSelectorButtonProxy;
         if(_loc2_ != null)
         {
            _loc3_ = new MasteryEvent(MasteryEvent.CURRENT_PAGE_CHANGE_REQUEST,false,false,this._book.bookPages.getItemIndex(_loc2_.associatedPage));
         }
         this.dispatchEvent(_loc3_);
      }
      
      private function onSaveBookButtonClicked(param1:MouseEvent) : void
      {
         this.endNameEditing();
         this.dispatchEvent(new MasteryEvent(MasteryEvent.SAVE_BOOK_REQUEST));
      }
      
      private function onNameEditFieldKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.endNameEditing();
         }
      }
      
      private function onPageEntriesCollectionChange(param1:CollectionEvent) : void
      {
         this.updatePageNameDisplay();
         this.updatePointsSpentDisplays();
         this.updatePageButtonDisplays();
      }
      
      public function set localSummoner(param1:Boolean) : void
      {
         this._localSummoner = param1;
         this.updateView();
      }
      
      private function addPageEventListeners() : void
      {
         this._book.currentPage.addEventListener(MasteryEvent.PAGE_DIRTY_CHANGED,this.onPageIsDirtyChanged);
         this._book.currentPage.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
      }
      
      private function updateButtonStates() : void
      {
         if(this._localSummoner)
         {
            this._saveMasteriesButton.setVisible(true);
            this._revertMasteriesButton.setVisible(true);
            this._deletePageButton.setVisible(true);
            this._returnPointsButton.setVisible(true);
            this._saveMasteriesButton.setEnabled(this._book.isDirty);
            this._revertMasteriesButton.setEnabled(this._book.isDirty);
            if(this._book.bookPages.length == 1)
            {
               this._deletePageButton.setEnabled(false);
            }
            else
            {
               this._deletePageButton.setEnabled(true);
            }
         }
         else
         {
            this._saveMasteriesButton.setVisible(false);
            this._revertMasteriesButton.setVisible(false);
            this._deletePageButton.setVisible(false);
            this._returnPointsButton.setVisible(false);
         }
      }
      
      public function set masteryBook(param1:MasteryBook) : void
      {
         if(this._book)
         {
            this.removePageEventListeners();
            this._book.removeEventListener(MasteryEvent.CURRENT_PAGE_CHANGED,this.onDisplayedPageChanged);
         }
         this._book = param1;
         this.addPageEventListeners();
         this._book.addEventListener(MasteryEvent.CURRENT_PAGE_CHANGED,this.onDisplayedPageChanged);
         this.updateView();
      }
      
      private function endNameEditing() : void
      {
         this._pageNameEditSprite.setCurrentState("inactive");
         if(this._book.currentPage.name != this._pageNameEditField.getText())
         {
            this._book.currentPage.name = this._pageNameEditField.getText();
         }
         if(!this._book.currentPageNameIsUnique())
         {
            this._pageNameEditField.setText(" (" + this._pageNameEditField.getText() + String(this._book.currentPageIndex + 1) + ")");
            this._book.currentPage.name += " (" + String(this._book.currentPageIndex + 1) + ")";
         }
         this.updatePageNameDisplay();
      }
      
      private function onCreatePageButtonPressed(param1:MouseEvent) : void
      {
         var _loc3_:MasteryEvent = null;
         var _loc2_:CreateMasteryPageButtonProxy = param1.target as CreateMasteryPageButtonProxy;
         if(_loc2_ != null)
         {
            _loc3_ = new MasteryEvent(MasteryEvent.CREATE_PAGE_REQUEST,false,false);
            this.dispatchEvent(_loc3_);
         }
      }
      
      private function updatePointsSpentDisplays() : void
      {
         var _loc1_:int = int(this._book.totalPointsToSpend);
         var _loc2_:int = 0;
         if(this._book != null)
         {
            _loc1_ -= _loc2_ = int(MasteriesUtils.getSpentPointsInGroup(this._book.currentPage,1));
         }
         this._offensePointsSpentText.setText(_loc2_.toString());
         if(this._book != null)
         {
            _loc1_ -= _loc2_ = int(MasteriesUtils.getSpentPointsInGroup(this._book.currentPage,2));
         }
         this._defensePointsSpentText.setText(_loc2_.toString());
         if(this._book != null)
         {
            _loc1_ -= _loc2_ = int(MasteriesUtils.getSpentPointsInGroup(this._book.currentPage,3));
         }
         this._utilityPointsSpentText.setText(_loc2_.toString());
         if(this._localSummoner)
         {
            this._pointsSpentText.setVisible(true);
            this._pointsSpentText.setText(RiotResourceLoader.getString("talentTree_availablePointsLabel","points SPENT: {0}",[_loc1_.toString()]));
         }
         else
         {
            this._pointsSpentText.setVisible(false);
         }
      }
      
      private function removePageEventListeners() : void
      {
         this._book.currentPage.removeEventListener(MasteryEvent.PAGE_DIRTY_CHANGED,this.onPageIsDirtyChanged);
         this._book.currentPage.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
      }
      
      private function updatePageButtonDisplays() : void
      {
         var _loc1_:MasteryPageSelectorButtonProxy = null;
         var _loc2_:uint = 0;
         var _loc3_:MasteryPageSelectorButtonProxy = null;
         if(this._book == null || this._book.bookPages == null)
         {
            return;
         }
         for each(_loc1_ in this._pageButtons)
         {
            _loc1_.setSelected(false);
            this.removeChild(_loc1_);
         }
         _loc2_ = 0;
         while(_loc2_ < this._book.bookPages.length)
         {
            if(_loc2_ >= this._pageButtons.length)
            {
               _loc3_ = new MasteryPageSelectorButtonProxy(this);
               _loc3_.pageIndex = _loc2_;
               _loc3_.addEventListener(MouseEvent.CLICK,this.onPageButtonPressed);
               this._pageButtons[_loc2_] = _loc3_;
            }
            else
            {
               _loc3_ = this._pageButtons[_loc2_];
            }
            _loc3_.associatedPage = this._book.bookPages.getItemAt(_loc2_) as MasteryPage;
            if(this._book.currentPageIndex == _loc2_)
            {
               _loc3_.setSelected(true);
            }
            _loc3_.setX(BASE_PAGE_BUTTON_X + PAGE_BUTTON_WIDTH * _loc2_);
            _loc3_.setY(BASE_PAGE_BUTTON_Y);
            this.addChild(_loc3_);
            _loc2_++;
         }
         if(this.addButton == null)
         {
            this.addButton = new CreateMasteryPageButtonProxy(this);
            this.addButton.addEventListener(MouseEvent.CLICK,this.onCreatePageButtonPressed);
            this.addChild(this.addButton);
         }
         this.addButton.setX(BASE_PAGE_BUTTON_X + PAGE_BUTTON_WIDTH * this._book.bookPages.length);
         this.addButton.setY(BASE_PAGE_BUTTON_Y);
         if(this._book.bookPages.length < MasteryBook.maxMasteryPagesAllowed && this._localSummoner)
         {
            this.addButton.setVisible(true);
         }
         else
         {
            this.addButton.setVisible(false);
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.defaultToolTipHandler = new ToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this.defaultToolTipHandler);
         registerDependency(IToolTipManager,_loc1_,false);
      }
      
      private function onRevertPageButtonClicked(param1:MouseEvent) : void
      {
         this.endNameEditing();
         this.dispatchEvent(new MasteryEvent(MasteryEvent.REVERT_BOOK_REQUEST));
      }
      
      private function onPageNameClicked(param1:MouseEvent) : void
      {
         if(this._localSummoner)
         {
            this._pageNameEditSprite.setCurrentState("active");
            this._pageNameEditField.getAsset().stage.focus = this._pageNameEditField.getAsset() as TextField;
            this._pageNameEditField.setSelection(0,this._pageNameEditField.getText().length);
         }
      }
      
      private function onPageIsDirtyChanged(param1:MasteryEvent) : void
      {
         this.updateButtonStates();
         this.updatePageNameDisplay();
         this.updatePointsSpentDisplays();
      }
      
      private function onDeletePageButtonClicked(param1:MouseEvent) : void
      {
         this.dispatchEvent(new MasteryEvent(MasteryEvent.DELETE_PAGE_REQUEST));
      }
   }
}

