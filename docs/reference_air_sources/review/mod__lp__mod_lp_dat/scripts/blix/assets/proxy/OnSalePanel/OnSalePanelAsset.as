package blix.assets.proxy.OnSalePanel
{
   import blix.assets.proxy.Common.BuyButtonAsset;
   import blix.assets.proxy.Common.HitAreaAsset;
   import blix.assets.proxy.Common.InfoButtonAsset;
   import blix.assets.proxy.Common.empty;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.mappings.InstanceMapping;
   import blix.assets.proxy.mappings.TextFieldMapping;
   
   public class OnSalePanelAsset extends InstanceMapping
   {
      
      public var salePercent:TextFieldMapping;
      
      public var sunburst:saleSplash;
      
      public var panelTitleTextFieldAsset:TextFieldMapping;
      
      public var buttonsPosition:empty;
      
      public var costsPosition:empty;
      
      public var infoButtonAsset:InfoButtonAsset;
      
      public var buyButtonAsset:BuyButtonAsset;
      
      public var titleAsset:TextFieldMapping;
      
      public var subTitleAsset:TextFieldMapping;
      
      public var ipCostIconAsset:ipCostIcon;
      
      public var rpCostIconAsset:rpCostIcon;
      
      public var rpCostAsset:TextFieldMapping;
      
      public var ipCostAsset:TextFieldMapping;
      
      public var loaderContainerAsset:empty;
      
      public var imageSizer:HitAreaAsset;
      
      public function OnSalePanelAsset(param1:String = null, param2:InstanceMapping = null)
      {
         super(param1,param2);
         this.salePercent = new TextFieldMapping("salePercent",this);
         this.sunburst = new saleSplash("sunburst",this);
         this.panelTitleTextFieldAsset = new TextFieldMapping("panelTitleTextFieldAsset",this);
         this.buttonsPosition = new empty("buttonsPosition",this);
         this.costsPosition = new empty("costsPosition",this);
         this.infoButtonAsset = new InfoButtonAsset("infoButtonAsset",this);
         this.buyButtonAsset = new BuyButtonAsset("buyButtonAsset",this);
         this.titleAsset = new TextFieldMapping("titleAsset",this);
         this.subTitleAsset = new TextFieldMapping("subTitleAsset",this);
         this.ipCostIconAsset = new ipCostIcon("ipCostIconAsset",this);
         this.rpCostIconAsset = new rpCostIcon("rpCostIconAsset",this);
         this.rpCostAsset = new TextFieldMapping("rpCostAsset",this);
         this.ipCostAsset = new TextFieldMapping("ipCostAsset",this);
         this.loaderContainerAsset = new empty("loaderContainerAsset",this);
         this.imageSizer = new HitAreaAsset("imageSizer",this);
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

