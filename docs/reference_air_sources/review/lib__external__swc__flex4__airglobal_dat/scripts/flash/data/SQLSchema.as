package flash.data
{
   [API("661")]
   public class SQLSchema
   {
      
      private var _db:String;
      
      private var _name:String;
      
      private var _sql:String;
      
      public function SQLSchema(database:String, name:String, sql:String)
      {
         super();
         this._sql = sql;
         this._name = name;
         this._db = database;
      }
      
      public function get database() : String
      {
         return this._db;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get sql() : String
      {
         return this._sql;
      }
   }
}

