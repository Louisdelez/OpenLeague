package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.ds.ListView;
   import blix.ds.ListX;
   import blix.layout.algorithms.VirtualizedTileLayout;
   import blix.layout.vo.HorizontalAlign;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemSetMapAssociationsPreview extends SpriteProxy
   {
      
      private var _textField:TextFieldProxy;
      
      private var _itemSet:ItemSet;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _index:uint;
      
      private var _mapDataGroup:DataGroup;
      
      private var _background:StatefulView;
      
      private var _mapList:ListView;
      
      private var _model:ItemSetsModel;
      
      private var _bottomDivider:SpriteProxy;
      
      private var _mapRendererFactory:RendererFactory;
      
      public function ItemSetMapAssociationsPreview(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("ItemPageInfoRenderer");
         this._itemBrowserController = getDependency(ItemBrowserController);
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
         var _loc2_:VirtualizedTileLayout = new VirtualizedTileLayout();
         _loc2_.setHorizontalAlign(HorizontalAlign.CENTER);
         this._mapRendererFactory = new RendererFactory(ItemSetMapRendererInactive,[this]);
         this._mapList = new ListView(new ListX(new Vector.<GameMap>()));
         this._mapDataGroup = new DataGroup(this,null,null,new Sprite());
         this._mapDataGroup.setRendererFactory(this._mapRendererFactory);
         this._mapDataGroup.setDataProvider(this._mapList);
         this._mapDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._mapDataGroup.setLayoutAlgorithm(_loc2_);
         addChild(this._mapDataGroup);
         super.createChildren();
      }
      
      public function setItemSet(param1:ItemSet) : void
      {
         var _loc2_:Vector.<GameMap> = null;
         var _loc3_:uint = 0;
         var _loc4_:GameMap = null;
         if(this._itemSet != param1)
         {
            this._itemSet = param1;
            if(this._itemSet)
            {
               _loc2_ = new Vector.<GameMap>();
               for each(_loc3_ in this._itemSet.getAssignedMaps())
               {
                  _loc4_ = this.findMapByMapID(_loc3_);
                  if(_loc4_)
                  {
                     _loc2_.push(_loc4_);
                  }
               }
               this._mapList.setSource(_loc2_);
               this.updateDescription();
            }
         }
         else
         {
            this._mapList.setSource(null);
         }
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         this._model = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._textField.setExplicitSize(param1,param2);
         var _loc4_:Point = this._mapDataGroup.setExplicitSize(this._background.getWidth(),NaN);
         this._mapDataGroup.setExplicitPosition(0,_loc3_.y + 5);
         var _loc5_:Point = this._background.setExplicitSize(NaN,_loc3_.y + _loc4_.y + 5);
         this._bottomDivider.setExplicitPosition(NaN,_loc5_.y);
         return this._background.getScaledBounds();
      }
      
      private function updateDescription() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this._itemSet)
         {
            if(this._itemSet.getIsGlobalForMaps())
            {
               _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_global");
            }
            else
            {
               _loc2_ = int(this._itemSet.getAssignedMaps().length);
               switch(_loc2_)
               {
                  case 0:
                     _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_none");
                     break;
                  case 1:
                     _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_one");
                     break;
                  default:
                     _loc1_ += ResourceManager.getInstance().getString("itemBrowser","itemSets_mapAssociation_many",[_loc2_]);
               }
            }
         }
         this._textField.setText(_loc1_);
      }
      
      private function findMapByMapID(param1:uint) : GameMap
      {
         var _loc3_:GameMap = null;
         if(!this._model)
         {
            return null;
         }
         var _loc2_:Vector.<GameMap> = this._model.getAvailableMaps();
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.mapId == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

