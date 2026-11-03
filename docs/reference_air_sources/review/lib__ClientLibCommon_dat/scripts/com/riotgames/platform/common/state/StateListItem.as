package com.riotgames.platform.common.state
{
   import com.riotgames.platform.common.DestructibleListItem;
   
   public final class StateListItem extends DestructibleListItem
   {
      
      public var state:IState;
      
      public function StateListItem(param1:IState)
      {
         super();
         this.state = param1;
      }
      
      override public function destroy() : void
      {
         if(Boolean(this.state))
         {
            this.state.destroy();
         }
      }
   }
}

