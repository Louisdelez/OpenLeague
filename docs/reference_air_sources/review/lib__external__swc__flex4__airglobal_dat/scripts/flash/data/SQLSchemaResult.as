package flash.data
{
   [API("661")]
   public class SQLSchemaResult
   {
      
      private var _indices:Array;
      
      private var _tables:Array;
      
      private var _triggers:Array;
      
      private var _views:Array;
      
      public function SQLSchemaResult(tables:Array, views:Array, indices:Array, triggers:Array)
      {
         super();
         this._tables = Boolean(tables) ? tables : [];
         this._views = Boolean(views) ? views : [];
         this._indices = Boolean(indices) ? indices : [];
         this._triggers = Boolean(triggers) ? triggers : [];
      }
      
      public function get indices() : Array
      {
         return this._indices;
      }
      
      public function get tables() : Array
      {
         return this._tables;
      }
      
      public function get triggers() : Array
      {
         return this._triggers;
      }
      
      public function get views() : Array
      {
         return this._views;
      }
   }
}

