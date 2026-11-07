package com.riotgames.pvpnet.CLS.views.rankingview
{
   import blix.action.IAction;
   import blix.assets.proxy.SpriteProxy;
   import blix.components.scroll.ScrollModel;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import com.greensock.TweenLite;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.CLS.commands.GetDropInSpectateAvailabilityServiceCall;
   import com.riotgames.pvpnet.CLS.dataprovider.LeagueDataProvider;
   import com.riotgames.pvpnet.CLS.factory.ILeaguesActionFactory;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankListViewModel;
   import com.riotgames.pvpnet.CLS.models.RankRowTitleModel;
   import com.riotgames.pvpnet.CLS.models.SummonerLeagueObjectModel;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.enums.RankItemsStateEnum;
   import com.riotgames.pvpnet.CLS.views.enums.SummonerRelationshipEnum;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.RankingListItemRenderer;
   import com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.RankingListTitleItemRenderer;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.rust.components.list.List;
   
   public class RankingView extends SpriteProxy
   {
      
      private static const ADDITIONAL_PADDING:uint = 1;
      
      private static const NB_ITEMS_CENTER:uint = 6;
      
      private static const ROW_ITEM_HEIGHT:Number = 31;
      
      private static const MIN_TOP_MASTERS_TO_DISPLAY:int = 10;
      
      private var _dataProvider:LeagueDataProvider;
      
      private var _lastSelectedItem:uint;
      
      private var _rankingHeaderView:RankingHeaderView;
      
      private var _noListView:NoListView;
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _currentLeagueObj:RankListViewModel;
      
      private var _currentLeagueName:String = "";
      
      private var _newData:Vector.<ListItemObjectModel>;
      
      private var _currentRank:LeagueRank;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _data:Array = [];
      
      private var _headers:Array = [];
      
      private var _headerPosition:Array = [];
      
      private var _currentTopRowItemTitle:RankingListTitleItemRenderer;
      
      private var _userList:List;
      
      private var _spinner:SpriteProxy;
      
      public function RankingView(param1:IContext)
      {
         super(param1);
      }
      
      private static function calculateScrollingPosition(param1:uint) : int
      {
         return int((param1 + ADDITIONAL_PADDING - NB_ITEMS_CENTER) * ROW_ITEM_HEIGHT);
      }
      
      private static function getUpToPromotionHeader(param1:LeagueTier, param2:LeagueRank) : String
      {
         var _loc3_:String = null;
         if(param1.isApex())
         {
            _loc3_ = RankItemsStateEnum.TITLE_PROMO_APEX;
         }
         else
         {
            _loc3_ = param2 == LeagueRank.I ? RankItemsStateEnum.TITLE_PROMO_5 : RankItemsStateEnum.TITLE_PROMO_3;
         }
         return _loc3_;
      }
      
      private static function getQueueTypeHeader(param1:LeagueTier, param2:uint) : String
      {
         var _loc3_:String = null;
         if(param1.isApex())
         {
            _loc3_ = param2 == QueueTypesEnum.QUEUE_TYPE_SOLO ? RankItemsStateEnum.TITLE_APEX : RankItemsStateEnum.TITLE_APEX_TEAMS;
         }
         else
         {
            _loc3_ = param2 == QueueTypesEnum.QUEUE_TYPE_SOLO ? RankItemsStateEnum.TITLE_NORMAL : RankItemsStateEnum.TITLE_NORMAL_TEAMS;
         }
         return _loc3_;
      }
      
      override protected function createChildren() : void
      {
         var _rankListItemsContainer:SpriteProxy;
         super.createChildren();
         if(!this._localeHelper)
         {
            this._localeHelper = getDependency(ILocaleHelper);
         }
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         ProviderLookup.getProvider(ILeagueDataProvider,function(param1:LeagueDataProvider):void
         {
            _dataProvider = param1;
         });
         _rankListItemsContainer = new SpriteProxy(this);
         setTimelineChildByName("listItemsContainer",_rankListItemsContainer);
         this._noListView = new NoListView(this);
         setTimelineChildByName("emptyDivisionBoard",this._noListView);
         this._currentTopRowItemTitle = new RankingListTitleItemRenderer(this);
         setTimelineChildByName("leagueHeader",this._currentTopRowItemTitle);
         this._rankingHeaderView = new RankingHeaderView(this,LeagueRank.I);
         setTimelineChildByName("header",this._rankingHeaderView);
         this._leagueSystemModuleNavigation.getOnRankSelectionUpdateSignal().add(this.onRankButtonPressedSignal);
         this._leagueSystemModuleNavigation.getOnRankRowSelectedSignal().add(this.onListItemSelected);
         this._leagueSystemModuleNavigation.getOnLeagueSelectionUpdateSignal().add(this.onLeagueChange);
         this._leagueSystemModuleNavigation.getOnChallengerTierSelectionUpdateSignal().add(this.onUpdateChallengerTierList);
         this._userList = new List(this);
         this._userList.allowVariableSpan = false;
         this._userList.allowMultiSelection = false;
         this._userList.setLinkage("LeagueList");
         this._userList.listView.rendererLinkage = "RankingListItemRenderer";
         this._userList.listView.rendererType = RankingListItemRenderer;
         this.hideUserList();
         this._userList.listView.itemPadding = 0;
         this._userList.listView.scrollModel.getChanged().add(this.onScrollChanged);
         _rankListItemsContainer.addChild(this._userList);
         this._spinner = new SpriteProxy(this);
         setTimelineChildByName("spinnerContainer",this._spinner);
         this._noListView.setDefaultText();
      }
      
      private function updateHeaderState(param1:String) : void
      {
         var _loc2_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         if(!this._data)
         {
            this.forceHideHeader();
            return;
         }
         this._currentTopRowItemTitle.update(param1,this._currentLeagueName);
      }
      
      private function cleanUp() : void
      {
         var _loc1_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         this._data = [];
         this._headers = [];
         this._currentLeagueName = "";
         if(this._currentTopRowItemTitle)
         {
            this._currentTopRowItemTitle.hide();
         }
         if(this._noListView)
         {
            this._noListView.hide();
         }
         if(this._userList)
         {
            this.hideUserList();
            TweenLite.to(this._spinner.getSetterProxy(),_loc1_ ? 1 : 0,{"alpha":1});
         }
      }
      
      private function onUpdateDivisionList(param1:RankListViewModel, param2:LeagueRank) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         this.cleanUp();
         this._newData = param1.getListFromRank(param2);
         this._currentLeagueObj = param1;
         this._currentRank = param2;
         this._currentLeagueName = param1.leagueName;
         if(!this._newData)
         {
            this.displayNoListMessage(NoListView.NO_LIST_DIVISION);
         }
         else
         {
            _loc3_ = this._newData[0].miniSeriesResults.length > 0 || this._newData[0].apexPendingPromotion;
            if(_loc3_)
            {
               _loc4_ = getUpToPromotionHeader(this._newData[0].tier,param2);
               this._data.push(new RankRowTitleModel(_loc4_,this._localeHelper.getLeagueName(param1.leagueName)));
            }
            else
            {
               _loc4_ = getQueueTypeHeader(this._newData[0].tier,this._newData[0].queueType);
               this._data.push(new RankRowTitleModel(_loc4_,this._localeHelper.getLeagueName(param1.leagueName)));
            }
            this.updateHeaderState(_loc4_);
         }
         if(this._newData)
         {
            if(this._userList)
            {
               this.onDivisionListIsDisplayed();
            }
            else
            {
               getEnterFrame().addOnce(this.onDivisionListIsDisplayed);
            }
         }
         else
         {
            this.setInRowTitlePosition();
         }
      }
      
      private function onDivisionListIsDisplayed() : void
      {
         var _loc5_:ListItemObjectModel = null;
         var _loc1_:ListItemObjectModel = this._currentLeagueObj.myRank;
         var _loc2_:uint = this._newData.length;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         for(; _loc6_ < _loc2_; _loc6_++)
         {
            _loc5_ = this._newData[_loc6_];
            if(_loc5_.isInactive && !_loc5_.tier.isApex())
            {
               if(_loc5_.relationship != SummonerRelationshipEnum.SELF_RELATIONSHIP)
               {
                  continue;
               }
            }
            else
            {
               _loc3_++;
            }
            if(_loc5_.tier == LeagueTier.MASTER)
            {
               this._data = this.addMasterSeriesHeaders(this._data,_loc6_);
            }
            else
            {
               this._data = this.addNormalSeriesHeaders(this._data,_loc6_);
            }
            if(_loc1_.rank == this._currentRank)
            {
               if(_loc5_.relationship == SummonerRelationshipEnum.SELF_RELATIONSHIP)
               {
                  _loc4_ = calculateScrollingPosition(_loc6_);
               }
            }
            this._data.push(_loc5_);
         }
         this.moveScrollBarIntoPosition(_loc4_);
         if(_loc2_ == this._newData.length)
         {
            this.updateLeagueList();
         }
      }
      
      private function onScrollChanged(param1:ScrollModel) : void
      {
         var _loc2_:Number = Number(param1.getValue());
         if(this._headers.length > 1)
         {
            if(param1.getMax() <= 0)
            {
               return;
            }
            this.updateHeaderState(this.calculateHeaderState(_loc2_));
         }
         else if(this._headers[0])
         {
            this.updateHeaderState(this._headers[0]);
         }
      }
      
      private function calculateHeaderState(param1:Number) : String
      {
         var _loc3_:uint = 0;
         var _loc2_:String = this._headers[0];
         if(this._headers.length > 1)
         {
            _loc3_ = 0;
            while(_loc3_ < this._headerPosition.length)
            {
               if(param1 + ROW_ITEM_HEIGHT > this._headerPosition[_loc3_])
               {
                  _loc2_ = this._headers[_loc3_];
               }
               _loc3_++;
            }
         }
         this.updateHeaderState(_loc2_);
         return _loc2_;
      }
      
      private function moveScrollBarIntoPosition(param1:int) : void
      {
         if(isNaN(param1))
         {
            param1 = 5;
         }
         this._userList.listView.scrollModel.setValue(param1);
      }
      
      private function addNormalSeriesHeaders(param1:Array, param2:uint) : Array
      {
         if(param2 > 0)
         {
            if(this._newData[param2].miniSeriesResults.length == 0 && this._newData[param2 - 1].miniSeriesResults.length != 0)
            {
               if(this._newData[param2].queueType == QueueTypesEnum.QUEUE_TYPE_SOLO)
               {
                  param1.push(new RankRowTitleModel(RankItemsStateEnum.TITLE_NORMAL,this._localeHelper.getLeagueName(this._currentLeagueObj.leagueName)));
               }
               else
               {
                  param1.push(new RankRowTitleModel(RankItemsStateEnum.TITLE_NORMAL_TEAMS,this._localeHelper.getLeagueName(this._currentLeagueObj.leagueName)));
               }
            }
         }
         return param1;
      }
      
      private function addMasterSeriesHeaders(param1:Array, param2:uint) : Array
      {
         var _loc3_:ListItemObjectModel = this._newData[param2];
         if(param2 > 0 && !_loc3_.apexPendingPromotion && this._newData[param2 - 1].apexPendingPromotion)
         {
            if(_loc3_.queueType == QueueTypesEnum.QUEUE_TYPE_SOLO)
            {
               param1.push(new RankRowTitleModel(RankItemsStateEnum.TITLE_APEX,this._localeHelper.localeLookup("rhvMaster")));
            }
            else
            {
               param1.push(new RankRowTitleModel(RankItemsStateEnum.TITLE_APEX_TEAMS,this._localeHelper.localeLookup("rhvMaster")));
            }
         }
         return param1;
      }
      
      private function onUpdateChallengerTierList(param1:Vector.<ListItemObjectModel>) : void
      {
         this.cleanUp();
         this._rankingHeaderView.hideVerticalDivisionSelector();
         this._newData = param1;
         if(!param1 || param1.length == 0)
         {
            this.displayNoListMessage(NoListView.NO_LIST_CHALLENGER);
         }
         if(param1)
         {
            if(Boolean(this._userList) && param1.length > 0)
            {
               this.onChallengerTierIsDisplayed();
            }
            else
            {
               getEnterFrame().addOnce(this.onChallengerTierIsDisplayed);
            }
         }
      }
      
      private function onChallengerTierIsDisplayed() : void
      {
         var _loc8_:RankRowTitleModel = null;
         var _loc9_:IAction = null;
         var _loc10_:Vector.<Vector.<ListItemObjectModel>> = null;
         var _loc11_:Vector.<ListItemObjectModel> = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:ListItemObjectModel = null;
         var _loc1_:int = 1;
         var _loc2_:int = 0;
         var _loc3_:uint = this._newData.length;
         var _loc4_:uint = QueueTypesEnum.QUEUE_TYPE_SOLO;
         if(Boolean(this._newData) && this._newData.length > 0)
         {
            _loc4_ = this._newData[0].queueType;
            _loc8_ = this.getChallengerHeader(_loc4_);
            this._data.push(_loc8_);
            this.updateHeaderState(_loc8_.type);
         }
         var _loc5_:ILeaguesActionFactory = getDependency(ILeaguesActionFactory);
         var _loc6_:Vector.<String> = new Vector.<String>();
         var _loc7_:int = 0;
         while(_loc7_ < _loc3_)
         {
            this._newData[_loc7_].position = _loc1_;
            this._newData[_loc7_].id = _loc1_;
            _loc1_++;
            this._newData[_loc7_].state = RankItemsStateEnum.ITEM_CHALLENGE_TIER;
            this._data.push(this._newData[_loc7_]);
            if(this._newData[_loc7_].relationship == SummonerRelationshipEnum.SELF_RELATIONSHIP)
            {
               _loc2_ = calculateScrollingPosition(_loc7_);
            }
            else if(this._newData[_loc7_].isTeam)
            {
               _loc6_.push(this._newData[_loc7_].playerOrTeamId);
            }
            else
            {
               _loc6_.push(this._newData[_loc7_].summonerName);
            }
            _loc7_++;
         }
         if(_loc6_.length > 0)
         {
            _loc9_ = _loc5_.getRetrieveDropInSpectateAvailabilityAction(_loc6_);
            _loc9_.getCompleted().addOnce(this.onSpectateActionComplete);
            _loc9_.invoke();
         }
         if(Boolean(this._newData) && this._newData.length > 0)
         {
            _loc10_ = this._dataProvider.topMasters;
            if(_loc10_)
            {
               _loc11_ = _loc10_[_loc4_];
               if((Boolean(_loc11_)) && _loc11_.length > 0)
               {
                  this._data.push(this.getEmptyHeader());
                  this._data.push(this.getTopMasterHeader(_loc4_));
                  _loc12_ = Math.min(MIN_TOP_MASTERS_TO_DISPLAY,_loc11_.length);
                  _loc13_ = 0;
                  while(_loc13_ < _loc11_.length)
                  {
                     _loc14_ = _loc11_[_loc13_];
                     if(_loc13_ < _loc12_ || _loc14_.apexPendingPromotion)
                     {
                        _loc14_.position = _loc1_;
                        _loc14_.id = _loc1_;
                        _loc1_++;
                        _loc14_.state = RankItemsStateEnum.ITEM_MASTER_TIER;
                        this._data.push(_loc14_);
                     }
                     _loc13_++;
                  }
               }
            }
         }
         if(this._data.length > 0)
         {
            this._noListView.hide();
         }
         this.moveScrollBarIntoPosition(_loc2_);
         if(_loc3_ == this._newData.length)
         {
            this.updateLeagueList();
         }
      }
      
      private function onSpectateActionComplete(param1:IAction) : void
      {
         var _loc4_:ListItemObjectModel = null;
         var _loc5_:int = 0;
         var _loc2_:GetDropInSpectateAvailabilityServiceCall = param1 as GetDropInSpectateAvailabilityServiceCall;
         if(_loc2_ == null || _loc2_.availableForWatching.length == 0)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._data.length)
         {
            if(this._data[_loc3_] is ListItemObjectModel)
            {
               _loc4_ = this._data[_loc3_];
               _loc4_.isSpectatable = false;
               _loc5_ = 0;
               while(_loc5_ < _loc2_.availableForWatching.length)
               {
                  if(_loc4_.summonerName == _loc2_.availableForWatching[_loc5_] || _loc4_.playerOrTeamId == _loc2_.availableForWatching[_loc5_])
                  {
                     _loc4_.isSpectatable = true;
                     break;
                  }
                  _loc5_++;
               }
            }
            _loc3_++;
         }
      }
      
      private function getChallengerHeader(param1:int) : RankRowTitleModel
      {
         var _loc2_:String = RankItemsStateEnum.TITLE_CHALLENGE_TIER_TEAMS;
         if(param1 == QueueTypesEnum.QUEUE_TYPE_SOLO)
         {
            _loc2_ = RankItemsStateEnum.TITLE_CHALLENGE_TIER;
         }
         return new RankRowTitleModel(_loc2_,this._localeHelper.localeLookup("rhvChallenger"));
      }
      
      private function getTopMasterHeader(param1:int) : RankRowTitleModel
      {
         var _loc2_:String = RankItemsStateEnum.TITLE_TOP_MASTER_TIER_TEAMS;
         if(param1 == QueueTypesEnum.QUEUE_TYPE_SOLO)
         {
            _loc2_ = RankItemsStateEnum.TITLE_TOP_MASTER_TIER;
         }
         return new RankRowTitleModel(_loc2_,this._localeHelper.localeLookup("rhvMaster"));
      }
      
      private function getEmptyHeader() : RankRowTitleModel
      {
         return new RankRowTitleModel(RankItemsStateEnum.TITLE_EMPTY,"");
      }
      
      private function updateLeagueList() : void
      {
         var _loc1_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         if(Boolean(this._userList) && Boolean(this._data))
         {
            this._userList.data = this._data;
            this.showUserList(_loc1_);
            TweenLite.to(this._spinner.getSetterProxy(),_loc1_ ? 1 : 0,{"alpha":0});
            this.setInRowTitlePosition();
            this.calculateHeaderState(this._userList.listView.scrollModel.getValue());
            if(this._data.length <= 1)
            {
               this.forceHideHeader();
            }
         }
         else
         {
            this.forceHideHeader();
         }
      }
      
      private function setInRowTitlePosition() : void
      {
         var _loc1_:uint = 0;
         this._headerPosition = [];
         this._headers = [];
         if(this._data)
         {
            if(this._data.length > 0)
            {
               _loc1_ = 0;
               while(_loc1_ < this._data.length)
               {
                  if(this._data[_loc1_] is RankRowTitleModel)
                  {
                     this._headerPosition.push(_loc1_ * ROW_ITEM_HEIGHT);
                     this._headers.push(this._data[_loc1_].type);
                  }
                  _loc1_++;
               }
            }
            else
            {
               this.forceHideHeader();
            }
         }
         else
         {
            this.forceHideHeader();
         }
      }
      
      private function onLeagueChange(param1:SummonerLeagueObjectModel) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.onUpdateDivisionList(param1.elements,param1.rank);
         this._rankingHeaderView.updateDivision(param1);
      }
      
      private function onRankButtonPressedSignal(param1:RankListViewModel, param2:LeagueRank) : void
      {
         this.onUpdateDivisionList(param1,param2);
      }
      
      private function onListItemSelected(param1:uint, param2:ListItemObjectModel) : void
      {
         this._lastSelectedItem = param1;
      }
      
      private function displayNoListMessage(param1:int) : void
      {
         this.forceHideHeader();
         if(this._noListView)
         {
            this._noListView.show(param1);
         }
      }
      
      private function forceHideHeader() : void
      {
         this.hideUserList();
         if(this._currentTopRowItemTitle)
         {
            this._currentTopRowItemTitle.hide();
         }
      }
      
      private function showUserList(param1:Boolean) : void
      {
         this._userList.setVisible(true);
         TweenLite.to(this._userList.getSetterProxy(),param1 ? 1 : 0,{"alpha":1});
      }
      
      private function hideUserList() : void
      {
         if(this._userList)
         {
            TweenLite.killTweensOf(this._userList);
            this._userList.setAlpha(0);
            this._userList.setVisible(false);
         }
      }
   }
}

