package flash.media
{
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   
   [API("669")]
   [native(cls="StageWebViewClass",instance="StageWebViewObject",methods="auto")]
   [Event(name="focusOut",type="flash.events.FocusEvent")]
   [Event(name="focusIn",type="flash.events.FocusEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   [Event(name="locationChanging",type="flash.events.LocationChangeEvent")]
   [Event(name="locationChange",type="flash.events.LocationChangeEvent")]
   public final class StageWebView extends EventDispatcher
   {
      
      public function StageWebView()
      {
         super();
         this.init();
      }
      
      public static native function get isSupported() : Boolean;
      
      private native function init() : void;
      
      public native function loadURL(param1:String) : void;
      
      public native function loadString(param1:String, param2:String = "text/html") : void;
      
      public native function stop() : void;
      
      public native function reload() : void;
      
      public native function get isHistoryBackEnabled() : Boolean;
      
      public native function historyBack() : void;
      
      public native function get isHistoryForwardEnabled() : Boolean;
      
      public native function historyForward() : void;
      
      public native function get location() : String;
      
      public native function get title() : String;
      
      public native function get viewPort() : Rectangle;
      
      public native function set viewPort(param1:Rectangle) : void;
      
      public native function get stage() : Stage;
      
      public native function set stage(param1:Stage) : void;
      
      public native function dispose() : void;
      
      public native function assignFocus(param1:String = "none") : void;
      
      [API("671")]
      public native function drawViewPortToBitmapData(param1:BitmapData) : void;
   }
}

