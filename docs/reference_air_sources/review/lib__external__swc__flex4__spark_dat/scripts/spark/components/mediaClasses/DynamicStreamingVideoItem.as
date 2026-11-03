package spark.components.mediaClasses
{
   public class DynamicStreamingVideoItem
   {
      
      private var _bitrate:Number = 0;
      
      private var _streamName:String;
      
      public function DynamicStreamingVideoItem()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get bitrate() : Number
      {
         return this._bitrate;
      }
      
      public function set bitrate(value:Number) : void
      {
         this._bitrate = value;
      }
      
      [Inspectable(category="General")]
      public function get streamName() : String
      {
         return this._streamName;
      }
      
      public function set streamName(value:String) : void
      {
         this._streamName = value;
      }
   }
}

