package com.riotgames.platform.module.masteries.controller
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.Context;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.MasteryBookDTO;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import com.riotgames.platform.gameclient.masteries.TalentEntry;
   import com.riotgames.platform.gameclient.masteries.TalentRow;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.masteries.objects.MasteryBook;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import com.riotgames.platform.module.masteries.interfaces.IMasteriesViewMediator;
   import com.riotgames.platform.module.masteries.views.renderers.tooltips.MasteryPageToolTip;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.context.RustContext;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class MasteriesController extends EventDispatcher
   {
      
      public static const MAX_POINTS_ALREADY_SPENT:String = "maxPointsAlreadySpent";
      
      public static const MAX_POINTS_NOW_SPENT:String = "maxPointsNowSpent";
      
      public static const POINT_SPENT_SUCCESSFULLY:String = "pointSpentSuccessfully";
      
      public static const POINT_RETURNED_SUCCESSFULLY:String = "pointReturnedSuccessfully";
      
      public static const ERROR_SPENDING_POINT:String = "errorSpendingPoint";
      
      public static const ERROR_REFUNDING_POINT:String = "errorRefundingPoint";
      
      public static const NO_BOOK:String = "noBook";
      
      private const MASTERIES_SOUND_REMOVE_ALL:String;
      
      private var alerter:IAlerterProvider;
      
      private var _pagesDirty:Boolean;
      
      private var _masteriesViewMediator:IMasteriesViewMediator;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var session:Session;
      
      private var _masteryBook:MasteryBook;
      
      private const MASTERIES_SOUND_FOLDER:String = "masteries/";
      
      private const MASTERIES_SOUND_ADD_POINT:String = this.MASTERIES_SOUND_FOLDER + "masteries_addpoint.mp3";
      
      private var _parentDisplay:DisplayAdapter;
      
      private const MASTERIES_SOUND_REMOVE_POINT:String = this.MASTERIES_SOUND_FOLDER + "masteries_removepoint.mp3";
      
      private const MASTERIES_SOUND_LOCK_IN:String = this.MASTERIES_SOUND_FOLDER + "masteries_lockin.mp3";
      
      private var masteryPagesInfoUpdated:Signal = new Signal();
      
      private var serviceProxy:ServiceProxy;
      
      public var isLocalSummoner:Boolean = false;
      
      private var _context:Context;
      
      private var pageInfoArray:ArrayCollection;
      
      public function MasteriesController(param1:RustContext, param2:Class, param3:Session = null, param4:ServiceProxy = null)
      {
         this.MASTERIES_SOUND_REMOVE_ALL = this.MASTERIES_SOUND_FOLDER + "masteries_returnallpoints.mp3";
         super();
         this.alerter = AlerterProviderProxy.instance;
         if(param3 == null)
         {
            this.session = Session.instance;
         }
         else
         {
            this.session = param3;
         }
         if(param4 == null)
         {
            this.serviceProxy = ServiceProxy.instance;
         }
         else
         {
            this.serviceProxy = param4;
         }
         this._context = param1;
         this._masteriesViewMediator = new param2(this,this._context as RustContext);
      }
      
      private function onProfileNavigationProviderShowMasteries(param1:ILegacyProfileNavigationProvider) : void
      {
         param1.reviewSummonerProfile(Session.instance.summoner,"masteriesPage");
      }
      
      private function onMasteriesResetAcknowledge(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            ProviderLookup.getProvider(ILegacyProfileNavigationProvider,this.onProfileNavigationProviderShowMasteries);
         }
      }
      
      public function showMasteriesView(param1:Number, param2:DisplayAdapter, param3:Boolean = false, param4:MasteryBookDTO = null) : void
      {
         this._parentDisplay = param2;
         if(param1 == 0)
         {
            if(this._masteryBook == null || this._masteryBook.bookDTO.summonerId != this.session.summoner.sumId)
            {
               this.loadMasteries(this.session.summoner.sumId);
            }
            else
            {
               this.isLocalSummoner = true;
               this._masteryBook.totalPointsToSpend = this.session.summonerTalentsAndPoints.talentPoints;
               this._masteriesViewMediator.displayView(this._parentDisplay,param3);
            }
         }
         else if(param1 > 0)
         {
            if(this._masteryBook == null || this._masteryBook.bookDTO.summonerId != param1)
            {
               this.loadMasteries(param1);
            }
            else
            {
               this.isLocalSummoner = false;
               this._masteriesViewMediator.displayView(this._parentDisplay,param3);
            }
         }
         else if(param4 != null)
         {
            this.isLocalSummoner = true;
            this._masteryBook = new MasteryBook(param4);
            this.validateCurrentPage();
            this._masteryBook.totalPointsToSpend = 30;
            this._masteriesViewMediator.displayView(this._parentDisplay,param3);
         }
         else
         {
            this.logger.error("Mastery page view requested with a bad summoner ID and no specific page. SummonerID = " + param1);
            trace("Mastery page view requested with a bad summoner ID and no specific page. SummonerID = " + param1);
         }
      }
      
      public function saveChanges() : void
      {
         this._masteryBook.saveBook();
         this.validateCurrentPage();
         this.serviceProxy.masteryBookService.saveMasteryBook(this._masteryBook.bookDTO,this.onSaveSuccess,this.onMasteryBookServiceCallComplete,this.onGetMasteryBookError);
      }
      
      public function getMasteryPagesInfoUpdated() : ISignal
      {
         return this.masteryPagesInfoUpdated;
      }
      
      public function silentlySaveChanges() : void
      {
         this._masteryBook.saveBook();
         this.validateCurrentPage();
         this.serviceProxy.masteryBookService.saveMasteryBook(this._masteryBook.bookDTO,this.onSilentSaveSucess,this.onMasteryBookServiceCallComplete,this.onGetMasteryBookError);
      }
      
      public function getSelectedPageByID() : int
      {
         if(this._masteryBook == null)
         {
            return -1;
         }
         return this._masteryBook.currentPageIndex;
      }
      
      public function increaseTalentRank(param1:int) : String
      {
         var _loc5_:TalentEntry = null;
         if(this._masteryBook == null)
         {
            return NO_BOOK;
         }
         var _loc2_:int = int(MasteriesUtils.getSpentPointsInGroup(this._masteryBook.currentPage,MasteriesUtils.getMasteryByID(param1).talentGroupId));
         if(MasteriesUtils.getMasteryRowByMasteryID(param1).pointsToActivate > _loc2_)
         {
            return ERROR_SPENDING_POINT;
         }
         if(this._masteryBook.currentPage.getSpentPoints() >= this._masteryBook.totalPointsToSpend)
         {
            return MAX_POINTS_ALREADY_SPENT;
         }
         var _loc3_:Talent = MasteriesUtils.getMasteryByID(param1);
         if(_loc3_.prereqTalentGameCode != 0)
         {
            _loc5_ = this._masteryBook.currentPage.getEntryByMasteryID(_loc3_.prereqTalentGameCode);
            if(_loc5_ == null || _loc5_.rank < MasteriesUtils.getMasteryByID(_loc3_.prereqTalentGameCode).maxRank)
            {
               return ERROR_SPENDING_POINT;
            }
         }
         var _loc4_:TalentEntry = this._masteryBook.currentPage.getEntryByMasteryID(param1);
         if(_loc4_ == null)
         {
            _loc4_ = new TalentEntry();
            _loc4_.talentId = param1;
            this._masteryBook.currentPage.addEntry(_loc4_);
         }
         if(_loc4_.rank < MasteriesUtils.getMasteryByID(param1).maxRank)
         {
            ++_loc4_.rank;
            this._pagesDirty = true;
            this._masteryBook.currentPage.isDirty = true;
            if(this._masteryBook.currentPage.getSpentPoints() == this.book.totalPointsToSpend)
            {
               return MAX_POINTS_NOW_SPENT;
            }
            return POINT_SPENT_SUCCESSFULLY;
         }
         return ERROR_SPENDING_POINT;
      }
      
      public function closeMasteries() : void
      {
         if(this.isLocalSummoner)
         {
            if(this._masteryBook.isDirty)
            {
               this.dispatchEvent(new MasteryEvent(MasteryEvent.CLOSE_EDITED_VIEW_REQUEST));
               this._masteriesViewMediator.closeView(true);
            }
            else
            {
               this._masteriesViewMediator.closeView(false);
               this._masteryBook.revertBook();
            }
         }
         else
         {
            this._masteriesViewMediator.closeView(false);
         }
      }
      
      private function onGetMasteryBookError(param1:Error) : void
      {
         this.logger.error("MasteriesController :: Error retrieving mastery book from server.");
         trace("MasteriesController :: Error retrieving mastery book from server.");
      }
      
      public function setSelectedPageByID(param1:int) : void
      {
         if(this._masteryBook == null)
         {
            return;
         }
         var _loc2_:int = int(this._masteryBook.currentPageIndex);
         this._masteryBook.currentPageIndex = param1;
         if(_loc2_ != param1 && this._masteryBook.currentPageIndex == param1)
         {
            this.silentlySaveChanges();
         }
      }
      
      private function grabCatalog() : void
      {
         MasteryBook.maxMasteryPagesAllowed = this.session.maxNumberOfAllowedMasteryPages;
         if(this.session.summonerCatalog != null)
         {
            MasteriesUtils.registerTree(this.session.summonerCatalog.talentTree);
            this.logger.info("Talent Tree successfully loaded.");
         }
      }
      
      private function checkForReset() : void
      {
         var _loc1_:IResourceManager = null;
         var _loc2_:AlertAction = null;
         if(this.isLocalSummoner && Session.instance.summonerLevel.summonerLevel > 1 && Boolean(this._masteryBook.isEmpty()) && !UserPreferencesManager.userPrefs.hasSeenMasteriesReset2014)
         {
            _loc1_ = ResourceManager.getInstance();
            _loc2_ = new AlertAction(_loc1_.getString("resources","masteryResetTitle"),_loc1_.getString("resources","masteryResetMessage"));
            _loc2_.showNegative = true;
            _loc2_.setYesNoLabels();
            _loc2_.getCompleted().add(this.onMasteriesResetAcknowledge);
            _loc2_.add();
         }
         UserPreferencesManager.userPrefs.hasSeenMasteriesReset2014 = true;
      }
      
      private function validateCurrentPage() : void
      {
         var _loc1_:MasteryPage = null;
         if(this._masteryBook.currentPageIndex == -1)
         {
            for each(_loc1_ in this._masteryBook.bookPages)
            {
               if(_loc1_.isCurrent == true)
               {
                  this._masteryBook.currentPageIndex = this._masteryBook.bookPages.getItemIndex(_loc1_);
               }
            }
         }
         if(this._masteryBook.currentPageIndex == -1)
         {
            (this._masteryBook.bookPages.getItemAt(0) as MasteryPage).isCurrent = true;
            this._masteryBook.currentPageIndex = 0;
            if(this.isLocalSummoner)
            {
               this._masteryBook.saveBook();
               this.serviceProxy.masteryBookService.saveMasteryBook(this._masteryBook.bookDTO,this.onSilentSaveSucess,this.onMasteryBookServiceCallComplete,this.onGetMasteryBookError);
            }
         }
      }
      
      public function createNewPage() : void
      {
         if(Boolean(this._masteryBook) && Boolean(this._masteryBook.createPage()))
         {
            this.silentlySaveChanges();
         }
      }
      
      private function onSilentSaveSucess(param1:ResultEvent) : void
      {
         this.updatePageInfoArray();
      }
      
      private function doesRowContainPoints(param1:TalentRow) : Boolean
      {
         var _loc3_:Talent = null;
         var _loc2_:uint = 0;
         while(_loc2_ < param1.talents.length)
         {
            _loc3_ = param1.talents.getItemAt(_loc2_) as Talent;
            if(this._masteryBook.currentPage.getRankOfMastery(_loc3_.tltId) > 0)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function revertChanges() : void
      {
         this._masteryBook.revertBook();
      }
      
      public function changeDisplayedPage(param1:int) : Boolean
      {
         if(this._masteryBook == null)
         {
            return false;
         }
         this._masteryBook.currentPageIndex = param1;
         if(this._masteryBook.currentPageIndex == param1)
         {
            this.updatePageInfoArray();
            return true;
         }
         return false;
      }
      
      private function updatePageInfoArray() : void
      {
         var _loc2_:MasteryPage = null;
         var _loc3_:MasteryPageToolTip = null;
         var _loc4_:MasteryPageInfoSummary = null;
         if(this.pageInfoArray == null)
         {
            this.pageInfoArray = new ArrayCollection();
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._masteryBook.bookPages.length)
         {
            _loc2_ = this._masteryBook.bookPages.getItemAt(_loc1_) as MasteryPage;
            if(this.pageInfoArray.length > _loc1_)
            {
               _loc4_ = this.pageInfoArray.getItemAt(_loc1_) as MasteryPageInfoSummary;
            }
            else
            {
               _loc4_ = new MasteryPageInfoSummary();
               this.pageInfoArray.disableAutoUpdate();
               this.pageInfoArray.addItem(_loc4_);
            }
            _loc3_ = new MasteryPageToolTip(this._context);
            _loc3_.setDataBasedOnPage(_loc2_,_loc1_);
            _loc4_.pageTooltip = _loc3_.getAsset();
            _loc4_.pageName = MasteriesUtils.getLocalizedPageName(_loc2_.name,_loc1_);
            _loc4_.pageID = _loc1_;
            _loc4_.isCurrent = _loc2_.isCurrent;
            _loc4_.totalSpentPoints = _loc2_.getSpentPoints();
            _loc4_.categoryPointsSpent.length = 0;
            _loc4_.categoryPointsSpent.push(MasteriesUtils.getSpentPointsInGroup(_loc2_,1));
            _loc4_.categoryPointsSpent.push(MasteriesUtils.getSpentPointsInGroup(_loc2_,2));
            _loc4_.categoryPointsSpent.push(MasteriesUtils.getSpentPointsInGroup(_loc2_,3));
            this.pageInfoArray.enableAutoUpdate();
            _loc1_++;
         }
         while(_loc1_ < this.pageInfoArray.length)
         {
            this.pageInfoArray.removeItemAt(_loc1_);
            _loc1_++;
         }
         this.pageInfoArray.refresh();
         this.masteryPagesInfoUpdated.dispatch(this.pageInfoArray);
      }
      
      private function onMasteryBookServiceCallComplete(param1:*) : void
      {
         this.updatePageInfoArray();
      }
      
      private function onGetMasteryBookSuccess(param1:ResultEvent) : void
      {
         var _loc2_:MasteryBookDTO = param1.result as MasteryBookDTO;
         this._masteryBook = new MasteryBook(_loc2_);
         if(_loc2_.summonerId == this.session.summoner.sumId)
         {
            this.isLocalSummoner = true;
         }
         else
         {
            this.isLocalSummoner = false;
         }
         this.validateCurrentPage();
         if(this.isLocalSummoner)
         {
            this._masteryBook.totalPointsToSpend = this.session.summonerTalentsAndPoints.talentPoints;
            this.updatePageInfoArray();
            this.checkForReset();
         }
         if(this._parentDisplay)
         {
            this._masteriesViewMediator.displayView(this._parentDisplay);
         }
      }
      
      public function returnPointsFromGroupOnCurrentPage(param1:uint) : void
      {
         this._masteryBook.returnPointsFromGroupOnCurrentPage(param1);
      }
      
      public function get book() : MasteryBook
      {
         return this._masteryBook;
      }
      
      public function returnPointsFromCurrentPage() : void
      {
         this._masteryBook.returnPointsFromCurrentPage();
      }
      
      private function onSaveSuccess(param1:ResultEvent) : void
      {
         trace("MasteriesController :: saved successfully.");
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","talentTree_saveSuccessTitle"),_loc2_.getString("resources","talentTree_saveSuccessMessage"));
         _loc3_.add();
         this.updatePageInfoArray();
      }
      
      private function loadMasteries(param1:uint) : void
      {
         this.serviceProxy.masteryBookService.getMasteryBook(param1,this.onGetMasteryBookSuccess,this.onMasteryBookServiceCallComplete,this.onGetMasteryBookError);
         this.grabCatalog();
      }
      
      public function getMasteryPagesInfo() : ArrayCollection
      {
         this.pageInfoArray = new ArrayCollection();
         if(Boolean(this._masteryBook) && this.isLocalSummoner)
         {
            this.updatePageInfoArray();
         }
         else
         {
            this.loadMasteries(this.session.summoner.sumId);
         }
         return this.pageInfoArray;
      }
      
      public function decreaseTalentRank(param1:int) : String
      {
         var _loc4_:TalentRow = null;
         var _loc5_:Talent = null;
         if(this._masteryBook == null)
         {
            return NO_BOOK;
         }
         var _loc2_:TalentEntry = this._masteryBook.currentPage.getEntryByMasteryID(param1);
         var _loc3_:Talent = MasteriesUtils.getMasteryByID(param1);
         if(_loc2_ == null || _loc2_.rank <= 0 || _loc3_ == null)
         {
            return ERROR_REFUNDING_POINT;
         }
         for each(_loc4_ in MasteriesUtils.getMasteryGroupByMasteryID(_loc2_.talentId).talentRows)
         {
            if(this.doesRowContainPoints(_loc4_))
            {
               if(_loc4_.pointsToActivate > 0 && _loc3_.talentRowId < _loc4_.tltRowId && MasteriesUtils.getTotalPointsUpToRow(MasteriesUtils.getMasteryGroupByMasteryID(_loc3_.tltId),_loc4_.tltRowId - 1,this._masteryBook.currentPage) <= _loc4_.pointsToActivate)
               {
                  return ERROR_REFUNDING_POINT;
               }
               for each(_loc5_ in _loc4_.talents)
               {
                  if(_loc3_.tltId == _loc5_.prereqTalentGameCode && this._masteryBook.currentPage.getEntryByMasteryID(_loc5_.tltId) != null)
                  {
                     if(this._masteryBook.currentPage.getRankOfMastery(_loc5_.tltId))
                     {
                        return ERROR_REFUNDING_POINT;
                     }
                  }
               }
            }
         }
         --_loc2_.rank;
         if(_loc2_.rank == 0)
         {
            this._masteryBook.currentPage.getEntries().removeItemAt(this._masteryBook.currentPage.getEntries().getItemIndex(_loc2_));
         }
         this._pagesDirty = true;
         this._masteryBook.currentPage.isDirty = true;
         return POINT_RETURNED_SUCCESSFULLY;
      }
      
      public function deleteCurrentPage() : void
      {
         if(Boolean(this._masteryBook) && Boolean(this._masteryBook.deleteCurrentPage()))
         {
            this.silentlySaveChanges();
         }
      }
   }
}

