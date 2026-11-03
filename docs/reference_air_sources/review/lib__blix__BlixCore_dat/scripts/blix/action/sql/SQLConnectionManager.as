package blix.action.sql
{
   import flash.data.SQLConnection;
   import flash.utils.Dictionary;
   
   public class SQLConnectionManager
   {
      
      private static var sqlConnections:Dictionary = new Dictionary();
      
      public function SQLConnectionManager()
      {
         super();
      }
      
      public static function getConnection(param1:SQLConnectionHelper) : SQLConnection
      {
         if(param1 in sqlConnections)
         {
            return sqlConnections[param1];
         }
         var _loc2_:SQLConnection = new SQLConnection();
         sqlConnections[param1] = _loc2_;
         return _loc2_;
      }
      
      public static function openConnection(param1:SQLConnection) : void
      {
      }
   }
}

