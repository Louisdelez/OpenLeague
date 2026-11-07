package flash.events
{
   [Version("air2.0")]
   public class StageOrientationEvent extends Event
   {
      
      public static const ORIENTATION_CHANGING:String = "orientationChanging";
      
      public static const ORIENTATION_CHANGE:String = "orientationChange";
      
      private var m_beforeOrientation:String;
      
      private var m_afterOrientation:String;
      
      public function StageOrientationEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, beforeOrientation:String = null, afterOrientation:String = null)
      {
         super(type,bubbles,cancelable);
         this.m_beforeOrientation = beforeOrientation;
         this.m_afterOrientation = afterOrientation;
      }
      
      override public function clone() : Event
      {
         return new StageOrientationEvent(type,bubbles,cancelable,this.m_beforeOrientation,this.m_afterOrientation);
      }
      
      public function get beforeOrientation() : String
      {
         return this.m_beforeOrientation;
      }
      
      public function get afterOrientation() : String
      {
         return this.m_afterOrientation;
      }
      
      override public function toString() : String
      {
         return formatToString("StageOrientationEvent","type","bubbles","cancelable","beforeOrientation","afterOrientation");
      }
   }
}

