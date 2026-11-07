package mx.controls.videoClasses
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [ResourceBundle("controls")]
   public class VideoError extends Error
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const BASE_ERROR_CODE:uint = 1000;
      
      public static const NO_CONNECTION:uint = 1000;
      
      public static const NO_CUE_POINT_MATCH:uint = 1001;
      
      public static const ILLEGAL_CUE_POINT:uint = 1002;
      
      public static const INVALID_SEEK:uint = 1003;
      
      public static const INVALID_CONTENT_PATH:uint = 1004;
      
      public static const INVALID_XML:uint = 1005;
      
      public static const NO_BITRATE_MATCH:uint = 1006;
      
      public static const DELETE_DEFAULT_PLAYER:uint = 1007;
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _code:uint;
      
      public function VideoError(errCode:uint, msg:String = null)
      {
         super();
         this._code = errCode;
         var errorMessages:Array = this.resourceManager.getStringArray("controls","errorMessages");
         message = "" + errCode + ": " + errorMessages[errCode - BASE_ERROR_CODE] + (msg == null ? "" : ": " + msg);
      }
      
      public function get code() : uint
      {
         return this._code;
      }
   }
}

