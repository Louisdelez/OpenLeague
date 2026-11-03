package flash.display
{
   [API("661")]
   [native(cls="WindowInitOptionsClass",instance="WindowInitOptionsObject",methods="auto")]
   public class NativeWindowInitOptions
   {
      
      public function NativeWindowInitOptions()
      {
         super();
         this.systemChrome = NativeWindowSystemChrome.STANDARD;
         this.transparent = false;
         this.resizable = true;
         this.maximizable = true;
         this.minimizable = true;
      }
      
      public native function get systemChrome() : String;
      
      public native function set systemChrome(param1:String) : void;
      
      public native function get transparent() : Boolean;
      
      public native function set transparent(param1:Boolean) : void;
      
      public native function get type() : String;
      
      public native function set type(param1:String) : void;
      
      public native function get minimizable() : Boolean;
      
      public native function set minimizable(param1:Boolean) : void;
      
      public native function get maximizable() : Boolean;
      
      public native function set maximizable(param1:Boolean) : void;
      
      public native function get resizable() : Boolean;
      
      public native function set resizable(param1:Boolean) : void;
      
      [API("671")]
      public native function get owner() : NativeWindow;
      
      [API("671")]
      public native function set owner(param1:NativeWindow) : void;
      
      [API("675")]
      public native function get renderMode() : String;
      
      [API("675")]
      public native function set renderMode(param1:String) : void;
   }
}

