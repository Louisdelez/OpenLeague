package com.riotgames.pvpnet.itembrowser.controller
{
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.pvpnet.itembrowser.sets.dao.ItemSetsDao;
   import com.riotgames.pvpnet.itembrowser.sets.enum.ItemSetBlockType;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetBlock;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetItem;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import flash.desktop.Clipboard;
   import flash.desktop.ClipboardFormats;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class ItemSetsController
   {
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker;
      
      private var _model:ItemSetsModel;
      
      private var _itemSetChampionsDictionary:Dictionary = new Dictionary();
      
      private var _appConfig:AppConfig;
      
      private var _itemSetsOrganizationalStructureTracker:IItemSetsOrganizationalStructureTracker;
      
      private var _dao:ItemSetsDao;
      
      private var _sessionMetrics:ISessionMetricsProvider;
      
      private var _inventoryProvider:IInventoryProvider;
      
      public function ItemSetsController(param1:ItemSetsModel, param2:ItemSetsDao, param3:IInventoryProvider, param4:AppConfig, param5:IItemSetsBehaviorTracker, param6:IItemSetsOrganizationalStructureTracker, param7:ISessionMetricsProvider)
      {
         super();
         this.setModel(param1);
         this._dao = param2;
         this._dao.getMyItemSets(this.gotMyItems,this.errorGettingItems);
         this._inventoryProvider = param3;
         this._inventoryProvider.getInventoryController().addEventListener(InventoryEvent.CHAMPIONS_RETRIEVED,this.handleChampionsRetrieved);
         this.handleChampionsRetrieved(null);
         this._itemSetsBehaviorTracker = param5;
         this._itemSetsOrganizationalStructureTracker = param6;
         this._sessionMetrics = param7;
         this._sessionMetrics.getSessionClosedSignal().add(this.snapshotStructureForTracking);
         this._appConfig = param4;
         this._appConfig.availableMapsChanged.add(this.handleAvailableMapsChanged);
         this.handleAvailableMapsChanged();
      }
      
      public function writeActiveItemSetToFile(param1:File) : Boolean
      {
         var fileStream:FileStream = null;
         var file:File = param1;
         var itemSetJSON:String = this.getJSONForActiveItemSet();
         try
         {
            fileStream = new FileStream();
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeMultiByte(itemSetJSON,"utf-8");
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
      
      public function exportChampionItems(param1:Champion, param2:Number) : void
      {
         this._dao.outputItemSetsForChampion(this._model.getItemSets(),param1,param2,this.exportSuccessHandler,this.exportErrorHandler);
      }
      
      private function errorGettingItems() : void
      {
      }
      
      private function saveItemsError() : void
      {
         trace("Save error!");
      }
      
      public function addItemPage() : void
      {
         if(this._model.getItemSets() == null)
         {
            this._model.setItemSets(new Vector.<ItemSet>());
         }
         var _loc1_:ItemSet = this.createNewBlankItemPage();
         _loc1_.title = this.getUniquePageNameFromRequestedName(_loc1_.title,_loc1_);
         this._model.addItemPage(_loc1_);
         this._model.setActiveItemSet(_loc1_);
         this._model.setItemSetsDirty(true);
         this._itemSetsBehaviorTracker.incrementItemSets_PagesCreated_Count_InASession();
      }
      
      public function getJSONForActiveItemSet() : String
      {
         var _loc2_:String = null;
         var _loc1_:ItemSet = this._model.getActiveItemSet();
         if(_loc1_)
         {
            return this._dao.itemSetToJSON(_loc1_);
         }
         return "";
      }
      
      public function revertItemSets() : void
      {
         this._dao.getMyItemSets(this.gotMyItems,this.errorGettingItems);
         this._model.setItemSetsDirty(false);
         this._itemSetsBehaviorTracker.incrementItemSets_AllPagesReverted_Count_InASession();
      }
      
      public function snapshotStructureForTracking() : void
      {
         var _loc5_:ItemSet = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:ItemSetBlock = null;
         var _loc12_:ItemSet = null;
         var _loc13_:ItemSet = null;
         var _loc14_:ItemSet = null;
         var _loc15_:ItemSet = null;
         var _loc16_:ItemSet = null;
         var _loc17_:ItemSet = null;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:ItemSetItem = null;
         var _loc1_:* = 1;
         var _loc2_:int = NaN;
         var _loc3_:int = NaN;
         var _loc4_:Vector.<ItemSet> = this._model.getItemSets();
         if(_loc4_.length > 0)
         {
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_ChampionsAssociatedWithPage_InASession();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InAveragePage_ItemsInGroup();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InAveragePage_Groups();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InAveragePage_Items();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InFirstPage_ItemsInGroup();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InMinPage_ItemsInGroup();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InMedianPage_ItemsInGroup();
            this._itemSetsOrganizationalStructureTracker.reset_recordItemSets_InMaxPage_ItemsInGroup();
            _loc5_ = null;
            _loc6_ = new Array();
            _loc7_ = new Array();
            _loc8_ = new Array();
            _loc9_ = new Array();
            _loc10_ = new Array();
            for each(_loc12_ in _loc4_)
            {
               if(_loc5_ == null)
               {
                  _loc5_ = _loc12_;
               }
               _loc18_ = "Custom Item Set";
               if(!(_loc12_.title.indexOf(_loc18_) == 0 && _loc12_.title.length <= _loc18_.length + 4))
               {
                  _loc9_.push(_loc12_.title);
               }
               _loc6_.push(_loc12_);
               if(_loc12_.getIsGlobalForChampions())
               {
                  this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_ChampAssociationAllChampions_Count_InASession(_loc4_.length);
               }
               else
               {
                  _loc2_ = int(_loc12_.getAssignedChampions().length);
                  if(_loc2_ == 1)
                  {
                     this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_ChampAssociationOnlyOneChamp_Count_InASession(_loc4_.length);
                  }
                  else
                  {
                     this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_ChampAssociationMoreThanOneChampButNotAll_Count_InASession(_loc4_.length);
                  }
               }
               this._itemSetsOrganizationalStructureTracker.recordItemSets_ChampionsAssociatedWithPage_InASession(_loc2_);
               if(_loc12_.getIsGlobalForMaps())
               {
                  this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_MapAssociationAllMaps_Count_InASession(_loc4_.length);
               }
               else
               {
                  _loc3_ = int(_loc12_.getAssignedMaps().length);
                  switch(_loc3_)
                  {
                     case 1:
                        this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_MapAssociationOneMap_Count_InASession(_loc4_.length);
                        break;
                     case 2:
                        this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_MapAssociationTwoMaps_Count_InASession(_loc4_.length);
                        break;
                     case 3:
                        this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_MapAssociationTwoMaps_Count_InASession(_loc4_.length);
                        break;
                     case 4:
                     default:
                        this._itemSetsOrganizationalStructureTracker.incrementItemSets_AllPages_MapAssociationAllMaps_Count_InASession(_loc4_.length);
                  }
               }
               this._itemSetsOrganizationalStructureTracker.recordItemSets_ChampionsAssociatedWithPage_InASession(_loc2_);
               switch(_loc1_++)
               {
                  case 1:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage01_Count_InASession(_loc2_);
                     break;
                  case 2:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage02_Count_InASession(_loc2_);
                     break;
                  case 3:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage03_Count_InASession(_loc2_);
                     break;
                  case 4:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage04_Count_InASession(_loc2_);
                     break;
                  case 5:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage05_Count_InASession(_loc2_);
                     break;
                  case 6:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage06_Count_InASession(_loc2_);
                     break;
                  case 7:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage07_Count_InASession(_loc2_);
                     break;
                  case 8:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage08_Count_InASession(_loc2_);
                     break;
                  case 9:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage09_Count_InASession(_loc2_);
                     break;
                  case 10:
                     this._itemSetsOrganizationalStructureTracker.setItemSets_ChampionsAssociatedWithPage10_Count_InASession(_loc2_);
               }
               _loc19_ = 1;
               _loc12_.cachedBlocksContainedTotal = _loc12_.blocks.length;
               _loc12_.cachedGamesItemsContainedTotal = 0;
               _loc12_.cachedGamesItemsContainedCostTotal = 0;
               this._itemSetsOrganizationalStructureTracker.recordItemSets_InAveragePage_Groups(_loc12_.cachedBlocksContainedTotal);
               for each(_loc11_ in _loc12_.blocks)
               {
                  _loc7_.push(_loc11_);
                  _loc10_.push(_loc11_.getDisplayName());
                  _loc11_.cachedGamesItemsContainedTotal = _loc11_.items.length;
                  _loc12_.cachedGamesItemsContainedTotal += _loc11_.items.length;
                  this._itemSetsOrganizationalStructureTracker.recordItemSets_InAveragePage_ItemsInGroup(_loc11_.items.length);
                  for each(_loc20_ in _loc11_.items)
                  {
                     if(_loc20_.getGameItem())
                     {
                        _loc8_.push(_loc20_);
                        _loc12_.cachedGamesItemsContainedCostTotal += _loc20_.getGameItem().price;
                     }
                  }
               }
               this._itemSetsOrganizationalStructureTracker.recordItemSets_InAveragePage_Items(_loc12_.cachedGamesItemsContainedTotal);
            }
            this._itemSetsOrganizationalStructureTracker.setAllGroupNames(_loc10_);
            this._itemSetsOrganizationalStructureTracker.setAllPagesNames(_loc9_);
            this._itemSetsOrganizationalStructureTracker.setItemSets_TotalPages_Count(_loc6_.length);
            this._itemSetsOrganizationalStructureTracker.setItemSets_TotalBlocks_Count(_loc7_.length);
            this._itemSetsOrganizationalStructureTracker.setItemSets_TotalItems_Count(_loc8_.length);
            _loc6_.sortOn("cachedGamesItemsContainedTotal",Array.NUMERIC);
            _loc13_ = _loc6_[0];
            _loc14_ = _loc6_[Math.floor((_loc6_.length - 1) / 2)];
            _loc15_ = _loc6_[_loc6_.length - 1];
            if(_loc5_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_FirstPageInDropDown_TotalGroups_Count_InASession(_loc5_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_FirstPageInDropDown_TotalItems_Count_InASession(_loc5_.cachedGamesItemsContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_FirstPageInDropDown_TotalGoldCost_InASession(_loc5_.cachedGamesItemsContainedCostTotal);
               for each(_loc11_ in _loc5_.blocks)
               {
                  this._itemSetsOrganizationalStructureTracker.recordItemSets_InFirstPage_ItemsInGroup(_loc11_.items.length);
               }
            }
            if(_loc13_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_MinPageByItems_TotalGroups_Count_InASession(_loc13_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_MinPageByItems_TotalItems_Count_InASession(_loc13_.cachedGamesItemsContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_MinPageByItems_TotalGoldCost_InASession(_loc13_.cachedGamesItemsContainedCostTotal);
               for each(_loc11_ in _loc13_.blocks)
               {
                  this._itemSetsOrganizationalStructureTracker.recordItemSets_InMinPage_ItemsInGroup(_loc11_.items.length);
               }
            }
            if(_loc14_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_MedianPageByItems_TotalGroups_Count_InASession(_loc14_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_MedianPageByItems_TotalItems_Count_InASession(_loc14_.cachedGamesItemsContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_MedianPageByItems_TotalGoldCost_InASession(_loc14_.cachedGamesItemsContainedCostTotal);
               for each(_loc11_ in _loc14_.blocks)
               {
                  this._itemSetsOrganizationalStructureTracker.recordItemSets_InMedianPage_ItemsInGroup(_loc11_.items.length);
               }
            }
            if(_loc15_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_LargestPageByItems_TotalGroups_Count_InASession(_loc15_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_LargestPageByItems_TotalItems_Count_InASession(_loc15_.cachedGamesItemsContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_LargestPageByItems_TotalGoldCost_InASession(_loc15_.cachedGamesItemsContainedCostTotal);
               for each(_loc11_ in _loc15_.blocks)
               {
                  this._itemSetsOrganizationalStructureTracker.recordItemSets_InMaxPage_ItemsInGroup(_loc11_.items.length);
               }
            }
            _loc6_.sortOn("cachedBlocksContainedTotal",Array.NUMERIC);
            _loc16_ = _loc6_[Math.floor((_loc6_.length - 1) / 2)];
            _loc17_ = _loc6_[_loc6_.length - 1];
            if(_loc16_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_MedianPageByGroups_TotalGroups_Count_InASession(_loc16_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_MedianPageByGroups_TotalItems_Count_InASession(_loc16_.cachedGamesItemsContainedTotal);
            }
            if(_loc17_ != null)
            {
               this._itemSetsOrganizationalStructureTracker.setItemSets_LargestPageByGroups_TotalGroups_Count_InASession(_loc17_.cachedBlocksContainedTotal);
               this._itemSetsOrganizationalStructureTracker.setItemSets_LargestPageByGroups_TotalItems_Count_InASession(_loc17_.cachedGamesItemsContainedTotal);
            }
         }
      }
      
      private function createNewBlankItemPage() : ItemSet
      {
         var _loc1_:ItemSet = new ItemSet();
         _loc1_.blocks = new Vector.<ItemSetBlock>();
         var _loc2_:ItemSetBlock = new ItemSetBlock();
         _loc2_.type = ItemSetBlockType.STARTING;
         _loc1_.blocks.push(_loc2_);
         _loc1_.title = ResourceManager.getInstance().getString("itemBrowser","customItemSet") + " " + (this._model.getItemSets().length + 1);
         return _loc1_;
      }
      
      public function removeItemFromBlock(param1:ItemSetBlock, param2:ItemSetItem) : void
      {
         var _loc3_:ItemSet = null;
         if(Boolean(param1) && Boolean(param2))
         {
            param1.removeItem(param2);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksHadItemRemovedFromContents_Count_InASession();
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksUpdatedContents_Count_InASession();
            _loc3_ = this._model.getActiveItemSet();
            if(_loc3_)
            {
               _loc3_.setIsDirty(true);
            }
         }
      }
      
      public function changeActiveItemSet(param1:ItemSet) : void
      {
         if(Boolean(this._model) && this._model.getActiveItemSet() != param1)
         {
            this._model.setActiveItemSet(param1);
         }
      }
      
      private function exportSuccessHandler() : void
      {
      }
      
      public function saveItemSets() : void
      {
         this._dao.saveMyItemSets(this._model.getItemSets(),this.saveItemsSuccess,this.saveItemsError);
         this._model.setItemSetsDirty(false);
      }
      
      public function deleteBlock(param1:ItemSetBlock) : void
      {
         if(this._model.getActiveItemSet() != null && this._model.getActiveItemSet().blocks.indexOf(param1) >= 0)
         {
            this._model.getActiveItemSet().removeBlock(param1);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksDeleted_Count_InASession();
         }
      }
      
      public function addGameItemToBlock(param1:ItemSetBlock, param2:GameItem, param3:int = 0) : void
      {
         var _loc4_:ItemSetItem = null;
         var _loc5_:ItemSet = null;
         if(Boolean(param1) && Boolean(param2))
         {
            _loc4_ = new ItemSetItem(param2);
            param1.addItemAt(_loc4_,param3);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksHadItemAddedToContents_Count_InASession();
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksUpdatedContents_Count_InASession();
            this.trackAddItemToBlockPosition(param3,param1.items.length);
            _loc5_ = this._model.getActiveItemSet();
            if(_loc5_)
            {
               _loc5_.setIsDirty(true);
            }
         }
      }
      
      private function itemSetPageNameAlreadyExists(param1:String, param2:ItemSet) : Boolean
      {
         var _loc3_:ItemSet = null;
         for each(_loc3_ in this._model.getItemSets())
         {
            if(_loc3_ != param2 && param1 == _loc3_.title)
            {
               return true;
            }
         }
         return false;
      }
      
      public function addExistingItemPage(param1:ItemSet) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ItemSetChampion = null;
         if(param1)
         {
            for each(_loc2_ in param1.getAssignedChampions())
            {
               _loc3_ = this._itemSetChampionsDictionary[_loc2_] as ItemSetChampion;
               if(_loc3_)
               {
                  _loc3_.addAssignedItemSet(param1);
               }
            }
            param1.setIsDirty(true);
            this._model.addItemPage(param1);
            this._model.setActiveItemSet(param1);
            this._model.setItemSetsDirty(true);
         }
      }
      
      public function changeItemStackCount(param1:ItemSetItem, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ItemSet = null;
         if(Boolean(param1 && param1.getStacks()) && Boolean(param1.getGameItem()) && param2 != 0)
         {
            _loc3_ = int(param1.getGameItem().stacks);
            if(param1.getStacks() + param2 > _loc3_)
            {
               param1.setStacks(_loc3_);
            }
            else
            {
               if(param1.getStacks() + param2 < 1)
               {
                  return;
               }
               param1.setStacks(param1.getStacks() + param2);
            }
            this._model.setItemSetsDirty(true);
            _loc4_ = this._model.getActiveItemSet();
            if(_loc4_)
            {
               _loc4_.setIsDirty(true);
            }
         }
      }
      
      public function changeBlockTitle(param1:ItemSetBlock, param2:String) : void
      {
         param1.setTitle(param2);
         var _loc3_:ItemSet = this._model.getActiveItemSet();
         if(_loc3_)
         {
            _loc3_.setIsDirty(true);
         }
         this._model.setItemSetsDirty(true);
         this._itemSetsBehaviorTracker.incrementItemSets_BlocksRenamed_Count_InASession();
      }
      
      public function multipleItemSetsToJSON(param1:Vector.<ItemSet>) : String
      {
         return this._dao.multipleItemSetsToJSON(param1);
      }
      
      public function changePageTitle(param1:String) : void
      {
         var _loc2_:ItemSet = this._model.getActiveItemSet();
         if(_loc2_)
         {
            _loc2_.title = this.getUniquePageNameFromRequestedName(param1,_loc2_);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_PagesRenamed_Count_InASession();
         }
      }
      
      public function moveBlock(param1:ItemSetBlock, param2:int) : void
      {
         var _loc4_:ItemSetBlock = null;
         var _loc3_:* = param2;
         while(_loc3_ > 0)
         {
            _loc4_ = this._model.getActiveItemSet().blocks[_loc3_ - 1];
            if(_loc4_ != param1)
            {
               break;
            }
            _loc3_--;
         }
         if(_loc4_ != param1)
         {
            this._model.getActiveItemSet().removeBlock(param1);
            this._model.getActiveItemSet().addBlockAt(param1,this._model.getActiveItemSet().blocks.indexOf(_loc4_) + 1);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksMoved_Count_InASession();
         }
      }
      
      private function saveItemsSuccess() : void
      {
         trace("Save success!");
         this.setDirtyStatusOnAllItemSets(false);
      }
      
      public function createBlockFromItemSetItem(param1:ItemSetItem) : void
      {
         var _loc2_:ItemSetBlock = null;
         if(this._model.getActiveItemSet() != null)
         {
            _loc2_ = new ItemSetBlock();
            if(param1 != null)
            {
               _loc2_.addItem(param1);
            }
            _loc2_.setTitle(ResourceManager.getInstance().getString("itemBrowser","newBlockTitle"));
            this._model.getActiveItemSet().addBlock(_loc2_);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksCreated_Count_InASession();
         }
      }
      
      private function gotMyItems(param1:Vector.<ItemSet>) : void
      {
         this.mapItemSetsToChampions(param1,this._model.getItemSetChampions());
         this._model.setItemSets(param1);
         this.setDirtyStatusOnAllItemSets(false);
      }
      
      public function changeGlobalnessForMapsOnCurrentItemSet(param1:Boolean) : void
      {
         var _loc2_:ItemSet = this._model.getActiveItemSet();
         if(_loc2_)
         {
            _loc2_.setIsGlobalForMaps(param1);
            this._model.setItemSetsDirty(true);
         }
      }
      
      public function setMapAssignments(param1:Vector.<uint>) : void
      {
         var _loc2_:ItemSet = this._model.getActiveItemSet();
         if(_loc2_)
         {
            _loc2_.setAssignedMaps(param1);
            this._model.setItemSetsDirty(true);
         }
      }
      
      private function mapItemSetsToChampions(param1:Vector.<ItemSet>, param2:Vector.<ItemSetChampion>) : void
      {
         var _loc3_:ItemSetChampion = null;
         var _loc4_:Vector.<ItemSet> = null;
         var _loc5_:ItemSet = null;
         for each(_loc3_ in param2)
         {
            _loc4_ = new Vector.<ItemSet>();
            for each(_loc5_ in param1)
            {
               if(_loc5_.getAssignedChampions().indexOf(_loc3_.getChampionID()) > -1)
               {
                  _loc4_.push(_loc5_);
               }
            }
            _loc3_.setAssignedItemSets(_loc4_);
         }
      }
      
      public function setupChampionData(param1:ArrayCollection) : void
      {
         var _loc2_:ItemSetChampion = null;
         var _loc6_:Champion = null;
         this._itemSetChampionsDictionary = new Dictionary();
         var _loc3_:Vector.<ItemSetChampion> = new Vector.<ItemSetChampion>();
         var _loc4_:Dictionary = new Dictionary();
         var _loc5_:Dictionary = new Dictionary();
         for each(_loc6_ in param1)
         {
            if(_loc6_.championData)
            {
               _loc2_ = new ItemSetChampion(_loc6_);
               _loc3_.push(_loc2_);
               this._itemSetChampionsDictionary[_loc2_.getChampionID()] = _loc2_;
               _loc4_[_loc6_.skinName] = _loc2_;
               _loc5_[_loc6_.championId] = _loc6_;
            }
         }
         this.mapItemSetsToChampions(this._model.getItemSets(),_loc3_);
         this._model.skinNameToChampionDictionary = _loc4_;
         this._model.championIdToChampionDictionary = this._itemSetChampionsDictionary;
         this._model.setItemSetChampions(_loc3_);
      }
      
      public function sendActiveItemSetJsonToClipboard() : Boolean
      {
         var jsonString:String = null;
         var currentItemSet:ItemSet = this._model.getActiveItemSet();
         if(currentItemSet)
         {
            jsonString = this._dao.itemSetToJSON(currentItemSet);
            if(jsonString != null && jsonString != "")
            {
               try
               {
                  Clipboard.generalClipboard.clear();
                  Clipboard.generalClipboard.setData(ClipboardFormats.TEXT_FORMAT,jsonString);
                  return true;
               }
               catch(e:Error)
               {
                  return false;
               }
            }
         }
         return false;
      }
      
      public function addItemPageForChampion(param1:ItemSetChampion) : void
      {
         var _loc2_:ItemSet = this.createNewBlankItemPage();
         _loc2_.title = this.getUniquePageNameFromRequestedName(_loc2_.title,_loc2_);
         _loc2_.setIsGlobalForChampions(false);
         _loc2_.addAssignedChampion(param1.getChampionID());
         param1.addAssignedItemSet(_loc2_);
         this._model.addItemPage(_loc2_);
         this._model.setActiveItemSet(_loc2_);
         this._model.setItemSetsDirty(true);
      }
      
      private function trackAddItemToBlockPosition(param1:int, param2:int) : void
      {
         if(param1 == 0)
         {
            this._itemSetsBehaviorTracker.incrementItemSets_AddItemToBlockAtBeginning_Count_InASession();
         }
         else if(param1 == param2 - 1)
         {
            this._itemSetsBehaviorTracker.incrementItemSets_AddItemToBlockAtEnd_Count_InASession();
         }
         else
         {
            this._itemSetsBehaviorTracker.incrementItemSets_AddItemToBlockAtMiddle_Count_InASession();
         }
      }
      
      public function getItemSetFromJSON(param1:String) : ItemSet
      {
         var _loc2_:ItemSet = null;
         return this._dao.jsonToItemSet(param1);
      }
      
      public function setChampionAssignments(param1:Vector.<uint>) : void
      {
         var _loc3_:ItemSetChampion = null;
         var _loc2_:ItemSet = this._model.getActiveItemSet();
         if(_loc2_)
         {
            for each(_loc3_ in this._model.getItemSetChampions())
            {
               if(param1.indexOf(_loc3_.getChampionID()) > -1)
               {
                  _loc3_.addAssignedItemSet(_loc2_);
               }
               else
               {
                  _loc3_.removeAssignedItemSet(_loc2_);
               }
            }
            _loc2_.setAssignedChampions(param1);
            this._model.setItemSetsDirty(true);
         }
      }
      
      private function handleAvailableMapsChanged() : void
      {
         var _loc2_:GameMap = null;
         var _loc1_:Vector.<GameMap> = new Vector.<GameMap>();
         for each(_loc2_ in this._appConfig.availableMaps)
         {
            _loc1_.push(_loc2_);
         }
         this._model.setAvailableMaps(_loc1_);
      }
      
      public function get itemSetsBehaviorTracker() : IItemSetsBehaviorTracker
      {
         return this._itemSetsBehaviorTracker;
      }
      
      private function setDirtyStatusOnAllItemSets(param1:Boolean) : void
      {
         var _loc2_:ItemSet = null;
         for each(_loc2_ in this._model.getItemSets())
         {
            _loc2_.setIsDirty(param1);
         }
      }
      
      private function handleChampionsRetrieved(param1:Event) : void
      {
         var _loc2_:Array = null;
         var _loc3_:IChampionFilter = null;
         if(Boolean(this._inventoryProvider.getInventory()) && Boolean(this._inventoryProvider.getInventory().champions))
         {
            this.setupChampionData(this._inventoryProvider.getInventory().champions);
            _loc2_ = this._inventoryProvider.getInventoryController().createSearchTags();
            _loc3_ = this._inventoryProvider.getInventoryController().createChampionFilter(_loc2_);
            this._model.setChampionFilter(_loc3_);
            this._model.setChampionFilterTags(_loc2_);
         }
      }
      
      private function setModel(param1:ItemSetsModel) : void
      {
         this._model = param1;
      }
      
      public function getMultipleItemSetsFromJSON(param1:String) : Vector.<ItemSet>
      {
         var _loc2_:Vector.<ItemSet> = new Vector.<ItemSet>();
         return this._dao.jsonToMultipleItemSets(param1);
      }
      
      public function changeGlobalnessForChampionsOnCurrentItemSet(param1:Boolean) : void
      {
         var _loc2_:ItemSet = this._model.getActiveItemSet();
         if(_loc2_)
         {
            _loc2_.setIsGlobalForChampions(param1);
            this._model.setItemSetsDirty(true);
         }
      }
      
      public function createBlock(param1:GameItem) : void
      {
         var _loc2_:ItemSetBlock = null;
         var _loc3_:ItemSetItem = null;
         if(this._model.getActiveItemSet() != null)
         {
            _loc2_ = new ItemSetBlock();
            if(param1 != null)
            {
               _loc3_ = new ItemSetItem(param1);
               _loc2_.addItem(_loc3_);
            }
            _loc2_.setTitle(ResourceManager.getInstance().getString("itemBrowser","newBlockTitle"));
            this._model.getActiveItemSet().addBlock(_loc2_);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksCreated_Count_InASession();
         }
      }
      
      public function getModel() : ItemSetsModel
      {
         return this._model;
      }
      
      private function getUniquePageNameFromRequestedName(param1:String, param2:ItemSet) : String
      {
         var _loc3_:int = 0;
         var _loc4_:String = param1;
         while(this.itemSetPageNameAlreadyExists(_loc4_,param2))
         {
            _loc3_++;
            _loc4_ = param1 + " (" + _loc3_ + ")";
         }
         return _loc4_;
      }
      
      private function exportErrorHandler() : void
      {
      }
      
      public function addItemSetItemToBlock(param1:ItemSetBlock, param2:ItemSetItem, param3:int = 0) : void
      {
         var _loc4_:ItemSet = null;
         if(Boolean(param1) && Boolean(param2) && Boolean(param2.getGameItem()))
         {
            param1.addItemAt(new ItemSetItem(param2.getGameItem(),param2.getStacks()),param3);
            this._model.setItemSetsDirty(true);
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksHadItemAddedToContents_Count_InASession();
            this._itemSetsBehaviorTracker.incrementItemSets_BlocksUpdatedContents_Count_InASession();
            this.trackAddItemToBlockPosition(param3,param1.items.length);
            _loc4_ = this._model.getActiveItemSet();
            if(_loc4_)
            {
               _loc4_.setIsDirty(true);
            }
         }
      }
      
      public function writeItemSetsToFile(param1:Vector.<ItemSet>, param2:File) : Boolean
      {
         var itemSetsJson:String;
         var fileStream:FileStream = null;
         var itemSets:Vector.<ItemSet> = param1;
         var file:File = param2;
         if(!itemSets || itemSets.length == 0)
         {
            return false;
         }
         itemSetsJson = this.multipleItemSetsToJSON(itemSets);
         try
         {
            fileStream = new FileStream();
            fileStream.open(file,FileMode.WRITE);
            fileStream.writeMultiByte(itemSetsJson,"utf-8");
         }
         catch(e:Error)
         {
            return false;
         }
         return true;
      }
      
      public function deleteActiveItemSet() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:ItemSetChampion = null;
         var _loc1_:ItemSet = this._model.getActiveItemSet();
         var _loc2_:Vector.<ItemSet> = this._model.getItemSets();
         if(!_loc2_)
         {
            return;
         }
         if(_loc1_)
         {
            for each(_loc3_ in _loc1_.getAssignedChampions())
            {
               _loc5_ = this._itemSetChampionsDictionary[_loc3_] as ItemSetChampion;
               if(_loc5_)
               {
                  _loc5_.removeAssignedItemSet(_loc1_);
               }
            }
            _loc4_ = this._model.getItemSets().indexOf(_loc1_);
            if(_loc4_ == -1)
            {
               return;
            }
            this._model.removeItemSetPage(_loc1_);
            this._itemSetsBehaviorTracker.incrementItemSets_PagesDeleted_Count_InASession();
            if(_loc2_.length == 0)
            {
               this._model.setActiveItemSet(null);
            }
            else if(_loc2_.length > 0 && _loc1_ == this._model.getActiveItemSet())
            {
               if(_loc4_ == 0)
               {
                  this._model.setActiveItemSet(_loc2_[0]);
               }
               else if(_loc2_.length >= _loc4_ - 1)
               {
                  this._model.setActiveItemSet(_loc2_[_loc4_ - 1]);
               }
            }
            this._model.setItemSetsDirty(true);
         }
      }
   }
}

