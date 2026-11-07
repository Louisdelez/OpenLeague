package blix.action.sql
{
   import blix.action.BasicAction;
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import flash.errors.SQLError;
   import flash.net.Responder;
   
   public class SQLStatementAction extends BasicAction
   {
      
      public var unmarshallResultFunction:Function;
      
      public var unmarshalledResult:*;
      
      public var sqlStatement:SQLStatement;
      
      public var result:SQLResult;
      
      public var prefetch:int = -1;
      
      public function SQLStatementAction(param1:SQLStatement, param2:Boolean = false)
      {
         super(param2);
         this.sqlStatement = param1;
      }
      
      override protected function doInvocation() : void
      {
         this.sqlStatement.execute(this.prefetch,new Responder(this.sqlResultHandler,this.failHandler));
      }
      
      private function sqlResultHandler(param1:SQLResult) : void
      {
         var result:SQLResult = param1;
         this.result = result;
         if(this.unmarshallResultFunction != null)
         {
            try
            {
               this.unmarshalledResult = this.unmarshallResultFunction(result);
            }
            catch(error:Error)
            {
               err(error);
               return;
            }
         }
         complete();
      }
      
      protected function failHandler(param1:SQLError) : void
      {
         err(param1);
      }
   }
}

