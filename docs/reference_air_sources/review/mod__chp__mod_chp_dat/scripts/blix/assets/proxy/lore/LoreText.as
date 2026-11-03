package blix.assets.proxy.lore
{
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.common.Empty;
   import blix.assets.proxy.common.HitArea;
   import blix.assets.proxy.common.scrollBar.ScrollBarAsset;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class LoreText extends InstanceMapping
   {
      
      public var textMask:HitArea;
      
      public var scrollBar:ScrollBarAsset;
      
      public var contentPosition:Empty;
      
      public var quoteText:TextFieldMapping;
      
      public var quoteAuthorText:TextFieldMapping;
      
      public var contentText:TextFieldMapping;
      
      public var parchment:Parchment;
      
      public function LoreText(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.textMask = new HitArea("textMask",this);
         this.scrollBar = new ScrollBarAsset("scrollBar",this);
         this.contentPosition = new Empty("contentPosition",this);
         this.quoteText = new TextFieldMapping("quoteText",this);
         this.quoteAuthorText = new TextFieldMapping("quoteAuthorText",this);
         this.contentText = new TextFieldMapping("contentText",this);
         this.parchment = new Parchment("parchment",this);
      }
      
      public function create(param1:DisplayObjectContainerProxy) : SpriteProxy
      {
         var _loc2_:String = getName();
         var _loc3_:SpriteProxy = new SpriteProxy(param1);
         param1.setTimelineChildByName(_loc2_,_loc3_);
         return _loc3_;
      }
   }
}

