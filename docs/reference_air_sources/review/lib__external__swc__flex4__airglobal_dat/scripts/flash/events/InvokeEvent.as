package flash.events
{
   import flash.filesystem.File;
   
   [API("661")]
   public class InvokeEvent extends Event
   {
      
      public static const INVOKE:String = "invoke";
      
      private var m_dir:File;
      
      private var m_argv:Array;
      
      private var m_reason:String;
      
      public function InvokeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, dir:File = null, argv:Array = null, reason:String = "standard")
      {
         super(type,bubbles,cancelable);
         this.m_dir = dir;
         this.m_argv = argv;
         this.m_reason = reason;
      }
      
      override public function clone() : Event
      {
         return new InvokeEvent(type,bubbles,cancelable,this.m_dir,this.m_argv,this.m_reason);
      }
      
      public function get currentDirectory() : File
      {
         return this.m_dir;
      }
      
      public function get arguments() : Array
      {
         return this.m_argv;
      }
      
      [API("664")]
      public function get reason() : String
      {
         return this.m_reason;
      }
   }
}

