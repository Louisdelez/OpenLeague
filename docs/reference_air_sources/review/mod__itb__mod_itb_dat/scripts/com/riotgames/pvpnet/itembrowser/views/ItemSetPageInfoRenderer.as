package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IItemRenderer;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemSetPageInfoRenderer extends SpriteProxy implements IItemRenderer
   {
      
      private static const BACKGROUND_STATE_GOOD:String = "goodState";
      
      private static const BACKGROUND_STATE_WARN:String = "warnState";
      
      private static const BACKGROUND_STATE_BAD:String = "badState";
      
      private var _background:StatefulView;
      
      private var _textField:TextFieldProxy;
      
      private var _itemSet:ItemSet;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _index:uint;
      
      private var _bottomDivider:SpriteProxy;
      
      public function ItemSetPageInfoRenderer(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("ItemPageInfoRenderer");
         this._itemBrowserController = getDependency(ItemBrowserController);
      }
      
      private function updateDescription() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:String = "";
         if(this._itemSet)
         {
            if(this._itemSet.getIsGlobalForChampions() && this._itemSet.getIsGlobalForMaps())
            {
               _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_association_all");
            }
            else
            {
               if(this._itemSet.getIsGlobalForChampions())
               {
                  _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_championAssociation_global");
               }
               else
               {
                  _loc2_ = int(this._itemSet.getAssignedChampions().length);
                  switch(_loc2_)
                  {
                     case 0:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_championAssociation_none");
                        break;
                     case 1:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_championAssociation_one");
                        break;
                     default:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_championAssociation_many",[_loc2_]);
                  }
               }
               _loc1_ += "\n\n";
               if(this._itemSet.getIsGlobalForMaps())
               {
                  _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_global");
               }
               else
               {
                  _loc3_ = int(this._itemSet.getAssignedMaps().length);
                  switch(_loc3_)
                  {
                     case 0:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_none");
                        break;
                     case 1:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_one");
                        break;
                     default:
                        _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_many",[_loc3_]);
                  }
               }
            }
         }
         this._textField.setText(_loc1_);
      }
      
      private function handleEditButtonClick(param1:MouseEvent = null) : void
      {
         this._itemBrowserController.changeItemSetsViewState(ItemBrowserModel.VIEW_STATE_ASSOCIATING);
      }
      
      private function removePageListeners() : void
      {
         if(this._itemSet)
         {
            this._itemSet.getAssignedChampionsChanged().remove(this.updateDescription);
            this._itemSet.getAssignedMapsChanged().remove(this.updateDescription);
            this._itemSet.getIsGlobalForChampionsChanged().remove(this.updateDescription);
            this._itemSet.getIsGlobalForMapsChanged().remove(this.updateDescription);
         }
      }
      
      private function addPageListeners() : void
      {
         if(this._itemSet)
         {
            this._itemSet.getAssignedChampionsChanged().add(this.updateDescription);
            this._itemSet.getAssignedMapsChanged().add(this.updateDescription);
            this._itemSet.getIsGlobalForChampionsChanged().add(this.updateDescription);
            this._itemSet.getIsGlobalForMapsChanged().add(this.updateDescription);
         }
      }
      
      public function setIndex(param1:uint) : void
      {
         this._index = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._textField.setExplicitSize(param1,param2);
         this._background.setExplicitSize(NaN,_loc3_.y + 10);
         this._bottomDivider.setExplicitPosition(NaN,_loc3_.y + 10);
         return getAsset().getBounds(null);
      }
      
      override protected function createChildren() : void
      {
         this._textField = new TextFieldProxy(this);
         setTimelineChildByName("textField",this._textField);
         this._textField.setAutoSize(TextFieldAutoSize.LEFT);
         this._textField.getLayoutInvalidated().add(invalidateLayout);
         this._textField.setMouseWheelEnabled(false);
         this._textField.setVerticalScrollEnabled(false);
         this._background = new StatefulView(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         this._background.setTransformBehavior(_loc1_);
         setTimelineChildByName("background",this._background);
         this._bottomDivider = new SpriteProxy(this);
         setTimelineChildByName("bottomDivider",this._bottomDivider);
         super.createChildren();
      }
      
      public function getIndex() : uint
      {
         return this._index;
      }
      
      public function getData() : *
      {
         return this._itemSet;
      }
      
      public function setData(param1:*) : void
      {
         this.removePageListeners();
         this._itemSet = param1 as ItemSet;
         this.addPageListeners();
         this.updateDescription();
      }
      
      override public function destroy() : void
      {
         this.removePageListeners();
         super.destroy();
      }
   }
}

