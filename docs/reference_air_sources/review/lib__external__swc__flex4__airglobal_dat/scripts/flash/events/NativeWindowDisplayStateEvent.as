package flash.events
{
   [API("661")]
   public class NativeWindowDisplayStateEvent extends Event
   {
      
      public static const DISPLAY_STATE_CHANGING:String = "displayStateChanging";
      
      public static const DISPLAY_STATE_CHANGE:String = "displayStateChange";
      
      private var m_beforeDisplayState:String;
      
      private var m_afterDisplayState:String;
      
      public function NativeWindowDisplayStateEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false, beforeDisplayState:String = "", afterDisplayState:String = "")
      {
         super(type,bubbles,cancelable);
         this.m_beforeDisplayState = beforeDisplayState;
         this.m_afterDisplayState = afterDisplayState;
      }
      
      override public function clone() : Event
      {
         return new NativeWindowDisplayStateEvent(type,bubbles,cancelable,this.m_beforeDisplayState,this.m_afterDisplayState);
      }
      
      public function get beforeDisplayState() : String
      {
         return this.m_beforeDisplayState;
      }
      
      public function get afterDisplayState() : String
      {
         return this.m_afterDisplayState;
      }
      
      override public function toString() : String
      {
         return formatToString("NativeWindowDisplayStateEvent","type","bubbles","cancelable","beforeDisplayState","afterDisplayState");
      }
   }
}

