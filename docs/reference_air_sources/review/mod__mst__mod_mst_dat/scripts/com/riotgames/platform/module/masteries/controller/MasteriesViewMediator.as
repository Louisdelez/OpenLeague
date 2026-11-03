package com.riotgames.platform.module.masteries.controller
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.module.masteries.interfaces.IMasteriesViewMediator;
   import com.riotgames.platform.module.masteries.views.MasteriesBookView;
   import com.riotgames.platform.module.masteries.views.MasteriesTreeView;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.rust.context.RustContext;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class MasteriesViewMediator implements IMasteriesViewMediator
   {
      
      private var _masteriesBookView:MasteriesBookView;
      
      private var parentAdapter:DisplayAdapter;
      
      private var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.talent.TalentGroupController");
      
      private var _playMusic:Boolean = true;
      
      private var _masteriesTreeView:MasteriesTreeView;
      
      private var _context:RustContext;
      
      private var _masteriesController:MasteriesController;
      
      public function MasteriesViewMediator(param1:MasteriesController, param2:RustContext)
      {
         super();
         this._masteriesController = param1;
         this._context = param2;
      }
      
      private function onClosePageAlertClosed(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this._masteriesController.saveChanges();
         }
         else
         {
            this._masteriesController.revertChanges();
         }
         this.closeView();
      }
      
      private function onCurrentPageChangeEvent(param1:MasteryEvent) : void
      {
         if(this._masteriesController.changeDisplayedPage(param1.id))
         {
            this.syncCurrentPageOnTreeView();
            if(this._masteriesController.isLocalSummoner)
            {
               this._masteriesController.silentlySaveChanges();
            }
         }
      }
      
      private function onRevertBookRequest(param1:MasteryEvent) : void
      {
         this._masteriesController.revertChanges();
         this._masteriesBookView.updateView();
         this.syncCurrentPageOnTreeView();
      }
      
      public function displayView(param1:DisplayAdapter, param2:Boolean = false) : void
      {
         this.closeView();
         this.parentAdapter = param1;
         this._playMusic = param2;
         this._masteriesTreeView = new MasteriesTreeView(this._context);
         this._masteriesTreeView.localSummoner = this._masteriesController.isLocalSummoner;
         this.syncCurrentPageOnTreeView();
         this._masteriesTreeView.addEventListener(MasteryEvent.MASTERY_CLICK,this.onMouseClickOnMastery);
         if(this._masteriesController.book.currentPage.getSpentPoints() == this._masteriesController.book.totalPointsToSpend)
         {
            this._masteriesTreeView.pageMaxedOut = true;
         }
         param1.addChild(this._masteriesTreeView);
         this._masteriesBookView = new MasteriesBookView(this._context);
         this._masteriesBookView.addEventListener(MasteryEvent.REVERT_BOOK_REQUEST,this.onRevertBookRequest);
         this._masteriesBookView.addEventListener(MasteryEvent.RETURN_POINTS_REQUEST,this.onReturnPointsRequest);
         this._masteriesBookView.addEventListener(MasteryEvent.SAVE_BOOK_REQUEST,this.onSaveBookRequest);
         this._masteriesBookView.addEventListener(MasteryEvent.CURRENT_PAGE_CHANGE_REQUEST,this.onCurrentPageChangeEvent);
         this._masteriesBookView.addEventListener(MasteryEvent.DELETE_PAGE_REQUEST,this.onDeletePageRequest);
         this._masteriesBookView.addEventListener(MasteryEvent.CREATE_PAGE_REQUEST,this.onCreatePageRequest);
         this._masteriesBookView.masteryBook = this._masteriesController.book;
         this._masteriesBookView.localSummoner = this._masteriesController.isLocalSummoner;
         param1.addChild(this._masteriesBookView);
      }
      
      private function onSaveBookRequest(param1:MasteryEvent) : void
      {
         this._masteriesController.saveChanges();
         this._masteriesBookView.updateView();
      }
      
      public function closeView(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.onCloseEditedViewRequest(null);
         }
         if(this._masteriesTreeView)
         {
            this.parentAdapter.removeChild(this._masteriesTreeView);
            this._masteriesTreeView.removeEventListener(MasteryEvent.MASTERY_CLICK,this.onMouseClickOnMastery);
            this._masteriesTreeView.destroy();
            this._masteriesTreeView = null;
         }
         if(this._masteriesBookView)
         {
            this.parentAdapter.removeChild(this._masteriesBookView);
            this._masteriesBookView.removeEventListener(MasteryEvent.REVERT_BOOK_REQUEST,this.onRevertBookRequest);
            this._masteriesBookView.removeEventListener(MasteryEvent.RETURN_POINTS_REQUEST,this.onReturnPointsRequest);
            this._masteriesBookView.removeEventListener(MasteryEvent.SAVE_BOOK_REQUEST,this.onSaveBookRequest);
            this._masteriesBookView.removeEventListener(MasteryEvent.CURRENT_PAGE_CHANGE_REQUEST,this.onCurrentPageChangeEvent);
            this._masteriesBookView.removeEventListener(MasteryEvent.DELETE_PAGE_REQUEST,this.onDeletePageRequest);
            this._masteriesBookView.removeEventListener(MasteryEvent.CREATE_PAGE_REQUEST,this.onCreatePageRequest);
            this._masteriesBookView.destroy();
            this._masteriesBookView = null;
         }
      }
      
      private function syncCurrentPageOnTreeView() : void
      {
         this._masteriesTreeView.masteryPage = this._masteriesController.book.currentPage;
         if(this._masteriesController.book.currentPage.getSpentPoints() == this._masteriesController.book.totalPointsToSpend)
         {
            this._masteriesTreeView.pageMaxedOut = true;
         }
         else
         {
            this._masteriesTreeView.pageMaxedOut = false;
         }
      }
      
      private function onCreatePageRequest(param1:MasteryEvent) : void
      {
         this._masteriesController.createNewPage();
         this._masteriesBookView.updateView();
         this.syncCurrentPageOnTreeView();
      }
      
      private function onReturnPointsRequest(param1:MasteryEvent) : void
      {
         this._masteriesController.returnPointsFromCurrentPage();
         this.syncCurrentPageOnTreeView();
      }
      
      private function onDeletePageAlertClosed(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this._masteriesController.deleteCurrentPage();
            this._masteriesBookView.updateView();
            this.syncCurrentPageOnTreeView();
         }
      }
      
      private function onMouseClickOnMastery(param1:MasteryEvent) : void
      {
         var _loc4_:ISoundProvider = null;
         var _loc2_:int = int(param1.delta);
         var _loc3_:String = "";
         if(_loc2_ != 0)
         {
            if(_loc2_ > 0)
            {
               _loc3_ = this._masteriesController.increaseTalentRank(param1.id);
            }
            else
            {
               if(_loc2_ >= 0)
               {
                  return;
               }
               _loc3_ = this._masteriesController.decreaseTalentRank(param1.id);
            }
            if(_loc3_ != MasteriesController.ERROR_REFUNDING_POINT || _loc3_ != MasteriesController.ERROR_SPENDING_POINT || _loc3_ != MasteriesController.MAX_POINTS_ALREADY_SPENT)
            {
               _loc4_ = SoundProviderProxy.instance;
               if(_loc3_ == MasteriesController.MAX_POINTS_NOW_SPENT || _loc3_ == MasteriesController.POINT_SPENT_SUCCESSFULLY)
               {
                  _loc4_.play(AudioKeys.MASTERIES_SOUND_ADD_POINT);
               }
               else if(_loc3_ == MasteriesController.POINT_RETURNED_SUCCESSFULLY)
               {
                  _loc4_.play(AudioKeys.MASTERIES_SOUND_REMOVE_POINT);
               }
               this.syncCurrentPageOnTreeView();
            }
         }
      }
      
      private function onCloseEditedViewRequest(param1:MasteryEvent) : void
      {
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getString("masteries_unsavedChangesPromptTitle","Save book?"),RiotResourceLoader.getString("masteries_unsavedChangesPrompt","Save book?"));
         _loc2_.showNegative = true;
         _loc2_.setYesNoLabels();
         _loc2_.getCompleted().addOnce(this.onClosePageAlertClosed);
         _loc2_.add();
      }
      
      private function onDeletePageRequest(param1:MasteryEvent) : void
      {
         var _loc2_:AlertAction = new AlertAction(RiotResourceLoader.getString("talentTree_deletePagePopupTitle","Delete page?"),RiotResourceLoader.getString("talentTree_deletePagePopupQuestion","Delete page?"));
         _loc2_.showNegative = true;
         _loc2_.setYesNoLabels();
         _loc2_.getCompleted().addOnce(this.onDeletePageAlertClosed);
         _loc2_.add();
      }
   }
}

