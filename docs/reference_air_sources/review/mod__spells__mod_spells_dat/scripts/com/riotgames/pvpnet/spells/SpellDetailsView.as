package com.riotgames.pvpnet.spells
{
   import blix.assets.proxy.BitmapProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.context.IContext;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.game.variants.GameFlowVariant;
   import com.riotgames.pvpnet.game.variants.GameFlowVariantFactory;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.rust.effects.fadeOut;
   import com.riotgames.util.logging.getLogger;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import mx.core.BitmapAsset;
   import mx.logging.ILogger;
   import mx.resources.ResourceManager;
   
   public class SpellDetailsView extends SpriteProxy
   {
      
      private var spellImage:BitmapProxy;
      
      private var nameText:TextFieldProxy;
      
      private var requirements:TextFieldProxy;
      
      private var description:TextFieldProxy;
      
      private var supportedGameModes:TextFieldProxy;
      
      private var spellImageSizer:SpriteProxy;
      
      private var exampleImageSizer:SpriteProxy;
      
      private var exampleImage:BitmapProxy;
      
      private var logger:ILogger = getLogger(this);
      
      public function SpellDetailsView(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("spellImageContainer",_loc1_);
         addChild(_loc1_);
         this.spellImageSizer = new SpriteProxy(this);
         setTimelineChildByName("spellImageSizer",this.spellImageSizer);
         this.spellImage = new BitmapProxy(this,new Bitmap());
         _loc1_.addChild(this.spellImage);
         this.nameText = new TextFieldProxy(this);
         setTimelineChildByName("nameText",this.nameText);
         this.requirements = new TextFieldProxy(this);
         setTimelineChildByName("requirements",this.requirements);
         this.description = new TextFieldProxy(this);
         setTimelineChildByName("description",this.description);
         this.supportedGameModes = new TextFieldProxy(this);
         setTimelineChildByName("supportedGameModes",this.supportedGameModes);
         var _loc2_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("exampleImageContainer",_loc2_);
         this.exampleImageSizer = new SpriteProxy(this);
         setTimelineChildByName("exampleImageSizer",this.exampleImageSizer);
         this.exampleImage = new BitmapProxy(this,new Bitmap());
         var _loc3_:ScalingTransformBehavior = new ScalingTransformBehavior();
         _loc3_.setMaintainAspectRatio(true);
         _loc3_.setScalePercentConstraints(new SizeConstraints(new MinMax(0,1),new MinMax(0,1)));
         _loc3_.setHorizontalAlign(HorizontalAlign.CENTER);
         _loc3_.setVerticalAlign(VerticalAlign.MIDDLE);
         this.exampleImage.setTransformBehavior(_loc3_);
         _loc2_.addChild(this.exampleImage);
         this.setModel(null);
      }
      
      public function setModel(param1:Spell) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:GameFlowVariant = null;
         if(param1 != null)
         {
            this.spellImage.setBitmapData(this.createBitmapData(ImagePackLookup.instance.getSpellSource(param1)));
            _loc2_ = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
            if(_loc2_)
            {
               fadeOut(this.exampleImage.getAsset());
            }
            this.exampleImage.setBitmapData(this.createBitmapData(ImagePackLookup.instance.getSpellScreenshotSource(param1)));
            _loc3_ = RiotResourceLoader.getSpellResourceString("name",param1.name,param1.name + "*");
            this.nameText.setText(_loc3_);
            _loc4_ = RiotResourceLoader.getSpellResourceString("description",param1.name,param1.description + "*");
            this.description.setText(_loc4_);
            _loc5_ = "(" + ResourceManager.getInstance().getString("resources","summoner_summonerInfo_summonerLevelLabel") + " " + param1.minLevel + ")";
            this.requirements.setText(_loc5_);
            _loc6_ = RiotResourceLoader.getString("summonerProfile_spells_supported_modes","Supported Game MODES") + " ";
            _loc7_ = uint(param1.gameModes.length);
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = GameFlowVariantFactory.instance.getVariant(null,param1.gameModes[_loc8_]);
               if(_loc9_.isEnabled())
               {
                  if(_loc8_ > 0)
                  {
                     _loc6_ += ", ";
                  }
                  _loc6_ += _loc9_.getGameFlowName();
               }
               _loc8_++;
            }
            this.supportedGameModes.setText(_loc6_);
         }
         else
         {
            this.nameText.setText("");
            this.description.setText("");
            this.supportedGameModes.setText("");
         }
      }
      
      private function createBitmapData(param1:Class) : BitmapData
      {
         var _loc2_:BitmapAsset = new param1();
         return _loc2_.bitmapData;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.spellImage.setExplicitSize(this.spellImageSizer.getWidth(),this.spellImageSizer.getHeight());
         this.exampleImage.setExplicitSize(this.exampleImageSizer.getWidth(),this.exampleImageSizer.getHeight());
         this.exampleImage.setExplicitPosition(this.exampleImageSizer.getX(),this.exampleImageSizer.getY());
         return super.updateLayout(param1,param2);
      }
   }
}

