package blix.action.sql
{
   import blix.action.BasicAction;
   import flash.data.SQLConnection;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.filesystem.File;
   import flash.net.Responder;
   
   public class SQLConnectionAction extends BasicAction
   {
      
      public var sqlConnection:SQLConnection = new SQLConnection();
      
      public var file:File;
      
      public var sqlMode:String;
      
      public function SQLConnectionAction(param1:File = null, param2:Boolean = false, param3:String = null)
      {
         super(param2);
         this.file = param1;
         this.sqlMode = param3;
      }
      
      override protected function doInvocation() : void
      {
         if(this.file == null)
         {
            err(new Error("Database file not set."));
            return;
         }
         if(!this.file.exists)
         {
            err(new Error("Database file does not exist."));
            return;
         }
         this.sqlConnection.openAsync(this.file,this.sqlMode,new Responder(this.openSqlConnectionSuccessHandler,this.errorHandler));
      }
      
      protected function openSqlConnectionSuccessHandler(param1:Event) : void
      {
         complete();
      }
      
      protected function errorHandler(param1:ErrorEvent) : void
      {
         err(new Error(param1.text));
      }
      
      override public function abort() : void
      {
         if(_hasBeenInvoked)
         {
            this.sqlConnection.close();
         }
         super.abort();
      }
      
      public function close() : void
      {
         this.reset();
      }
      
      override public function reset() : void
      {
         if(_hasBeenInvoked)
         {
            this.sqlConnection.close();
         }
         super.reset();
      }
   }
}

