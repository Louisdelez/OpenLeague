package com.riotgames.rust.components.sidemenu
{
   import blix.assets.proxy.SpriteProxy;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import flash.display.Sprite;
   
   public class MenuScreenContainer extends SpriteProxy
   {
      
      private const FADE_TIME:Number = 0.5;
      
      private var _pendingPath:String;
      
      private var _currentPath:String;
      
      private var _pendingScreen:INestedScreen;
      
      private var _currentScreen:INestedScreen;
      
      private var _tweenedScreen:SpriteProxy;
      
      public function MenuScreenContainer(param1:IContext, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override public function destroy() : void
      {
         TweenLite.killTweensOf(this._tweenedScreen);
         super.destroy();
      }
      
      public function loadView(param1:SideBarMenuItem) : void
      {
         var _loc2_:INestedScreen = null;
         if(Boolean(param1))
         {
            this._pendingPath = param1.path;
            if(param1.functionParam.length > 0)
            {
               _loc2_ = param1.viewGetterFunction.apply(null,param1.functionParam);
            }
            else
            {
               _loc2_ = param1.viewGetterFunction();
            }
            if(_loc2_ != null && this._pendingPath != this._currentPath)
            {
               this.setCurrentScreen(_loc2_);
               this._currentPath = this._pendingPath;
            }
         }
      }
      
      public function setCurrentScreen(param1:INestedScreen) : void
      {
         this._pendingScreen = param1;
         if(this._currentScreen != null)
         {
            this.fadeOutScreen(this._currentScreen);
            this._currentScreen = null;
         }
         else
         {
            this.showPendingScreen();
         }
      }
      
      private function fadeOutScreen(param1:INestedScreen) : void
      {
         param1.getHideCompleted().add(this.screenHideCompletedHandler);
         this._tweenedScreen = param1 as SpriteProxy;
         TweenLite.to(this._tweenedScreen.getSetterProxy(),this.FADE_TIME,{
            "alpha":0,
            "onComplete":param1.hide
         });
      }
      
      private function fadeInScreen(param1:SpriteProxy) : void
      {
         this._tweenedScreen = param1;
         this._tweenedScreen.setAlpha(0);
         TweenLite.to(this._tweenedScreen.getSetterProxy(),this.FADE_TIME,{"alpha":1});
      }
      
      private function showPendingScreen() : void
      {
         if(Boolean(this._pendingScreen))
         {
            this.fadeInScreen(this._pendingScreen as SpriteProxy);
            addChild(this._pendingScreen as SpriteProxy);
            this._pendingScreen.show();
            this._currentScreen = this._pendingScreen;
            this._pendingScreen = null;
         }
      }
      
      private function screenHideCompletedHandler(param1:INestedScreen = null) : void
      {
         if(Boolean(param1))
         {
            removeChild(param1 as SpriteProxy);
         }
         this.showPendingScreen();
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

