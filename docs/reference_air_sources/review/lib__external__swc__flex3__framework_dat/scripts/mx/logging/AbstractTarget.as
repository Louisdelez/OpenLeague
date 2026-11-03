package mx.logging
{
   import mx.core.IMXMLObject;
   import mx.core.mx_internal;
   import mx.logging.errors.InvalidFilterError;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.utils.UIDUtil;
   
   use namespace mx_internal;
   
   [ResourceBundle("logging")]
   public class AbstractTarget implements ILoggingTarget, IMXMLObject
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _level:int = 0;
      
      private var _loggerCount:uint = 0;
      
      private var _id:String;
      
      private var _filters:Array = ["*"];
      
      private var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      public function AbstractTarget()
      {
         super();
         _id = UIDUtil.createUID();
      }
      
      public function get level() : int
      {
         return _level;
      }
      
      public function set level(value:int) : void
      {
         Log.removeTarget(this);
         _level = value;
         Log.addTarget(this);
      }
      
      public function logEvent(event:LogEvent) : void
      {
      }
      
      public function addLogger(logger:ILogger) : void
      {
         if(Boolean(logger))
         {
            ++_loggerCount;
            logger.addEventListener(LogEvent.LOG,logHandler);
         }
      }
      
      public function initialized(document:Object, id:String) : void
      {
         _id = id;
         Log.addTarget(this);
      }
      
      [Inspectable(category="General")]
      public function get id() : String
      {
         return _id;
      }
      
      private function logHandler(event:LogEvent) : void
      {
         if(event.level >= level)
         {
            logEvent(event);
         }
      }
      
      public function removeLogger(logger:ILogger) : void
      {
         if(Boolean(logger))
         {
            --_loggerCount;
            logger.removeEventListener(LogEvent.LOG,logHandler);
         }
      }
      
      public function set filters(value:Array) : void
      {
         var filter:String = null;
         var index:int = 0;
         var message:String = null;
         var i:uint = 0;
         if(Boolean(value) && value.length > 0)
         {
            for(i = 0; i < value.length; i++)
            {
               filter = value[i];
               if(Log.hasIllegalCharacters(filter))
               {
                  message = resourceManager.getString("logging","charsInvalid",[filter]);
                  throw new InvalidFilterError(message);
               }
               index = filter.indexOf("*");
               if(index >= 0 && index != filter.length - 1)
               {
                  message = resourceManager.getString("logging","charPlacement",[filter]);
                  throw new InvalidFilterError(message);
               }
            }
         }
         else
         {
            value = ["*"];
         }
         if(_loggerCount > 0)
         {
            Log.removeTarget(this);
            _filters = value;
            Log.addTarget(this);
         }
         else
         {
            _filters = value;
         }
      }
      
      [Inspectable(category="General",arrayType="String")]
      public function get filters() : Array
      {
         return _filters;
      }
   }
}

