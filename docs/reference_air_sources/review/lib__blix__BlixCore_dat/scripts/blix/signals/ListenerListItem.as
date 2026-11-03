package blix.signals
{
   public final class ListenerListItem
   {
      
      public var previous:ListenerListItem;
      
      public var next:ListenerListItem;
      
      public var func:Function;
      
      public var isOnce:Boolean;
      
      public var forceParams:Boolean;
      
      public function ListenerListItem(param1:Function, param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.func = param1;
         this.isOnce = param2;
         this.forceParams = param3;
      }
   }
}

