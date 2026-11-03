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
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.itembrowser.controller.ItemBrowserController;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemSetChampionAssociationsPreview extends SpriteProxy
   {
      
      private var _championList:ListView;
      
      private var _championDataGroup:DataGroup;
      
      private var _textField:TextFieldProxy;
      
      private var _itemSet:ItemSet;
      
      private var _itemBrowserController:ItemBrowserController;
      
      private var _index:uint;
      
      private var _background:StatefulView;
      
      private var _championRendererFactory:RendererFactory;
      
      private var _model:ItemSetsModel;
      
      private var _bottomDivider:SpriteProxy;
      
      public function ItemSetChampionAssociationsPreview(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         setLinkage("ItemPageInfoRenderer");
         this._itemBrowserController = getDependency(ItemBrowserController);
      }
      
      public function setItemSet(param1:ItemSet) : void
      {
         var _loc2_:Vector.<ItemSetChampion> = null;
         var _loc3_:uint = 0;
         var _loc4_:Champion = null;
         var _loc5_:ItemSetChampion = null;
         if(this._itemSet != param1)
         {
            this._itemSet = param1;
            if(Boolean(this._itemSet) && Boolean(this._model))
            {
               _loc2_ = new Vector.<ItemSetChampion>();
               for each(_loc3_ in this._itemSet.getAssignedChampions())
               {
                  _loc4_ = ItemSetChampion(this._model.championIdToChampionDictionary[_loc3_]).getChampion();
                  if(_loc4_)
                  {
                     _loc5_ = new ItemSetChampion(_loc4_);
                     _loc2_.push(_loc5_);
                  }
               }
               this._championList.setSource(_loc2_);
               this.updateDescription();
            }
            else
            {
               this._championList.setSource(null);
            }
         }
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
         _loc2_.setHGap(3);
         this._championRendererFactory = new RendererFactory(ItemSetChampionListRendererInactive,[this]);
         this._championList = new ListView(new ListX(new Vector.<ItemSetChampion>()));
         this._championDataGroup = new DataGroup(this,null,null,new Sprite());
         this._championDataGroup.setRendererFactory(this._championRendererFactory);
         this._championDataGroup.setDataProvider(this._championList);
         this._championDataGroup.getLayoutInvalidated().add(invalidateLayout);
         this._championDataGroup.setLayoutAlgorithm(_loc2_);
         addChild(this._championDataGroup);
         super.createChildren();
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         this._model = param1;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this._textField.setExplicitSize(param1,param2);
         var _loc4_:Point = this._championDataGroup.setExplicitSize(this._background.getWidth() - 6,NaN);
         this._championDataGroup.setExplicitPosition(6,_loc3_.y + 5);
         var _loc5_:Point = this._background.setExplicitSize(NaN,_loc3_.y + _loc4_.y + 10);
         this._bottomDivider.setExplicitPosition(NaN,_loc5_.y);
         return this._background.getScaledBounds();
      }
      
      private function updateDescription() : void
      {
         var _loc2_:int = 0;
         var _loc1_:String = "";
         if(this._itemSet)
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

