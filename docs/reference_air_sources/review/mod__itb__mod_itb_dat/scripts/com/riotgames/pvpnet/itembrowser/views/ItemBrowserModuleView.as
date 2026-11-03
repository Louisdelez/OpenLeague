package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.tooltip.IToolTipManager;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.controller.ItemSetsController;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.pvpnet.tips.config.ToolTipConfig;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import mx.resources.ResourceManager;
   
   public class ItemBrowserModuleView extends RiotModuleView implements IMainScreen
   {
      
      private var _itemSetsOrganizationalStructureTracker:IItemSetsOrganizationalStructureTracker;
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var sizer:SpriteProxy;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _itemEditorMainView:ItemSetEditorView;
      
      private var _itemSetsController:ItemSetsController;
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker;
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _isFirstVisit:Boolean = true;
      
      private var _itemBrowserModel:ItemBrowserModel;
      
      private var _mainAssetUrlRequest:URLRequest;
      
      public function ItemBrowserModuleView(param1:IContext, param2:RiotModuleInfo, param3:ItemBrowserModel, param4:ItemSetsModel, param5:ItemBrowserController, param6:ItemSetsController, param7:IItemSetsBehaviorTracker, param8:IItemSetsOrganizationalStructureTracker)
      {
         this._moduleInfo = param2;
         this._itemBrowserController = param5;
         this._itemSetsController = param6;
         this._itemSetsBehaviorTracker = param7;
         this._itemSetsOrganizationalStructureTracker = param8;
         this._itemSetsModel = param4;
         this._itemBrowserModel = param3;
         super(param1,new MovieClip());
         setLinkage("ItemBrowserMainView");
         this.show();
      }
      
      private function onClosePageAlertClosed(param1:AlertAction) : void
      {
         if(param1.affirmativeResponse)
         {
            this._itemSetsController.saveItemSets();
         }
         else
         {
            this._itemSetsController.revertItemSets();
         }
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         this._itemSetsModel = param1;
         this._itemEditorMainView.setItemSetsModel(this._itemSetsModel);
      }
      
      public function hide() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:AlertAction = null;
         if(this._itemSetsModel.getItemSetsDirty())
         {
            _loc1_ = ResourceManager.getInstance().getString("itemBrowser","unsaved_changes_title");
            _loc2_ = ResourceManager.getInstance().getString("itemBrowser","unsaved_changes_text");
            if(_loc1_ == null)
            {
               _loc1_ = "**unsaved_changes_title";
            }
            if(_loc2_ == null)
            {
               _loc2_ = "**unsaved_changes_text";
            }
            _loc3_ = new AlertAction(_loc1_,_loc2_);
            _loc3_.showNegative = true;
            _loc3_.setYesNoLabels();
            _loc3_.getCompleted().addOnce(this.onClosePageAlertClosed);
            _loc3_.add();
         }
         this._hideCompleted.dispatch();
         this._itemSetsController.snapshotStructureForTracking();
         this._itemSetsBehaviorTracker.stopItemSets_PageVisit();
      }
      
      public function getIsThinChrome() : Boolean
      {
         return false;
      }
      
      public function setItemBrowserModel(param1:ItemBrowserModel) : void
      {
         this._itemBrowserModel = param1;
         this._itemEditorMainView.setItemBrowserModel(this._itemBrowserModel);
      }
      
      public function getHasNavigation() : Boolean
      {
         return true;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._itemEditorMainView = new ItemSetEditorView(this,null,this._itemSetsBehaviorTracker,this._itemSetsOrganizationalStructureTracker);
         setTimelineChildByName("itemEditorView",this._itemEditorMainView);
         this.sizer = new SpriteProxy(this);
         setTimelineChildByName("sizer",this.sizer);
      }
      
      override protected function initializeDependencies() : void
      {
         var _loc1_:ToolTipConfig = new ToolTipConfig();
         _loc1_.showDelay = 350;
         var _loc2_:IToolTipManager = TipsProviderProxy.instance.createWindowToolTipManager(this,_loc1_);
         registerDependency(IToolTipManager,_loc2_);
         registerDependency(ItemBrowserController,this._itemBrowserController);
         registerDependency(ItemSetsController,this._itemSetsController);
         registerDependency(ItemBrowserModel,this._itemBrowserModel);
         registerDependency(ItemSetsModel,this._itemSetsModel);
         super.initializeDependencies();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,this.sizer.getWidth(),this.sizer.getHeight());
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function show() : void
      {
         if(this._isFirstVisit)
         {
            this._mainAssetUrlRequest = new URLRequest(this._moduleInfo.getPath() + "assets/itemBrowserAssets.swf");
            loadAssets(this._mainAssetUrlRequest);
            this._itemSetsBehaviorTracker.startItemSets_PageVisit();
            this._isFirstVisit = false;
         }
      }
   }
}

