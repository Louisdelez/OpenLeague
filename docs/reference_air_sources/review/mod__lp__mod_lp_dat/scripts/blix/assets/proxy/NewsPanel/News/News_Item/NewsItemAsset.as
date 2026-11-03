package blix.assets.proxy.NewsPanel.News.News_Item
{
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.MovieClipProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   import blix.context.Context;
   
   public class NewsItemAsset extends InstanceMapping
   {
      
      public static const LINKAGE:String = "assets.NewsItemAsset";
      
      public var hitAreaAsset:HitAreaAsset;
      
      public var imageSizer:HitAreaAsset;
      
      public var imageHolder:empty;
      
      public var titleText:TextFieldMapping;
      
      public var contentText:TextFieldMapping;
      
      public function NewsItemAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.hitAreaAsset = new HitAreaAsset("hitAreaAsset",this);
         this.imageSizer = new HitAreaAsset("imageSizer",this);
         this.imageHolder = new empty("imageHolder",this);
         this.titleText = new TextFieldMapping("titleText",this);
         this.contentText = new TextFieldMapping("contentText",this);
      }
      
      public static function create(param1:Context) : MovieClipProxy
      {
         var _loc2_:MovieClipProxy = new MovieClipProxy(param1);
         _loc2_.setLinkage(LINKAGE);
         return _loc2_;
      }
      
      public function clone(param1:Context) : MovieClipProxy
      {
         return NewsItemAsset.create(param1);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : MovieClipProxy
      {
         var _loc2_:String = getName();
         var _loc3_:MovieClipProxy = new MovieClipProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

