package com.riotgames.platform.module.masteries.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.ToolTipManager;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import com.riotgames.platform.gameclient.masteries.TalentEntry;
   import com.riotgames.platform.masteries.events.MasteryEvent;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import com.riotgames.platform.module.masteries.views.renderers.MasteryItemRendererProxy;
   import com.riotgames.platform.module.masteries.views.renderers.MasteryLinkRendererProxy;
   import com.riotgames.platform.module.masteries.views.renderers.tooltips.MasteryItemToolTip;
   import flash.utils.Dictionary;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   public class MasteriesTreeView extends SpriteProxy
   {
      
      public static var NO_GAMECODE:int = 0;
      
      private static const PADDING_LEFT:int = 265;
      
      private static const PADDING_TOP:int = 60;
      
      private static const MASTERY_ICON_HEIGHT:int = 67;
      
      private static const MASTERY_ICON_WIDTH:int = 50;
      
      private static const MASTERY_ICON_HORIZONTAL_SPACING:int = 11;
      
      private static const MASTERY_ICON_VERTICAL_SPACING:int = 4;
      
      private static const MASTERY_LINK_X_OFFSET:int = -3;
      
      private var utilityDisplayText:TextFieldProxy;
      
      private var offenseDisplayText:TextFieldProxy;
      
      private var defaultToolTipHandler:ToolTipHandler;
      
      private var _masteryItemRenderersByMasteryID:Dictionary;
      
      private var itemToolTip:MasteryItemToolTip;
      
      private var _pageMaxedOut:Boolean;
      
      private var _localSummoner:Boolean = true;
      
      private var localizedGroupNames:Array;
      
      private var masteriesItemsNeedingArrows:Array;
      
      private var _page:MasteryPage;
      
      private var defenseDisplayText:TextFieldProxy;
      
      public function MasteriesTreeView(param1:IContext)
      {
         super(param1);
         setLinkage("MasteryTreesView");
      }
      
      private function addMasteryRenderers() : void
      {
         var _loc1_:Talent = null;
         this.masteriesItemsNeedingArrows = new Array();
         this._masteryItemRenderersByMasteryID = new Dictionary();
         for each(_loc1_ in MasteriesUtils.getMasteriesList())
         {
            this.addMasteryItem(_loc1_);
         }
         this.drawArrows();
         this.updateMasteryRanks();
         this.updateItemStates();
      }
      
      override public function destroy() : void
      {
         if(this._page != null)
         {
            this._page.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
         }
         this.defaultToolTipHandler.destroy();
         this.itemToolTip.destroy();
         this.masteriesItemsNeedingArrows = null;
         super.destroy();
      }
      
      public function set masteryPage(param1:MasteryPage) : void
      {
         if(this._page !== param1)
         {
            if(this._page != null)
            {
               this._page.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
            }
            this._page = param1;
            this._page.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPageEntriesCollectionChange);
         }
         this.updateMasteryRanks();
         this.updateItemStates();
      }
      
      public function get masteryPage() : MasteryPage
      {
         return this._page;
      }
      
      override protected function createChildren() : void
      {
         this.itemToolTip = new MasteryItemToolTip(this);
         this.defaultToolTipHandler.setView(this.itemToolTip);
         this.defaultToolTipHandler.showDelay = 0;
         this.offenseDisplayText = new TextFieldProxy(this);
         this.defenseDisplayText = new TextFieldProxy(this);
         this.utilityDisplayText = new TextFieldProxy(this);
         this.setTimelineChildByName("offenseDisplayText",this.offenseDisplayText);
         this.setTimelineChildByName("defenseDisplayText",this.defenseDisplayText);
         this.setTimelineChildByName("utilityDisplayText",this.utilityDisplayText);
         this.addMasteryRenderers();
      }
      
      private function updateItemStates() : void
      {
         var _loc1_:MasteryItemRendererProxy = null;
         var _loc2_:Talent = null;
         var _loc3_:Talent = null;
         var _loc4_:int = 0;
         var _loc5_:TalentEntry = null;
         for each(_loc1_ in this._masteryItemRenderersByMasteryID)
         {
            _loc2_ = MasteriesUtils.getMasteryByID(_loc1_.masteryID);
            _loc3_ = MasteriesUtils.getMasteryByID(_loc2_.prereqTalentGameCode);
            _loc4_ = int(MasteriesUtils.getSpentPointsInGroup(this._page,_loc2_.talentGroupId));
            if(this._page != null && this.pageMaxedOut == false && _loc4_ >= MasteriesUtils.getMasteryRowByMasteryID(_loc2_.tltId).pointsToActivate)
            {
               if(_loc3_ != null)
               {
                  _loc5_ = this._page.getEntryByMasteryID(_loc3_.tltId);
               }
               if(_loc3_ == null || _loc3_ != null && _loc5_ != null && _loc5_.rank == _loc3_.maxRank)
               {
                  _loc1_.activated = true;
               }
               else
               {
                  _loc1_.activated = false;
               }
            }
            else
            {
               _loc1_.activated = false;
            }
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this.defaultToolTipHandler = new ToolTipHandler();
         var _loc1_:ToolTipManager = new ToolTipManager(this,this.defaultToolTipHandler);
         registerDependency(IToolTipManager,_loc1_,false);
      }
      
      private function addMasteryItem(param1:Talent) : void
      {
         var _loc2_:MasteryItemRendererProxy = new MasteryItemRendererProxy(this);
         _loc2_.setX(PADDING_LEFT + (param1.talentGroupId - 1) * 275 + param1.index * (MASTERY_ICON_WIDTH + MASTERY_ICON_HORIZONTAL_SPACING));
         _loc2_.setY(PADDING_TOP + ((param1.talentRowId - 1) % 6 - 1 + 1) * (MASTERY_ICON_HEIGHT + MASTERY_ICON_VERTICAL_SPACING));
         _loc2_.setWidth(MASTERY_ICON_WIDTH);
         _loc2_.setHeight(MASTERY_ICON_HEIGHT);
         _loc2_.talentReference = param1;
         _loc2_.setWeight(2);
         this.addChild(_loc2_);
         this._masteryItemRenderersByMasteryID[_loc2_.masteryID] = _loc2_;
         _loc2_.addEventListener(MasteryEvent.MASTERY_CLICK,this.onMouseClickOnMastery);
         if(param1.prereqTalentGameCode != NO_GAMECODE)
         {
            this.masteriesItemsNeedingArrows.push(_loc2_);
         }
      }
      
      private function onPageEntriesCollectionChange(param1:CollectionEvent) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc4_:Object = null;
         var _loc5_:TalentEntry = null;
         var _loc2_:Boolean = false;
         if(param1.kind == CollectionEventKind.UPDATE)
         {
            for each(_loc3_ in param1.items)
            {
               _loc4_ = _loc3_.source;
               _loc5_ = _loc4_ as TalentEntry;
               if(_loc5_ != null)
               {
                  _loc2_ = true;
               }
            }
         }
         else if(param1.kind == CollectionEventKind.RESET || Boolean(CollectionEventKind.REPLACE))
         {
            _loc2_ = true;
         }
         if(_loc2_)
         {
            this.updateMasteryRanks();
            this.updateItemStates();
         }
      }
      
      private function updateMasteryRanks() : void
      {
         var _loc1_:MasteryItemRendererProxy = null;
         var _loc2_:TalentEntry = null;
         for each(_loc1_ in this._masteryItemRenderersByMasteryID)
         {
            if(_loc1_ != null && this._page != null)
            {
               _loc2_ = this._page.getEntryByMasteryID(_loc1_.masteryID);
               if(_loc2_)
               {
                  _loc1_.rank = _loc2_.rank;
               }
               else
               {
                  _loc1_.rank = 0;
               }
            }
         }
         this.offenseDisplayText.setText(MasteriesUtils.getLocalizedGroupName(1).toUpperCase() + ": " + MasteriesUtils.getSpentPointsInGroup(this._page,1));
         this.defenseDisplayText.setText(MasteriesUtils.getLocalizedGroupName(2).toUpperCase() + ": " + MasteriesUtils.getSpentPointsInGroup(this._page,2));
         this.utilityDisplayText.setText(MasteriesUtils.getLocalizedGroupName(3).toUpperCase() + ": " + MasteriesUtils.getSpentPointsInGroup(this._page,3));
      }
      
      public function set localSummoner(param1:Boolean) : void
      {
         this._localSummoner = param1;
         this.updateItemStates();
      }
      
      private function drawArrows() : void
      {
         var _loc2_:MasteryItemRendererProxy = null;
         var _loc3_:Talent = null;
         var _loc4_:Talent = null;
         var _loc5_:MasteryLinkRendererProxy = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.masteriesItemsNeedingArrows.length)
         {
            _loc2_ = this.masteriesItemsNeedingArrows[_loc1_] as MasteryItemRendererProxy;
            if(_loc2_ != null)
            {
               _loc3_ = MasteriesUtils.getMasteryByID(_loc2_.masteryID);
               _loc4_ = MasteriesUtils.getMasteryByID(_loc3_.prereqTalentGameCode);
               _loc5_ = new MasteryLinkRendererProxy(this);
               _loc5_.lengthIndicator = _loc3_.talentRowId - _loc4_.talentRowId;
               _loc5_.setX(PADDING_LEFT + (_loc4_.talentGroupId - 1) * 275 + _loc4_.index * (_loc2_.getWidth() + MASTERY_ICON_HORIZONTAL_SPACING) + _loc2_.getWidth() * 0.5 - _loc5_.getWidth() * 0.5 + MASTERY_LINK_X_OFFSET);
               _loc5_.setY(PADDING_TOP + (_loc4_.talentRowId % 6 - 1) * (MASTERY_ICON_HEIGHT + MASTERY_ICON_VERTICAL_SPACING) - 2);
               _loc5_.parentMastery = _loc4_;
               _loc5_.childMastery = _loc3_;
               _loc2_.masteryLinkReference = _loc5_;
               _loc2_.setWeight(1);
               _loc5_.setWeight(0);
               addChild(_loc5_);
            }
            _loc1_++;
         }
         this.masteriesItemsNeedingArrows = null;
      }
      
      private function onMouseClickOnMastery(param1:MasteryEvent) : void
      {
         if(this._localSummoner)
         {
            dispatchEvent(param1);
         }
      }
      
      public function get pageMaxedOut() : Boolean
      {
         return this._localSummoner ? this._pageMaxedOut : true;
      }
      
      public function set pageMaxedOut(param1:Boolean) : void
      {
         this._pageMaxedOut = param1;
         this.updateItemStates();
      }
   }
}

