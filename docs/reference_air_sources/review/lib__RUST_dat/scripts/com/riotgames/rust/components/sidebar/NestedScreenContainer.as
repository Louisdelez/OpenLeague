package com.riotgames.rust.components.sidebar
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   
   public class NestedScreenContainer extends SpriteProxy
   {
      
      private var _displayAdapter:DisplayAdapter;
      
      private var _sidebar:Sidebar;
      
      private var _pendingPath:String;
      
      private var _currentPath:String;
      
      private var _params:Array = [];
      
      private var _pendingScreen:INestedScreen;
      
      private var _currentScreen:INestedScreen;
      
      public function NestedScreenContainer(param1:IContext, param2:Sidebar, param3:Sprite = null)
      {
         super(param1,param3);
         this._displayAdapter = new DisplayAdapter(this);
         this._sidebar = param2;
      }
      
      public function setPath(param1:String) : void
      {
         var _loc2_:SidebarItem = null;
         var _loc3_:Function = null;
         var _loc4_:INestedScreen = null;
         this._pendingPath = param1;
         this._sidebar.setPath(this._pendingPath);
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = this._sidebar.lookupByPath(this._pendingPath);
            if(Boolean(_loc2_))
            {
               _loc3_ = _loc2_.closure;
               if(_loc3_.length == 2)
               {
                  _loc4_ = _loc3_.apply(null,[this,this._params]) as INestedScreen;
                  if(_loc4_ != null && this._pendingPath != this._currentPath)
                  {
                     this.setCurrentScreen(_loc4_);
                     this._currentPath = this._pendingPath;
                  }
               }
               else
               {
                  _loc3_();
                  this._currentPath = this._pendingPath;
               }
            }
         }
      }
      
      public function setParameters(param1:Array) : void
      {
         this._params = param1;
      }
      
      public function setCurrentScreen(param1:INestedScreen) : void
      {
         var _loc2_:INestedScreen = null;
         var _loc3_:SpriteProxy = null;
         this._pendingScreen = param1;
         if(this._currentScreen != null)
         {
            _loc2_ = this._currentScreen;
            _loc2_.getHideCompleted().add(this.screenHideCompletedHandler);
            this._currentScreen = null;
            _loc3_ = _loc2_ as SpriteProxy;
            TweenLite.to(_loc3_.getSetterProxy(),0.5,{
               "alpha":0,
               "onComplete":_loc2_.hide
            });
         }
         else
         {
            this.showPendingScreen();
         }
      }
      
      private function showPendingScreen() : void
      {
         var _loc1_:SpriteProxy = null;
         if(Boolean(this._pendingScreen))
         {
            _loc1_ = this._pendingScreen as SpriteProxy;
            _loc1_.setAlpha(0);
            this._displayAdapter.addChild(this._pendingScreen);
            this._pendingScreen.show();
            TweenLite.to(_loc1_.getSetterProxy(),0.5,{"alpha":1});
            this._currentScreen = this._pendingScreen;
            this._pendingScreen = null;
         }
      }
      
      private function screenHideCompletedHandler(param1:INestedScreen = null) : void
      {
         if(Boolean(param1))
         {
            this._displayAdapter.removeChild(param1);
         }
         this.showPendingScreen();
      }
      
      public function get screen() : DisplayAdapter
      {
         return this._displayAdapter;
      }
      
      public function hideScreens() : void
      {
         if(this._currentScreen != null)
         {
            this._currentScreen.hide();
         }
         if(this._pendingScreen != null)
         {
            this._pendingScreen.hide();
         }
      }
   }
}

