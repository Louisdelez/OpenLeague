package flash.events
{
   import flash.media.MediaPromise;
   
   [API("669")]
   public class MediaEvent extends Event
   {
      
      public static const COMPLETE:String = "complete";
      
      public static const SELECT:String = "select";
      
      private var m_data:MediaPromise;
      
      public function MediaEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, data:MediaPromise = null)
      {
         super(type,bubbles,cancelable);
         this.m_data = data;
      }
      
      public function get data() : MediaPromise
      {
         return this.m_data;
      }
      
      override public function clone() : Event
      {
         return new MediaEvent(type,bubbles,cancelable,this.m_data);
      }
      
      override public function toString() : String
      {
         return formatToString("MediaEvent","type","bubbles","cancelable","data");
      }
   }
}

