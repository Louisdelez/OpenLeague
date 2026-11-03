package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers.components
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class ListItemAvatar extends SpriteProxy
   {
      
      private static const AVATAR_SIZE:Number = 24;
      
      private var _avatar:BitmapProxy;
      
      private var _data:ListItemObjectModel = new ListItemObjectModel();
      
      public function ListItemAvatar(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._avatar = new BitmapProxy(this);
         this._avatar.getLayoutInvalidated().add(invalidateLayout);
         this._avatar.setTransformBehavior(new ScalingTransformBehavior());
         this.addChild(this._avatar);
         this.setButtonMode(true);
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._avatar.setExplicitSize(AVATAR_SIZE,AVATAR_SIZE);
         return super.updateLayout(param1,param2);
      }
      
      override public function destroy() : void
      {
         this._avatar.destroy();
         this._data.iconChanged.remove(this.setSummonerIcon);
         this._data = null;
         super.destroy();
      }
      
      public function setAvatar(param1:ListItemObjectModel) : void
      {
         setVisible(false);
         if(!param1.isTeam)
         {
            this._data.iconChanged.remove(this.setSummonerIcon);
            this._data = param1;
            if(this._data.iconId >= 0)
            {
               this.setSummonerIcon(this._data.iconId);
            }
            else
            {
               this._data.iconChanged.add(this.setSummonerIcon);
            }
         }
      }
      
      private function setSummonerIcon(param1:uint) : void
      {
         setVisible(true);
         this._data.iconChanged.remove(this.setSummonerIcon);
         this._avatar.setBitmapData(BuddyImages.getSummonerIconSafely(param1));
         this._avatar.setSmoothing(true);
      }
   }
}

