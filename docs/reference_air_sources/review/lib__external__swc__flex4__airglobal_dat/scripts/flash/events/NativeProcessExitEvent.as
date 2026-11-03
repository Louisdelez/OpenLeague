package flash.events
{
   [Version("air2.0")]
   public class NativeProcessExitEvent extends Event
   {
      
      public static const EXIT:String = "exit";
      
      private var _exitCode:Number;
      
      public function NativeProcessExitEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, exitCode:Number = NaN)
      {
         super(type,bubbles,cancelable);
         this.exitCode = exitCode;
      }
      
      override public function clone() : Event
      {
         return new NativeProcessExitEvent(type,bubbles,cancelable,this.exitCode);
      }
      
      override public function toString() : String
      {
         return formatToString("NativeProcessExitEvent","type","bubbles","cancelable","exitCode");
      }
      
      public function get exitCode() : Number
      {
         return this._exitCode;
      }
      
      public function set exitCode(value:Number) : void
      {
         this._exitCode = value;
      }
   }
}

