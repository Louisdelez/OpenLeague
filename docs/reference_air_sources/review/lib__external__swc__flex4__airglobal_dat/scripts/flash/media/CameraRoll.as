package flash.media
{
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   
   [API("668")]
   [native(cls="CameraRollClass",instance="CameraRollObject",methods="auto")]
   [Event(name="cancel",type="flash.events.Event")]
   [Event(name="select",type="flash.events.MediaEvent")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="complete",type="flash.events.Event")]
   public class CameraRoll extends EventDispatcher
   {
      
      public function CameraRoll()
      {
         super();
      }
      
      public static native function get supportsAddBitmapData() : Boolean;
      
      [API("669")]
      public static native function get supportsBrowseForImage() : Boolean;
      
      public native function addBitmapData(param1:BitmapData) : void;
      
      [API("669")]
      public native function browseForImage(param1:CameraRollBrowseOptions = null) : void;
   }
}

