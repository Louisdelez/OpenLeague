package com.riotgames.platform.gameclient.components.containers
{
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   
   public class LazyViewstack extends Canvas
   {
      
      private var _content:UIComponent;
      
      public function LazyViewstack()
      {
         super();
      }
      
      public function get content() : UIComponent
      {
         return this._content;
      }
      
      public function set content(param1:UIComponent) : void
      {
         if(param1 != this._content)
         {
            if(Boolean(this._content))
            {
               this._content.visible = false;
               if(contains(this._content))
               {
                  removeChild(this._content);
               }
            }
            this._content = param1;
            if(Boolean(this._content))
            {
               addChild(this._content);
               this._content.visible = true;
            }
         }
      }
   }
}

