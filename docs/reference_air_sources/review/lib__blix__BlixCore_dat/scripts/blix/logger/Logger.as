package blix.logger
{
   import blix.context.IContext;
   
   public class Logger
   {
      
      private var _loggingManager:ILoggingManager;
      
      private var _className:String;
      
      public function Logger(param1:IContext)
      {
         super();
         this._className = param1.getClassName();
         this._loggingManager = param1.getDependency(ILoggingManager);
      }
      
      public function logDebug(param1:String) : void
      {
         if(this._loggingManager != null)
         {
            this._loggingManager.log(param1,this._className,LogLevelsEnum.DEBUG);
         }
      }
      
      public function logInfo(param1:String) : void
      {
         if(this._loggingManager != null)
         {
            this._loggingManager.log(param1,this._className,LogLevelsEnum.INFO);
         }
      }
      
      public function logWarn(param1:String) : void
      {
         if(this._loggingManager != null)
         {
            this._loggingManager.log(param1,this._className,LogLevelsEnum.WARN);
         }
      }
      
      public function logError(param1:String) : void
      {
         if(this._loggingManager != null)
         {
            this._loggingManager.log(param1,this._className,LogLevelsEnum.ERROR);
         }
      }
      
      public function logFatal(param1:String) : void
      {
         if(this._loggingManager != null)
         {
            this._loggingManager.log(param1,this._className,LogLevelsEnum.FATAL);
         }
      }
   }
}

