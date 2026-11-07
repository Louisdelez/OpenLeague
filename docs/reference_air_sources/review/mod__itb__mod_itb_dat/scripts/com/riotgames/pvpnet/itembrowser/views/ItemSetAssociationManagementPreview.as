package com.riotgames.pvpnet.itembrowser.views
{
   import blix.components.renderer.IItemRenderer;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.vo.HorizontalAlign;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.MovieClip;
   
   public class ItemSetAssociationManagementPreview extends LayoutContainerView implements IItemRenderer
   {
      
      private var _model:ItemSetsModel;
      
      private var _championAssignmentsPreview:ItemSetChampionAssociationsPreview;
      
      private var _activeItemSet:ItemSet;
      
      private var _index:uint;
      
      private var _mapAssignmentsPreview:ItemSetMapAssociationsPreview;
      
      public function ItemSetAssociationManagementPreview(param1:IContext, param2:MovieClip = null)
      {
         if(param2 == null)
         {
            param2 = new MovieClip();
         }
         super(param1,param2);
      }
      
      public function getData() : *
      {
         return this._activeItemSet;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.setGap(0);
         _loc1_.setHorizontalAlign(HorizontalAlign.CENTER);
         setLayoutAlgorithm(_loc1_);
         this._mapAssignmentsPreview = new ItemSetMapAssociationsPreview(this);
         addElement(this._mapAssignmentsPreview);
         this._championAssignmentsPreview = new ItemSetChampionAssociationsPreview(this);
         addElement(this._championAssignmentsPreview);
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         this._model = param1;
         this._mapAssignmentsPreview.setModel(param1);
         this._championAssignmentsPreview.setModel(param1);
      }
      
      public function setData(param1:*) : void
      {
         this.setCurrentItemSet(param1 as ItemSet);
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      public function setCurrentItemSet(param1:ItemSet) : void
      {
         if(this._activeItemSet != param1)
         {
            this._activeItemSet = param1;
            this._mapAssignmentsPreview.setItemSet(param1);
            this._championAssignmentsPreview.setItemSet(param1);
         }
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
   }
}

