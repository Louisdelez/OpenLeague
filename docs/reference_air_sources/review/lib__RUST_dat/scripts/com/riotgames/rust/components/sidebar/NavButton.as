package com.riotgames.rust.components.sidebar
{
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import flash.geom.Rectangle;
   
   public class NavButton extends LabelButtonX
   {
      
      private var _navItem:SidebarItem;
      
      public function NavButton(param1:IContext)
      {
         super(param1);
      }
      
      public function setNavItem(param1:SidebarItem) : void
      {
         this._navItem = param1;
      }
      
      public function getNavItem() : SidebarItem
      {
         return this._navItem;
      }
      
      public function get header() : String
      {
         return this._navItem.header;
      }
      
      public function get title() : String
      {
         return this._navItem.name;
      }
      
      public function get path() : String
      {
         return this._navItem.path;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Rectangle = null;
         if(getHitArea() != null)
         {
            getHitArea().validate();
            return getHitArea().getUnscaledBounds();
         }
         return super.updateLayout(param1,param2);
      }
   }
}

