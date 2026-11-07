package spark.components.mediaClasses
{
   [DefaultProperty("streamItems")]
   public class DynamicStreamingVideoSource
   {
      
      private var _host:Object;
      
      private var _initialIndex:int;
      
      private var _streamItems:Vector.<DynamicStreamingVideoItem>;
      
      private var _streamType:String = "any";
      
      public function DynamicStreamingVideoSource()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get host() : Object
      {
         return this._host;
      }
      
      public function set host(value:Object) : void
      {
         this._host = value;
      }
      
      [Inspectable(category="General")]
      public function get initialIndex() : int
      {
         return this._initialIndex;
      }
      
      public function set initialIndex(value:int) : void
      {
         this._initialIndex = value;
      }
      
      [Inspectable(category="General")]
      public function get streamItems() : Vector.<DynamicStreamingVideoItem>
      {
         return this._streamItems;
      }
      
      public function set streamItems(value:Vector.<DynamicStreamingVideoItem>) : void
      {
         this._streamItems = value;
      }
      
      [Inspectable(category="General",enumeration="any,live,recorded",defaultValue="any")]
      public function get streamType() : String
      {
         return this._streamType;
      }
      
      public function set streamType(value:String) : void
      {
         this._streamType = value;
      }
   }
}

