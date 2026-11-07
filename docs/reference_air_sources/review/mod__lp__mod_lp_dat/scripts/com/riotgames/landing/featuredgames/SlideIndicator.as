package com.riotgames.landing.featuredgames
{
   import blix.components.button.ButtonX;
   import blix.context.IContext;
   import com.greensock.TweenLite;
   import flash.events.MouseEvent;
   
   public class SlideIndicator extends ButtonX
   {
      
      private var _activeState:Boolean = true;
      
      public function SlideIndicator(param1:IContext)
      {
         super(param1);
      }
      
      public function show(param1:Boolean = false) : void
      {
         if(param1)
         {
            setAlpha(1);
            setVisible(true);
         }
         else
         {
            setVisible(true);
            TweenLite.to(assetProxy,0.5,{"alpha":1});
         }
      }
      
      public function hide(param1:Boolean = false) : void
      {
         if(param1)
         {
            setAlpha(0);
            setVisible(false);
         }
         else
         {
            TweenLite.to(assetProxy,0.5,{"autoAlpha":0});
         }
      }
      
      public function activate() : void
      {
         this._activeState = true;
         setCurrentState("up");
      }
      
      public function deactivate() : void
      {
         this._activeState = false;
         setCurrentState("disabled");
      }
      
      override protected function rollOverHandler(param1:MouseEvent) : void
      {
         if(this._activeState)
         {
            super.rollOverHandler(param1);
         }
      }
      
      override protected function rollOutHandler(param1:MouseEvent) : void
      {
         if(this._activeState)
         {
            super.rollOutHandler(param1);
         }
      }
   }
}

