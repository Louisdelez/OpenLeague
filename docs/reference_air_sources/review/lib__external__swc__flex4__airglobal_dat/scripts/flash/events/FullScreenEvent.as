package flash.events
{
   public class FullScreenEvent extends ActivityEvent
   {
      
      public static const FULL_SCREEN:String = "fullScreen";
      
      private var m_fullScreen:Boolean;
      
      public function FullScreenEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, fullScreen:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.m_fullScreen = fullScreen;
      }
      
      override public function clone() : Event
      {
         return new FullScreenEvent(type,bubbles,cancelable,this.fullScreen);
      }
      
      override public function toString() : String
      {
         return formatToString("FullScreenEvent","type","bubbles","cancelable","eventPhase","fullScreen");
      }
      
      public function get fullScreen() : Boolean
      {
         return this.m_fullScreen;
      }
   }
}

