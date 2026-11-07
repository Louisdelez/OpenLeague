package com.riotgames.rust.components.sidemenu
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import flash.display.Sprite;
   
   public class SidebarMenu extends SpriteProxy
   {
      
      private const MENU_BAR_INSTANCE:String = "sidebarContainer";
      
      private const SCREEN_ANCHOR_INSTANCE:String = "viewAnchor";
      
      private var _sideBar:VerticalMenuBar;
      
      private var _screenContainer:MenuScreenContainer;
      
      public function SidebarMenu(param1:IContext)
      {
         super(param1,new Sprite());
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._sideBar = new VerticalMenuBar(this);
         this._screenContainer = new MenuScreenContainer(this);
         setTimelineChildByName(this.MENU_BAR_INSTANCE,this._sideBar);
         setTimelineChildByName(this.SCREEN_ANCHOR_INSTANCE,this._screenContainer);
         this._sideBar.getMenuItemSelected().add(this.onMenuItemSelected);
      }
      
      private function onMenuItemSelected(param1:SideBarMenuItem) : void
      {
         this._screenContainer.loadView(param1);
      }
      
      public function addCategory(param1:String) : int
      {
         return this._sideBar.addCategory(param1);
      }
      
      public function addItemToCategory(param1:int, param2:String, param3:String, param4:Function, param5:Array) : void
      {
         this._sideBar.addItemToCategory(param1,param2,param3,param4,param5);
      }
      
      public function getItemSelected() : ISignal
      {
         return this._sideBar.getMenuItemSelected();
      }
      
      public function setGapBetweenCategory(param1:Number) : void
      {
         this._sideBar.setGapBetweenCategory(param1);
      }
      
      public function setGapBetweenHeaderAndItem(param1:Number) : void
      {
         this._sideBar.setGapBetweenHeaderAndItem(param1);
      }
      
      public function setGapBetweenItem(param1:Number) : void
      {
         this._sideBar.setGapBetweenItem(param1);
      }
      
      public function selectMenuItemByPath(param1:String) : void
      {
         this._sideBar.selectMenuItemByPath(param1);
      }
   }
}

