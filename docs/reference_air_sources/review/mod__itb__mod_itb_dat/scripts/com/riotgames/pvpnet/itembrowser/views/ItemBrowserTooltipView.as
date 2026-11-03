package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.text.Text;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetChampion;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import com.riotgames.pvpnet.itembrowser.utils.ItemStyles;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import mx.resources.ResourceManager;
   
   public class ItemBrowserTooltipView extends GameItemRenderer
   {
      
      private var _itemSetsModel:ItemSetsModel;
      
      private var _descriptionText:Text;
      
      private var _background:SpriteProxy;
      
      public function ItemBrowserTooltipView(param1:IContext, param2:Sprite = null)
      {
         super(param1,"ItemTooltip");
         toolTipEnabled = false;
         setMouseEnabled(false);
         setMouseChildren(false);
         this._itemSetsModel = getDependency(ItemSetsModel);
      }
      
      override public function setModel(param1:GameItem) : void
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:GameMap = null;
         super.setModel(param1);
         if(!_model)
         {
            return;
         }
         var _loc2_:String = this.getRestrictionTextTag();
         var _loc3_:String = "<" + _loc2_ + ">";
         var _loc4_:Boolean = false;
         if(_model.requiredChampion != "")
         {
            _loc5_ = RiotResourceLoader.getChampionResourceString("name",_model.requiredChampion,"**" + _model.requiredChampion);
            _loc3_ += ResourceManager.getInstance().getString("itemBrowser","item_restriction_champion",[_loc5_]);
            _loc4_ = true;
         }
         if(_model.restrictedMapIDs.length > 0)
         {
            if(_loc4_)
            {
               if(_model.restrictedMapIDs.length > 0)
               {
                  _loc3_ += "\n\n";
               }
            }
            _loc4_ = true;
            _loc3_ += ResourceManager.getInstance().getString("itemBrowser","item_restriction_maps");
            for each(_loc6_ in _model.restrictedMapIDs)
            {
               for each(_loc7_ in this._itemSetsModel.getAvailableMaps())
               {
                  if(_loc6_ == _loc7_.mapId)
                  {
                     _loc3_ += "\n" + RiotResourceLoader.getMapResourceString("displayname",_loc6_,"**MapName");
                     break;
                  }
               }
            }
         }
         _loc3_ += "</" + _loc2_ + ">";
         if(!_loc4_)
         {
            this._descriptionText.setHtmlText("<font face=\'ApplicationFont2\'>" + _model.description + "</font>");
         }
         else
         {
            this._descriptionText.setHtmlText("<font face=\'ApplicationFont2\'>" + _model.description + "\n\n" + _loc3_ + "</font>");
         }
      }
      
      override public function setData(param1:*) : void
      {
         this.setModel(param1 as GameItem);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         super.updateLayout(param1,param2);
         this._background.setExplicitSize(param1,75 + this._descriptionText.getHeight());
         return new Rectangle(0,0,this._background.getWidth(),this._background.getHeight());
      }
      
      private function getRestrictionTextTag() : String
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc1_:ItemSet = this._itemSetsModel.getActiveItemSet();
         if(!_loc1_)
         {
            return "notRestricted";
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         if(!_loc1_.getIsGlobalForMaps())
         {
            _loc7_ = 0;
            for each(_loc8_ in _model.restrictedMapIDs)
            {
               if(_loc1_.getAssignedMaps().indexOf(_loc8_) != -1)
               {
                  _loc3_ = true;
                  _loc7_++;
               }
            }
            _loc9_ = int(_loc1_.getAssignedMaps().length);
            if(_loc9_ > 0 && _loc9_ == _loc7_)
            {
               _loc2_ = true;
            }
         }
         else
         {
            _loc3_ = _model.restrictedMapIDs.length > 0;
         }
         var _loc6_:ItemSetChampion = _model.requiredChampion ? this._itemSetsModel.skinNameToChampionDictionary[_model.requiredChampion] : null;
         if(!_loc1_.getIsGlobalForChampions())
         {
            if(_loc6_)
            {
               if(_loc1_.getAssignedChampions().indexOf(_loc6_.getChampionID()) == -1)
               {
                  _loc4_ = true;
               }
               else if(_loc1_.getAssignedChampions().length > 1)
               {
                  _loc5_ = true;
               }
            }
         }
         else if(_loc6_)
         {
            _loc5_ = true;
         }
         if(_loc2_ || _loc4_)
         {
            return "restricted";
         }
         if(_loc3_ || _loc5_)
         {
            return "possiblyRestricted";
         }
         return "notRestricted";
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._background = new SpriteProxy(this);
         var _loc1_:ScalingTransformBehavior = new ScalingTransformBehavior();
         this._background.setTransformBehavior(_loc1_);
         setTimelineChildByName("background",this._background);
         this._descriptionText = new Text(this);
         setTimelineChildByName("description",this._descriptionText);
         this._descriptionText.setAutoSize(TextFieldAutoSize.LEFT);
         this._descriptionText.getLayoutInvalidated().add(invalidateLayout);
         this._descriptionText.setStyleSheet(ItemStyles.getInstance().itemDescriptionStylesheet);
      }
   }
}

