package
{
   import flash.events.Event;
   
   public class TradeSelectEvent extends Event
   {
      
      public static const TRADE_PENDING_EVENT:String = "onTradePendingEvent";
      
      public static const TRADE_DENIED_EVENT:String = "onTradeDeniedEvent";
      
      public static const TRADE_STATE_CHANGED_EVENT:String = "onTradeStateChangedEvent";
      
      public static const TRADE_STATE_CHANGING_EVENT:String = "onTradeStateChangingEvent";
      
      public static const TRADE_OPTION_SELECTED_EVENT:String = "onTradeOptionSelectedEvent";
      
      public static const TRADE_REQUEST_EVENT:String = "onTradeRequestEvent";
      
      public static const TRADE_ACCEPT_EVENT:String = "onTradeAcceptEvent";
      
      public static const TRADE_DECLINE_EVENT:String = "onTradeDeclineEvent";
      
      private var _param:*;
      
      public function TradeSelectEvent(type:String, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         this._param = data;
         super(type,bubbles,cancelable);
      }
      
      public function get param() : *
      {
         return this._param;
      }
   }
}

