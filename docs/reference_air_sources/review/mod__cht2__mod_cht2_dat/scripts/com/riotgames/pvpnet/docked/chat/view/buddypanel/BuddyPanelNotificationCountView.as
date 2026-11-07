package com.riotgames.pvpnet.docked.chat.view.buddypanel
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.display.MovieClip;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class BuddyPanelNotificationCountView extends StatefulView
   {
      
      private var _background:SpriteProxy;
      
      private var _text:TextFieldProxy;
      
      public function BuddyPanelNotificationCountView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      override protected function createChildren() : void
      {
         this._background = new SpriteProxy(this);
         this._background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this._background);
         this._text = new TextFieldProxy(this);
         setTimelineChildByName("notificationsCountText",this._text);
         this._text.setAutoSize(TextFieldAutoSize.CENTER);
         this._text.getLayoutInvalidated().add(invalidateLayout);
         super.createChildren();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this._background.setExplicitSize(this._text.getTextWidth() + 12,NaN);
         this._background.setExplicitPosition(Math.round(this._text.getX() + this._text.getWidth() / 2 - this._background.getWidth() / 2),NaN);
         return super.updateLayout(param1,param2);
      }
      
      public function setNotificationCount(param1:uint) : void
      {
         this._text.setText(String(param1));
         if(param1 > 0)
         {
            setCurrentState("notifications");
         }
         else
         {
            setCurrentState("noNotifications");
         }
      }
      
      public function setText(param1:String) : void
      {
         this._text.setText(param1);
      }
   }
}

