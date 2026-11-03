package com.riotgames.pvpnet.cap.views.components
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import flash.display.Sprite;
   
   public class CapHeader extends SpriteProxy
   {
      
      private var titleText:TextFieldProxy;
      
      private var _title:String;
      
      public function CapHeader(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
         this._title = "HELLO WORLD!";
      }
      
      public function set title(param1:String) : void
      {
         this._title = param1;
         this.updateTitleText(this.titleText);
      }
      
      public function get title() : String
      {
         return this._title;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.titleText = new TextFieldProxy(this);
         setTimelineChildByName("headerText",this.titleText);
         this.updateTitleText(this.titleText);
      }
      
      protected function updateTitleText(param1:TextFieldProxy) : void
      {
         if(param1)
         {
            param1.setText(this.title);
         }
      }
   }
}

