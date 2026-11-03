package flash.data
{
   [API("661")]
   public class SQLColumnSchema
   {
      
      private var _name:String;
      
      private var _primaryKey:Boolean;
      
      private var _allowNull:Boolean;
      
      private var _autoInc:Boolean;
      
      private var _dataType:String;
      
      private var _collSeq:String;
      
      public function SQLColumnSchema(name:String, primaryKey:Boolean, allowNull:Boolean, autoIncrement:Boolean, dataType:String, defaultCollationType:String)
      {
         super();
         this._name = name;
         this._primaryKey = primaryKey;
         this._allowNull = allowNull;
         this._autoInc = autoIncrement;
         this._dataType = dataType;
         this._collSeq = defaultCollationType;
      }
      
      public function get allowNull() : Boolean
      {
         return this._allowNull;
      }
      
      public function get autoIncrement() : Boolean
      {
         return this._autoInc;
      }
      
      public function get defaultCollationType() : String
      {
         return this._collSeq;
      }
      
      public function get dataType() : String
      {
         return this._dataType;
      }
      
      public function get name() : String
      {
         return this._name;
      }
      
      public function get primaryKey() : Boolean
      {
         return this._primaryKey;
      }
   }
}

