package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class BrowserChangeEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const APPLICATION_URL_CHANGE:String = "applicationURLChange";
      
      public static const BROWSER_URL_CHANGE:String = "browserURLChange";
      
      public static const URL_CHANGE:String = "urlChange";
      
      public var lastURL:String;
      
      public var url:String;
      
      public function BrowserChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, url:String = null, lastURL:String = null)
      {
         super(type,bubbles,cancelable);
         this.url = url;
         this.lastURL = lastURL;
      }
      
      override public function clone() : Event
      {
         return new BrowserChangeEvent(type,bubbles,cancelable,this.url,this.lastURL);
      }
   }
}

