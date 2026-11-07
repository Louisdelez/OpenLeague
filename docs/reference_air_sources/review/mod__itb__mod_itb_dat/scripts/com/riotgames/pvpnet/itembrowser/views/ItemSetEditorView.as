package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsOrganizationalStructureTracker;
   import flash.display.MovieClip;
   
   public class ItemSetEditorView extends StatefulView
   {
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker;
      
      private var _itemNavigatorView:ItemBrowserItemNavigatorView;
      
      private var _championMappingView:ItemSetAssociationManagementView;
      
      private var _itemSetPageViewer:ItemSetTabbedPageView;
      
      private var _itemBrowserModel:ItemBrowserModel;
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _itemSetImportView:ItemSetImportView;
      
      private var _itemSetSetManager:ItemSetChampionCentricSetsView;
      
      private var _itemSetsOrganizationalStructureTracker:IItemSetsOrganizationalStructureTracker;
      
      public function ItemSetEditorView(param1:IContext, param2:MovieClip = null, param3:IItemSetsBehaviorTracker = null, param4:IItemSetsOrganizationalStructureTracker = null)
      {
         this._itemSetsBehaviorTracker = param3;
         this._itemSetsOrganizationalStructureTracker = param4;
         super(param1,param2);
         setCurrentState(ItemBrowserModel.VIEW_STATE_BUILDING);
      }
      
      override public function destroy() : void
      {
         super.destroy();
      }
      
      private function handleShowImportDialogueRequested() : void
      {
         if(ClientConfig.instance.showItemSetSharing)
         {
            this._itemSetImportView.initializeView();
            this._itemSetImportView.setVisible(true);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._itemNavigatorView = new ItemBrowserItemNavigatorView(this,null,this._itemSetsBehaviorTracker,this._itemSetsOrganizationalStructureTracker);
         setTimelineChildByName("itemBrowserItemNavigator",this._itemNavigatorView);
         this._itemSetPageViewer = new ItemSetTabbedPageView(this);
         setTimelineChildByName("itemSetPageViewer",this._itemSetPageViewer);
         this._itemSetSetManager = new ItemSetChampionCentricSetsView(this);
         setTimelineChildByName("itemSetListContainer",this._itemSetSetManager);
         this._itemSetSetManager.getShowImportDialogueRequested().add(this.handleShowImportDialogueRequested);
         this._itemSetImportView = new ItemSetImportView(this);
         setTimelineChildByName("itemSetImportView",this._itemSetImportView);
         this._itemSetImportView.setVisible(false);
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         if(this._itemSetsModel != param1)
         {
            this._itemSetsModel = param1;
            this._itemSetSetManager.setModel(this._itemSetsModel);
            this._itemSetPageViewer.setModel(this._itemSetsModel);
            if(ClientConfig.instance.showItemSetSharing)
            {
               this._itemSetImportView.setModel(this._itemSetsModel);
            }
         }
      }
      
      public function setItemBrowserModel(param1:ItemBrowserModel) : void
      {
         if(this._itemBrowserModel != param1)
         {
            this._itemBrowserModel = param1;
            this._itemNavigatorView.setModel(this._itemBrowserModel);
         }
      }
   }
}

