package flash.media
{
   import flash.events.*;
   import flash.utils.*;
   
   [API("669")]
   [native(cls="CameraUIClass",instance="CameraUIObject",methods="auto")]
   [Event(name="complete",type="flash.events.MediaEvent")]
   [Event(name="cancel",type="flash.events.Event")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   public class CameraUI extends EventDispatcher
   {
      
      private static const kFeatureNotAvailableError:uint = 2014;
      
      private var errorTimer:Timer = new Timer(20,1);
      
      public function CameraUI()
      {
         super();
         this.errorTimer.addEventListener(TimerEvent.TIMER,this.fireUnavailableError);
      }
      
      public static function get isSupported() : Boolean
      {
         return false;
      }
      
      public function launch(requestedMediaType:String) : void
      {
         this.errorTimer.start();
      }
      
      private function fireUnavailableError(e:TimerEvent) : void
      {
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"unavailable",kFeatureNotAvailableError));
      }
   }
}

