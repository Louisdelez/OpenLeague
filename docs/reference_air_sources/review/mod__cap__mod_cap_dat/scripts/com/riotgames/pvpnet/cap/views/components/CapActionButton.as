package com.riotgames.pvpnet.cap.views.components
{
   import blix.components.button.LabelButtonX;
   import blix.components.enum.ButtonStatesEnum;
   import blix.context.IContext;
   
   public class CapActionButton extends LabelButtonX
   {
      
      private static const READY:String = "_ready";
      
      private static const UNREADY:String = "_unready";
      
      public static const NORMAL_STATE:uint = 0;
      
      public static const READY_STATE:uint = 1;
      
      public static const UNREADY_STATE:uint = 2;
      
      public var readyState:uint = 0;
      
      public function CapActionButton(param1:IContext)
      {
         super(param1);
      }
      
      public function setReadyState(param1:uint) : void
      {
         this.readyState = param1;
         this.refreshState();
      }
      
      protected function determineButtonXState() : String
      {
         if(!getEnabled())
         {
            return ButtonStatesEnum.DISABLED;
         }
         if(Boolean(getMouseIsDown()) && (Boolean(getMouseIsOver()) || Boolean(getShowDownStateOutside())))
         {
            return ButtonStatesEnum.DOWN;
         }
         if(getMouseIsOver())
         {
            return ButtonStatesEnum.OVER;
         }
         return ButtonStatesEnum.UP;
      }
      
      override protected function refreshState() : void
      {
         var _loc1_:String = this.determineButtonXState();
         var _loc2_:String = this.determineActionButtonState(_loc1_);
         setCurrentState(_loc2_);
      }
      
      protected function determineActionButtonState(param1:String) : String
      {
         if(this.readyState == NORMAL_STATE || param1 == ButtonStatesEnum.DISABLED)
         {
            return param1;
         }
         if(this.readyState == READY_STATE)
         {
            return param1 + READY;
         }
         if(this.readyState == UNREADY_STATE)
         {
            return param1 + UNREADY;
         }
         return param1;
      }
   }
}

