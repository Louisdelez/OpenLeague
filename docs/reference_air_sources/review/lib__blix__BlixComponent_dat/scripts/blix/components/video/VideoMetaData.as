package blix.components.video
{
   public dynamic class VideoMetaData
   {
      
      public var length:uint;
      
      public var aacaot:uint;
      
      public var audiochannels:uint;
      
      public var audiocodecid:String;
      
      public var audiosamplerate:uint;
      
      public var avclevel:uint;
      
      public var avcprofile:uint;
      
      public var duration:Number;
      
      public var height:Number;
      
      public var moovposition:uint;
      
      public var seekpoints:Array;
      
      public var trackinfo:Array;
      
      public var videocodecid:String;
      
      public var videoframerate:Number;
      
      public var width:Number;
      
      public function VideoMetaData()
      {
         super();
      }
      
      public static function unmarshal(param1:Object) : VideoMetaData
      {
         var _loc3_:String = null;
         var _loc2_:VideoMetaData = new VideoMetaData();
         for(_loc3_ in param1)
         {
            _loc2_[_loc3_] = param1[_loc3_];
         }
         return _loc2_;
      }
   }
}

